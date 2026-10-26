#!/usr/bin/env bash
# patch-redroid-gralloc.sh
#
# Patches redroid's gralloc.gbm.so to fix the SIGFPE (integer divide-by-zero)
# crash in gralloc_gbm_bo_create for pixel formats >= 0x2B (e.g. RGBA_1010102).
# Upstream: https://github.com/remote-android/redroid-doc/issues/930
#
# Patch: offset 0x57d2, bytes 31 C9 -> B1 04 (bpp=0 -> bpp=4)
#
# Usage:
#   patch-redroid-gralloc.sh [-i INPUT.so] [-o OUTPUT.so] [-c CONTAINER] [-n] [-h]
#
#   -i  input .so file. If omitted, extracts from CONTAINER when running,
#       otherwise from the stock image (default: redroid/redroid:15.0.0-latest).
#   -o  output file. Default: <input>.patched.so
#   -c  container name (default: redroid15). Used for extraction when -i is
#       omitted, and the patched lib is applied to it when it is running.
#   -n  do not apply into the container; only write the patched file.
#   -h  show this help.
#
# Examples:
#   patch-redroid-gralloc.sh                       # extract from redroid15, patch, apply
#   patch-redroid-gralloc.sh -n                    # patch file only, don't touch container
#   patch-redroid-gralloc.sh -i gralloc.gbm.so     # patch a local file
#   patch-redroid-gralloc.sh -c my-redroid         # use another container
#
# Notes:
#   - Restart the container after applying (docker restart <name>).
#   - This fixes only the gralloc crash. If you rebuilt from a stock image,
#     also add the boot arg androidboot.redroid_gpu_node=/dev/dri/renderD128
#     (pick your iGPU node) and disable the emulator Bluetooth app to stop the
#     SystemUI crash loop:
#       adb shell pm disable-user --user 0 com.android.bluetooth

set -euo pipefail

OFFSET=0x57d2
OLD_HEX=31c9
NEW_HEX=b104
STOCK_IMAGE=redroid/redroid:15.0.0-latest

INPUT=""
OUTPUT=""
CONTAINER=redroid15
APPLY=1

usage() { sed -n '2,/^$/p' "$0" | sed 's/^# \{0,1\}//'; exit "${1:-0}"; }

while getopts ":i:o:c:nh" opt; do
    case "$opt" in
        i) INPUT=$OPTARG ;;
        o) OUTPUT=$OPTARG ;;
        c) CONTAINER=$OPTARG ;;
        n) APPLY=0 ;;
        h) usage 0 ;;
        *) echo "Unknown option: -$OPTARG" >&2; usage 1 ;;
    esac
done

die() { echo "ERROR: $*" >&2; exit 1; }

# Use sudo for docker if the socket isn't accessible as the current user.
if docker info >/dev/null 2>&1; then
    DOCKER=(docker)
elif sudo -n docker info >/dev/null 2>&1; then
    DOCKER=(sudo docker)
else
    DOCKER=(docker)   # try plain docker; commands will report the real error
fi

is_running() {
    "${DOCKER[@]}" ps --format '{{.Names}}' 2>/dev/null | grep -qx -- "$CONTAINER"
}

# --- Resolve input ----------------------------------------------------------
TMP_DIR=""
TMP_CTR=""
cleanup() {
    [ -n "$TMP_CTR" ] && "${DOCKER[@]}" rm -f "$TMP_CTR" >/dev/null 2>&1 || true
    [ -n "$TMP_DIR" ] && rm -rf "$TMP_DIR" || true
}
trap cleanup EXIT

