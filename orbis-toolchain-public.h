#ifndef ORBIS_TOOLCHAIN_PUBLIC
#if (defined(_WIN32) || defined(__CYGWIN__)) && defined(ORBIS_TOOLCHAIN_SHARED)
#define ORBIS_TOOLCHAIN_PUBLIC __declspec(dllimport)
#else
#define ORBIS_TOOLCHAIN_PUBLIC
#endif
#endif