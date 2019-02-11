/*
 * Copyright (c), Recep Aslantas.
 *
 * MIT License (MIT), http://opensource.org/licenses/MIT
 * Full license can be found in the LICENSE file
 */

#ifndef ui_geometrictypes_h
#define ui_geometrictypes_h

#include "common.h"

typedef struct UIPoint {
  float x;
  float y;
} UIPoint;

typedef struct UISize {
  float width;
  float height;
} UISize;

typedef struct UIRect {
  UIPoint origin;
  UISize  size;
} UIRect;

#endif /* ui_geometrictypes_h */
