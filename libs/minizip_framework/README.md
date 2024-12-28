# minizip framework

An [Apple framework][1] bundle for the [minizip-ng][2] library.

[1]: https://developer.apple.com/library/archive/documentation/MacOSX/Conceptual/BPFrameworks/Frameworks.html
[2]: https://github.com/zlib-ng/minizip-ng

## Background

The minizip-ng library is a zip file manipulation library written in C.  While
it has a [CMake][10] build system that is capable of generating an Xcode
project, the generated project [does not easily compose][11] with other Xcode
projects and workspaces, and it does not easily support building a
multiplatform library.

This project contains the source distribution of minizip-ng 4.0.7 and adds a
purpose-built Xcode framework project, the [`<minizip/minizip.h>`][12]
[umbrella header][13] and [a patch to `mz_os.h`][14] that fixes an Apple
[`modules-verifier` error][15]. 

[10]: https://cmake.org
[11]: https://gitlab.kitware.com/cmake/cmake/-/issues/24408
[12]: ./minizip/minizip.h
[13]: https://developer.apple.com/library/archive/documentation/MacOSX/Conceptual/BPFrameworks/Tasks/IncludingFrameworks.html
[14]: ./patches/mz_os.h.diff
[15]: https://developer.apple.com/documentation/xcode/identifying-and-addressing-framework-module-issues

The minizip framework is a static, multiplatform library containing a fat
binary containing both arm64 and x86_64 architectures.  The Apple Developer
site artices ["Creating a static framework"][20] and ["Creating a multiplatform
binary framework bundle"][21] describe how to set up an Xcode project for this
type of framework.

[20]: https://developer.apple.com/documentation/xcode/creating-a-static-framework
[21]: https://developer.apple.com/documentation/xcode/creating-a-static-framework

## License

The minizip framework is made available under the [zlib license][30].  See the
[`LICENSE`][31] file for details.

[30]: https://en.wikipedia.org/wiki/Zlib_License
[31]: ./LICENSE

## Xcode Project Construction

The Xcode framework project uses minizip-ng's CMake build system as a guide.
The CMake command used to generate the Xcode project is:

    cmake -G "Xcode" \
          -DCMAKE_SYSTEM_NAME=Darwin \
          -DCMAKE_OSX_DEPLOYMENT_TARGET=10.15 \
          -DCMAKE_OSX_ARCHITECTURES="arm64;x86_64" \
          -DBUILD_SHARED_LIBS=OFF \
          -DMZ_COMPAT=OFF \
          -DMZ_OPENSSL=OFF \
          -DMZ_LZMA=OFF \
          -DMZ_ZSTD=OFF \
          -S <minizip-ng source dir> \
          -B <project output dir>

The resulting project builds these source files:

    mz_crypt.c
    mz_crypt_apple.c
    mz_os.c
    mz_os_posix.c
    mz_strm.c

    mz_strm_buf.c
    mz_strm_bzip.c
    mz_strm_libcomp.c
    mz_strm_mem.c
    mz_strm_os_posix.c

    mz_strm_pkcrypt.c
    mz_strm_split.c
    mz_strm_wzaes.c
    mz_zip.c
    mz_zip_rw.c
 
with these preprocessor definitions:

    HAVE_ARC4RANDOM_BUF
    HAVE_BZIP2
    HAVE_ICONV
    HAVE_INTTYPES_H
    HAVE_LIBCOMP
    HAVE_PKCRYPT
    HAVE_STDINT_H
    HAVE_WZAES

linking against these frameworks and libraries:

    libbz2.tbd
    libcompression.tbd
    libiconv.tbd
    Security.framework (Do Not Embed)
