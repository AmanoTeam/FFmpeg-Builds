#!/bin/bash

set -eu

CROSS_COMPILE_TRIPLET='arm-kobo-linux-gnueabihf'
CROSS_COMPILE_SYSTEM='linux'
CROSS_COMPILE_ARCHITECTURE='arm'

CC="${KAL_HOME}/bin/${CROSS_COMPILE_TRIPLET}-gcc"
CXX="${KAL_HOME}/bin/${CROSS_COMPILE_TRIPLET}-g++"
AR="${KAL_HOME}/bin/${CROSS_COMPILE_TRIPLET}-ar"
AS="${KAL_HOME}/bin/${CROSS_COMPILE_TRIPLET}-as"
LD="${KAL_HOME}/bin/${CROSS_COMPILE_TRIPLET}-ld"
NM="${KAL_HOME}/bin/${CROSS_COMPILE_TRIPLET}-nm"
RANLIB="${KAL_HOME}/bin/${CROSS_COMPILE_TRIPLET}-ranlib"
STRIP="${KAL_HOME}/bin/${CROSS_COMPILE_TRIPLET}-strip"
OBJCOPY="${KAL_HOME}/bin/${CROSS_COMPILE_TRIPLET}-objcopy"
READELF="${KAL_HOME}/bin/${CROSS_COMPILE_TRIPLET}-readelf"

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
