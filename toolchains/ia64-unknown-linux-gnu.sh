#!/bin/bash

set -eu

CROSS_COMPILE_TRIPLET='ia64-unknown-linux-gnu'
CROSS_COMPILE_SYSTEM='linux'
CROSS_COMPILE_ARCHITECTURE='ia64'

CC="${LAX_HOME}/bin/${CROSS_COMPILE_TRIPLET}-gcc"
CXX="${LAX_HOME}/bin/${CROSS_COMPILE_TRIPLET}-g++"
AR="${LAX_HOME}/bin/${CROSS_COMPILE_TRIPLET}-ar"
AS="${LAX_HOME}/bin/${CROSS_COMPILE_TRIPLET}-as"
LD="${LAX_HOME}/bin/${CROSS_COMPILE_TRIPLET}-ld"
NM="${LAX_HOME}/bin/${CROSS_COMPILE_TRIPLET}-nm"
RANLIB="${LAX_HOME}/bin/${CROSS_COMPILE_TRIPLET}-ranlib"
STRIP="${LAX_HOME}/bin/${CROSS_COMPILE_TRIPLET}-strip"
OBJCOPY="${LAX_HOME}/bin/${CROSS_COMPILE_TRIPLET}-objcopy"
READELF="${LAX_HOME}/bin/${CROSS_COMPILE_TRIPLET}-readelf"

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
