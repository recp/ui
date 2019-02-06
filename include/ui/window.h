/*
 * Copyright (c), Recep Aslantas.
 *
 * MIT License (MIT), http://opensource.org/licenses/MIT
 * Full license can be found in the LICENSE file
 */

#ifndef ui_window_h
#define ui_window_h

#include "common.h"

typedef struct UIWindow    UIWindow;
typedef struct UIGLContext UIGLContext;

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

typedef enum UIWindowCloseBehavior {
  kWindowCloseBehavior_None,
  kWindowCloseBehavior_AppShouldExit
} UIWindowCloseBehavior;

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
uiSetWindowStyle(UIWindow * __restrict wnd, UIWindowStyle style);

#endif /* ui_window_h */
