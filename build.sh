#!/usr/bin/env bash
# =============================================================================
# build.sh - Build script for DOS Maze Game
# =============================================================================
# Requirements:
#   - NASM (Netwide Assembler) installed and on PATH
#   - DOSBox (optional) for running the output
#
# Usage:
#   chmod +x build.sh
#   ./build.sh
# =============================================================================

set -e

SRC="src/maze.asm"
OUT="build/maze.com"

echo "[*] Assembling $SRC -> $OUT ..."
nasm -f bin "$SRC" -o "$OUT"

echo "[+] Build successful: $OUT"
echo ""
echo "To run in DOSBox:"
echo "  dosbox $OUT"
echo ""
echo "Or mount and run manually inside DOSBox:"
echo "  mount c ."
echo "  c:"
echo "  cd build"
echo "  maze.com"
