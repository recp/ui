/*
 * Copyright (c), Recep Aslantas.
 *
 * MIT License (MIT), http://opensource.org/licenses/MIT
 * Full license can be found in the LICENSE file
 */

#ifndef impl_window_h
#define impl_window_h

#include "../../include/ui/window.h"

struct UIWindow {
  void           *native;
  UISize          size;
  int             style;
  UICloseBehavior closeBehavior;
  bool            showed;
  bool            fullscreen;
};

#endif /* impl_window_h */
