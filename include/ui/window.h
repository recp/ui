/*
 * Copyright (c), Recep Aslantas.
 *
 * MIT License (MIT), http://opensource.org/licenses/MIT
 * Full license can be found in the LICENSE file
 */

#ifndef ui_window_h
#define ui_window_h

#include "common.h"
#include "geometric.h"

typedef struct UIWindow UIWindow;

typedef enum UIWindowSurface {
  kUIWindowSurfaceDefault = 0,
  kUIWindowSurfaceOpenGL  = 1,
  kUIWindowSurfaceMetal   = 2,
  kUIWindowSurfaceVulkan  = 3
} UIWindowSurface;

typedef enum UIWindowStyle {
  kWindowStyleDefault        = 0,
  kWindowStyleTitled         = 1 << 0,
  kWindowStyleBorderless     = 1 << 1,
  kWindowStyleFullscreen     = 1 << 2,

  kWindowStyleCloseButton    = 1 << 3,
  kWindowStyleMinimizeButton = 1 << 4,
  kWindowStyleMaximizeButton = 1 << 5,
  kWindowStyleAllButtons     = kWindowStyleCloseButton
                             | kWindowStyleMinimizeButton
                             | kWindowStyleMaximizeButton
} UIWindowStyle;

typedef enum UICloseBehavior {
  kCloseBehaviorNone = 0,
  kCloseBehaviorExit = 1
} UICloseBehavior;

typedef struct UIWindowOptions {
  UIWindowStyle   style;
  UIWindowSurface surface;
} UIWindowOptions;

UI_EXPORT
UIWindow*
uiCreateWindow(UISize size, UIWindowOptions * __restrict options);

UI_EXPORT
void
uiShowWindow(UIWindow * __restrict wnd);

UI_EXPORT
void
uiHideWindow(UIWindow * __restrict wnd);

UI_EXPORT
void
uiSetWindowStyle(UIWindow * __restrict wnd, UIWindowStyle style);

UI_EXPORT
const char*
uiWindowTitle(UIWindow * __restrict wnd);

UI_EXPORT
void
uiSetWindowTitle(UIWindow * __restrict wnd, const char * __restrict title);

UI_EXPORT
void
uiCenterWindow(UIWindow * __restrict wnd);

UI_EXPORT
bool
uiIsFullScreen(UIWindow * __restrict wnd);

UI_EXPORT
void
uiEnterFullScreen(UIWindow * __restrict wnd);

UI_EXPORT
void
uiExitFullScreen(UIWindow * __restrict wnd);

UI_EXPORT
UIRect
uiGetWindowFrame(UIWindow * __restrict wnd);

UI_EXPORT
void
uiSetWindowFrame(UIWindow * __restrict wnd, UIRect frame, bool animate);

UI_EXPORT
UICloseBehavior
uiGetCloseBehavior(UIWindow * __restrict wnd);

UI_EXPORT
void
uiSetCloseBehavior(UIWindow * __restrict wnd, UICloseBehavior behavior);

#endif /* ui_window_h */
