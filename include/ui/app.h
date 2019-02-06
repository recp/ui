/*
 * Copyright (c), Recep Aslantas.
 *
 * MIT License (MIT), http://opensource.org/licenses/MIT
 * Full license can be found in the LICENSE file
 */

#ifndef ui_app_h
#define ui_app_h

#include "common.h"
#include "window.h"

typedef struct UIApp UIApp;

UI_EXPORT
UIApp*
uiCreateApp(UIWindow *rootWindow);

UI_EXPORT
void
uiRunApp(UIApp *app);

#endif /* ui_app_h */
