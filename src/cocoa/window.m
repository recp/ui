/*
 * Copyright (c), Recep Aslantas.
 *
 * MIT License (MIT), http://opensource.org/licenses/MIT
 * Full license can be found in the LICENSE file
 */

#import <AppKit/AppKit.h>
#include "../common.h"
#include "CocoaWindow.h"

NSUInteger
wndStyleToCocoa(int style) {
  NSUInteger cocoaWS;
  BOOL       borderless;

  cocoaWS = 0;
  if (style == kWindowStyleDefault) {
    cocoaWS = NSWindowStyleMaskTitled
               | NSWindowStyleMaskMiniaturizable
               | NSWindowStyleMaskResizable
               | NSWindowStyleMaskClosable;
    return cocoaWS;
  }


  borderless = false;

  if (style & kWindowStyleBorderless) {
    cocoaWS |= NSWindowStyleMaskBorderless;
    borderless = true;
  }

  if ((style & kWindowStyleTitled) || !borderless)
    cocoaWS |= NSWindowStyleMaskTitled;

  if (style & kWindowStyleFullscreen)
    cocoaWS |= NSWindowStyleMaskFullScreen;

  if (style & kWindowStyleCloseButton)
    cocoaWS |= NSWindowStyleMaskClosable;

  if (style & kWindowStyleMaximizeButton)
    cocoaWS |= NSWindowStyleMaskResizable;

  if (style & kWindowStyleMinimizeButton)
    cocoaWS |= NSWindowStyleMaskMiniaturizable;

  return cocoaWS;
}

UI_EXPORT
UIWindow*
uiCreateWindow(UISize size, UIWindowOptions * __restrict options) {
  UIWindow     *wnd;
  CocoaWindow  *nsWnd;
  NSInteger     windowMask;
  NSRect        screenRect, contentRect, consideredWndRect, _nsRect;
  double        originY;
  UIWindowStyle style;

  wnd               = calloc(1, sizeof(*wnd));
  style             = kWindowStyleDefault;
  windowMask        = wndStyleToCocoa(style);
  screenRect        = [[NSScreen mainScreen] visibleFrame];

  contentRect       = NSMakeRect(0, 0, size.width, size.height);
  consideredWndRect = [NSWindow frameRectForContentRect: contentRect
                                              styleMask: windowMask];
  originY           = screenRect.size.height
                        - screenRect.origin.y
                        - consideredWndRect.size.height;

  _nsRect = NSMakeRect(screenRect.origin.x ,
                       originY,
                       size.width,
                       size.height);

  nsWnd = [[CocoaWindow alloc] initWithContentRect: _nsRect
                                         styleMask: windowMask
                                           backing: NSBackingStoreBuffered
                                             defer: YES
                                            screen: NULL];

  wnd->size   = size;
  wnd->style  = style;
  wnd->native = nsWnd;

  return wnd;
}

UI_EXPORT
void
uiSetWindowStyle(UIWindow * __restrict wnd, UIWindowStyle style) {
  CocoaWindow *nsWnd;
  nsWnd = wnd->native;
  nsWnd.styleMask = wndStyleToCocoa(style);
}

UI_EXPORT
void
uiShowWindow(UIWindow * __restrict wnd) {
  CocoaWindow *nsWnd;

  nsWnd = wnd->native;

  [nsWnd makeKeyAndOrderFront: nsWnd];
  [NSApp activateIgnoringOtherApps: YES];
}
