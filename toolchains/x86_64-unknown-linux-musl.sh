#!/bin/bash

set -eu

CROSS_COMPILE_TRIPLET='x86_64-unknown-linux-musl'
CROSS_COMPILE_SYSTEM='linux'
CROSS_COMPILE_ARCHITECTURE='x86_64'

CC="${RAIDEN_HOME}/bin/${CROSS_COMPILE_TRIPLET}-gcc"
CXX="${RAIDEN_HOME}/bin/${CROSS_COMPILE_TRIPLET}-g++"
AR="${RAIDEN_HOME}/bin/${CROSS_COMPILE_TRIPLET}-ar"
AS="${RAIDEN_HOME}/bin/${CROSS_COMPILE_TRIPLET}-as"
LD="${RAIDEN_HOME}/bin/${CROSS_COMPILE_TRIPLET}-ld"
NM="${RAIDEN_HOME}/bin/${CROSS_COMPILE_TRIPLET}-nm"
RANLIB="${RAIDEN_HOME}/bin/${CROSS_COMPILE_TRIPLET}-ranlib"
STRIP="${RAIDEN_HOME}/bin/${CROSS_COMPILE_TRIPLET}-strip"
OBJCOPY="${RAIDEN_HOME}/bin/${CROSS_COMPILE_TRIPLET}-objcopy"
READELF="${RAIDEN_HOME}/bin/${CROSS_COMPILE_TRIPLET}-readelf"

export CROSS_COMPILE_TRIPLET \
	CC \
	CXX \
	AR \
	AS \
	LD \
	NM \
	RANLIB \
	STRIP \
	OBJCOPY \
	READELF
