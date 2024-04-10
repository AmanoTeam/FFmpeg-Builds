#!/bin/bash

declare -r FFMPEG_VERSION='7.0'
declare -r FFMPEG_SOURCE_DIRECTORY="/tmp/FFmpeg-release-${FFMPEG_VERSION}"
declare -r FFMPEG_BUILD_DIRECTORY="${FFMPEG_SOURCE_DIRECTORY}/build"
declare -r FFMPEG_INSTALL_PREFIX='/tmp/FFmpeg'

declare -r FFMPEG_DOWNLOAD_URL="https://github.com/FFmpeg/FFmpeg/archive/refs/heads/release/${FFMPEG_VERSION}.tar.gz"
declare -r FFMPEG_TARBALL='/tmp/ffmpeg.tar.gz'

declare -ra FFMPEG_BUILD_TARGETS=(
	'aarch64-tizeniot-linux-gnu'
	'aarch64-unknown-freebsd'
	'aarch64-unknown-linux-gnu'
	'aarch64-unknown-linux-musl'
	'aarch64-unknown-serenity'
	'alpha-unknown-linux-gnu'
	'alpha-unknown-netbsd'
	'alpha-unknown-openbsd'
	'arm-bookeen-linux-gnueabi'
	'arm-cervantes-linux-gnueabi'
	'arm-kindle-linux-gnueabi'
	'arm-kindle5-linux-gnueabi'
	'arm-kindlepw2-linux-gnueabi'
	'arm-obreey-linux-gnueabi'
	'arm-remarkable-linux-gnueabihf'
	'arm-tizeniot-linux-gnueabi'
	'arm-tizeniotheadless-linux-gnueabi'
	'arm-tizenmobile-linux-gnueabi'
	'arm-tizenwearable-linux-gnueabi'
	'arm-unknown-linux-gnueabi'
	'arm-unknown-linux-gnueabihf'
	'arm-unknown-linux-musleabihf'
	'armv7l-unknown-linux-musleabihf'
	'hppa-unknown-linux-gnu'
	'hppa-unknown-netbsd'
	# 'hppa-unknown-openbsd'
	'i386-tizenmobile-linux-gnueabi'
	'i386-tizenwearable-linux-gnueabi'
	'i386-unknown-freebsd'
	'i386-unknown-linux-gnu'
	'i386-unknown-linux-musl'
	'i386-unknown-netbsdelf'
	'i386-unknown-openbsd'
	'i586-unknown-haiku'
	'ia64-unknown-linux-gnu'
	'mips-unknown-linux-gnu'
	'mips-unknown-netbsd'
	'mips64-unknown-linux-musl'
	'mips64el-unknown-linux-gnuabi64'
	'mipsel-unknown-linux-gnu'
	'powerpc-unknown-freebsd'
	'powerpc-unknown-linux-gnu'
	'powerpc-unknown-netbsd'
	'powerpc64-unknown-freebsd'
	'powerpc64-unknown-freebsd_elfv2'
	'powerpc64le-unknown-linux-gnu'
	'powerpc64le-unknown-linux-musl'
	# 'riscv64-unknown-freebsd'
	'riscv64-unknown-linux-musl'
	's390-unknown-linux-gnu'
	's390x-unknown-linux-gnu'
	's390x-unknown-linux-musl'
	'shle-unknown-netbsdelf'
	'sparc-unknown-linux-gnu'
	'sparc-unknown-netbsdelf'
	'sparc64-unknown-freebsd'
	'sparc64-unknown-netbsd'
	# 'vax-unknown-netbsdelf'
	'x86_64-unknown-dragonfly'
	'x86_64-unknown-freebsd'
	'x86_64-unknown-haiku'
	'x86_64-unknown-linux-gnu'
	'x86_64-unknown-linux-musl'
	'x86_64-unknown-netbsd'
	'x86_64-unknown-openbsd'
	'x86_64-unknown-serenity'
)

if ! [ -d "${FFMPEG_SOURCE_DIRECTORY}" ]; then
	if ! [ -f "${FFMPEG_TARBALL}" ]; then
		wget "${FFMPEG_DOWNLOAD_URL}" \
			--output-document "${FFMPEG_TARBALL}"
	fi
	
	tar --directory="$(dirname "${FFMPEG_SOURCE_DIRECTORY}")" --extract --file="${FFMPEG_TARBALL}"
	
	unlink "${FFMPEG_TARBALL}"
fi

[ -d "${FFMPEG_BUILD_DIRECTORY}" ] || mkdir "${FFMPEG_BUILD_DIRECTORY}"

sed --in-place 's/#if HAVE_PRCTL/#if !defined(__serenity__) \&\& HAVE_PRCTL/g' "${FFMPEG_SOURCE_DIRECTORY}/libavutil/thread.h"

for target in "${FFMPEG_BUILD_TARGETS[@]}"; do
	echo "Building for ${target}"
	
	source "./toolchains/${target}.sh"
	
	declare extra_configure_flags=''
	declare os="${CROSS_COMPILE_SYSTEM}"
	
	if [ "${os}" = 'serenityos' ]; then
		os='none'
	fi
	
	if [ "${target}" = 'x86_64-unknown-linux-gnu' ]; then
		extra_configure_flags+='--enable-lto'
	fi
	
	pushd "${FFMPEG_BUILD_DIRECTORY}"
	
	LDFLAGS=-Wl,-rpath,\'\$\$\ORIGIN/../lib:\$\$\ORIGIN\' ../configure \
		--prefix="${FFMPEG_INSTALL_PREFIX}/${target}" \
		--cross-prefix="${CROSS_COMPILE_TRIPLET}-" \
		--target-os="${os}" \
		--arch="${CROSS_COMPILE_ARCHITECTURE}" \
		--disable-alsa \
		--disable-appkit \
		--disable-asm \
		--disable-audiotoolbox \
		--disable-avfoundation \
		--disable-bzlib \
		--disable-coreimage \
		--disable-debug \
		--disable-doc \
		--disable-iconv \
		--disable-libxcb \
		--disable-lzma \
		--disable-neon \
		--disable-schannel \
		--disable-sdl2 \
		--disable-securetransport \
		--disable-static \
		--disable-symver \
		--disable-videotoolbox \
		--disable-vulkan \
		--disable-xlib \
		--disable-zlib \
		--disable-manpages \
		--disable-htmlpages \
		--disable-podpages \
		--disable-txtpages \
		--enable-pic \
		--enable-shared \
		--enable-small \
		--enable-version3 \
		--extra-cflags=-Dstatic_assert=_Static_assert \
		--extra-ldflags=-fPIC \
		${extra_configure_flags}
	
	make --jobs > /dev/null
	make install
	
	pushd
	pushd "${FFMPEG_INSTALL_PREFIX}"
	
	declare tarball="${FFMPEG_INSTALL_PREFIX}/${target}.tar.xz"
	
	tar --create --file=- "${target}" |  xz --compress -9 > "${tarball}"
	rm --recursive --force "${target}"
	
	sha256sum "${tarball}" | sed "s|${FFMPEG_INSTALL_PREFIX}/||" > "${tarball}.sha256"
	
	pushd
	
	rm --recursive --force "${FFMPEG_BUILD_DIRECTORY}/"*
done