if [ -z "$INPUT" ]; then
    TMP_DIR=$(mktemp -d)
    INPUT="$TMP_DIR/gralloc.gbm.so"
    if is_running; then
        echo "Extracting gralloc.gbm.so from running container '$CONTAINER'..."
        "${DOCKER[@]}" cp "$CONTAINER:/vendor/lib64/hw/gralloc.gbm.so" "$INPUT" \
            || die "could not extract from container '$CONTAINER'"
    else
        echo "Container '$CONTAINER' not running; extracting from image '$STOCK_IMAGE'..."
        TMP_CTR="gralloc-extract-$$"
        "${DOCKER[@]}" create --name "$TMP_CTR" "$STOCK_IMAGE" >/dev/null \
            || die "could not create temporary container from '$STOCK_IMAGE'"
        "${DOCKER[@]}" cp "$TMP_CTR:/vendor/lib64/hw/gralloc.gbm.so" "$INPUT" \
            || die "could not extract from image '$STOCK_IMAGE'"
    fi
fi

[ -f "$INPUT" ] || die "input file not found: $INPUT"

# --- Resolve output ---------------------------------------------------------
if [ -z "$OUTPUT" ]; then
    if [ -n "$TMP_DIR" ]; then
        # input was extracted into a temp dir that gets cleaned up on exit
        OUTPUT="./gralloc.gbm.patched.so"
    else
        OUTPUT="${INPUT%.so}.patched.so"
    fi
fi

# --- Verify + patch ---------------------------------------------------------
python3 - "$INPUT" "$OUTPUT" "$OFFSET" "$OLD_HEX" "$NEW_HEX" <<'PY' || exit 1
import sys

src, dst, off, old, new = (
    sys.argv[1], sys.argv[2], int(sys.argv[3], 16),
    bytes.fromhex(sys.argv[4]), bytes.fromhex(sys.argv[5]),
)

with open(src, "rb") as fh:
    data = bytearray(fh.read())

if len(data) < off + 2:
    sys.exit(f"ERROR: {src} is too small ({len(data)} bytes) for offset 0x{off:x}")

current = bytes(data[off:off + 2])
if current == old:
    data[off:off + 2] = new
    status = "patched"
elif current == new:
    status = "already patched (no change)"
else:
    sys.exit(
        f"ERROR: unexpected bytes {current.hex()} at 0x{off:x} in {src}; "
        "not a known gralloc.gbm.so build, refusing to patch"
    )

with open(dst, "wb") as fh:
    fh.write(data)

print(f"{status}: wrote {dst} ({len(data)} bytes), 0x{off:x}: "
      f"{current.hex()} -> {bytes(data[off:off + 2]).hex()}")
PY

# Verify the written file
verify() {
    python3 - "$1" "$OFFSET" "$NEW_HEX" <<'PY'
import sys
path, off, want = sys.argv[1], int(sys.argv[2], 16), bytes.fromhex(sys.argv[3])
with open(path, "rb") as fh:
    fh.seek(off)
    got = fh.read(2)
if got != want:
    sys.exit(f"verification failed for {path}: expected {want.hex()}, got {got.hex()}")
PY
}
verify "$OUTPUT" || die "post-patch verification failed for $OUTPUT"

# --- Apply to container -----------------------------------------------------
if [ "$APPLY" = "1" ] && is_running; then
    echo "Applying patched library to container '$CONTAINER'..."
    "${DOCKER[@]}" cp "$OUTPUT" "$CONTAINER:/vendor/lib64/hw/gralloc.gbm.so" \
        || die "could not copy patched library into '$CONTAINER'"

    inside=$("${DOCKER[@]}" exec "$CONTAINER" od -An -tx1 -j "$OFFSET" -N 2 \
             /vendor/lib64/hw/gralloc.gbm.so | tr -d ' \n')
    [ "$inside" = "$NEW_HEX" ] \
        || die "verification inside container failed (found '$inside')"
    echo "Applied and verified inside '$CONTAINER'."
    echo "Restart it to load the patched library:  docker restart $CONTAINER"
else
    [ "$APPLY" = "1" ] && echo "Container '$CONTAINER' is not running; patch not applied."
    echo "Patched file: $OUTPUT"
fi
