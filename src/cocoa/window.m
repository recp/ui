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
  bool       borderless;

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

  wnd->size          = size;
  wnd->style         = style;
  wnd->native        = nsWnd;
  wnd->closeBehavior = kCloseBehaviorExit; /* default */
  nsWnd.wnd          = wnd;

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

UI_EXPORT
const char*
uiWindowTitle(UIWindow * __restrict wnd) {
  CocoaWindow *nsWnd;
  NSString    *nsTitle;

  nsWnd = wnd->native;

  nsTitle = [nsWnd title];
  return [nsTitle cStringUsingEncoding: NSUTF8StringEncoding];
}

UI_EXPORT
void
uiSetWindowTitle(UIWindow * __restrict wnd, const char * __restrict title) {
  CocoaWindow *nsWnd;

  nsWnd = wnd->native;

  [nsWnd setTitle: [NSString stringWithCString: title
                                      encoding: NSUTF8StringEncoding]];
}

UI_EXPORT
void
uiHideWindow(UIWindow * __restrict wnd) {
  CocoaWindow *nsWnd;

  nsWnd = wnd->native;

  [nsWnd orderOut: nsWnd];
}

UI_EXPORT
void
uiCenterWindow(UIWindow * __restrict wnd) {
  CocoaWindow *nsWnd;
  NSRect       nsFrm;

  nsWnd = wnd->native;
  nsFrm = [[nsWnd screen] frame];

  nsFrm.origin.x = (nsFrm.size.width  - nsWnd.frame.size. width) * 0.5;
  nsFrm.origin.y = (nsFrm.size.height - nsWnd.frame.size.height) * 0.5;

  [nsWnd setFrameOrigin: nsFrm.origin];
}

UI_EXPORT
bool
uiIsFullScreen(UIWindow * __restrict wnd) {
  return wnd->fullscreen;
}

UI_EXPORT
void
uiEnterFullScreen(UIWindow * __restrict wnd) {
  CocoaWindow *nsWnd;

  if (wnd->fullscreen)
    return;

  nsWnd = wnd->native;

  [nsWnd setCollectionBehavior: NSWindowCollectionBehaviorFullScreenPrimary];
  [nsWnd toggleFullScreen: nil];
}

UI_EXPORT
void
uiExitFullScreen(UIWindow * __restrict wnd) {
  CocoaWindow *nsWnd;

  if (wnd->fullscreen)
    return;

  nsWnd = wnd->native;

  [nsWnd toggleFullScreen: nil];
}

UI_EXPORT
UIRect
uiGetWindowFrame(UIWindow * __restrict wnd) {
  CocoaWindow *nsWnd;

  nsWnd = wnd->native;

  return (UIRect){{nsWnd.frame.origin.x, nsWnd.frame.origin.y},
                  {nsWnd.frame.size.width, nsWnd.frame.size.height}};
}

UI_EXPORT
void
uiSetWindowFrame(UIWindow * __restrict wnd, UIRect frame, bool animate) {
  CocoaWindow *nsWnd;

  nsWnd = wnd->native;
  [nsWnd setFrame: NSMakeRect(frame.origin.x,
                              frame.origin.y,
                              frame.size.width,
                              frame.size.height)
          display: YES
          animate: animate];
}

UI_EXPORT
UICloseBehavior
uiGetCloseBehavior(UIWindow * __restrict wnd) {
  return wnd->closeBehavior;
}

UI_EXPORT
void
uiSetCloseBehavior(UIWindow * __restrict wnd, UICloseBehavior behavior) {
  wnd->closeBehavior = behavior;
}
