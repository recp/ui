/*
 * Copyright (c), Recep Aslantas.
 *
 * MIT License (MIT), http://opensource.org/licenses/MIT
 * Full license can be found in the LICENSE file
 */

#ifndef ui_common_h
#define ui_common_h

#define _USE_MATH_DEFINES /* for windows */

#include <stdint.h>
#include <math.h>
#include <float.h>
#include <stdlib.h>
#include <string.h>

#if defined(_MSC_VER)
#  ifdef UI_DLL
#    define UI_EXPORT __declspec(dllexport)
#  else
#    define UI_EXPORT __declspec(dllimport)
#  endif
#  define UI_INLINE __forceinline
#else
#  define UI_EXPORT __attribute__((visibility("default")))
#  define UI_INLINE static inline __attribute((always_inline))
#endif

#endif /* ui_common_h */
