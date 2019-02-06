/*
 * Copyright (c), Recep Aslantas.
 *
 * MIT License (MIT), http://opensource.org/licenses/MIT
 * Full license can be found in the LICENSE file
 */

#ifndef impl_app_h
#define impl_app_h

#include "../../include/ui/window.h"
#include "../../include/ui/app.h"

struct UIApp {
  UIWindow *rootWindow;
  void     *nativeApp;
};

#endif /* impl_app_h */
