/*
 * Copyright (c), Recep Aslantas.
 *
 * MIT License (MIT), http://opensource.org/licenses/MIT
 * Full license can be found in the LICENSE file
 */

#import <AppKit/AppKit.h>

#include "../../include/ui/window.h"
#include "../types/impl_app.h"
#include "../types/impl_window.h"
#include "CocoaApp.h"
#include "CocoaWindow.h"

UI_EXPORT
UIApp*
uiCreateApp(UIWindow *rootWindow) {
  UIApp    *app;
  CocoaApp *nsApp;

  app   = calloc(1, sizeof(*app));
  nsApp = [NSApplication sharedApplication];

  [nsApp setDelegate: nsApp];
  [nsApp setActivationPolicy: NSApplicationActivationPolicyRegular];

  app->nativeApp  = nsApp;
  app->rootWindow = rootWindow;

  return app;
}

UI_EXPORT
void
uiRunApp(UIApp *app) {
  CocoaApp *nsApp;
  UIWindow *wnd;

  wnd   = app->rootWindow;
  nsApp = app->nativeApp;

  if (!wnd->showed)
    uiShowWindow(wnd);

  [nsApp activateIgnoringOtherApps: NO];
  [nsApp run];
}
