#!/bin/bash
set -e

PREFIX="${1:?Expected install prefix argument}"
PATCHELF="${PATCHELF:-patchelf}"
THEROCK_SOURCE_DIR="${THEROCK_SOURCE_DIR:?THEROCK_SOURCE_DIR not defined}"
Python3_EXECUTABLE="${Python3_EXECUTABLE:?Python3_EXECUTABLE not defined}"

"$Python3_EXECUTABLE" "$THEROCK_SOURCE_DIR/build_tools/patch_linux_so.py" \
  --patchelf "${PATCHELF}" --add-prefix rocm_sysdeps_ \
    $PREFIX/lib/libelf.so \
    $PREFIX/lib/libdw.so \
    $PREFIX/lib/libasm.so

# pc files are not output with a relative prefix. Sed it to relative.
sed -i -E 's|^prefix=.+|prefix=${pcfiledir}/../..|' $PREFIX/lib/pkgconfig/*.pc

# We don't need old v0 compat libs.
rm -f $PREFIX/lib/*-0.so

# We don't want the static libs.
rm $PREFIX/lib/*.a

# We don't need the programs.
rm -Rf $PREFIX/bin
