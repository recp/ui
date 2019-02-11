/*
 * Copyright (c), Recep Aslantas.
 *
 * MIT License (MIT), http://opensource.org/licenses/MIT
 * Full license can be found in the LICENSE file
 */

#import "CocoaWindow.h"

@implementation CocoaWindow

- (instancetype)initWithContentRect:(NSRect)contentRect
                          styleMask:(NSWindowStyleMask)style
                            backing:(NSBackingStoreType)backingStoreType
                              defer:(BOOL)flag screen:(NSScreen *)screen {
  self = [super initWithContentRect: contentRect
                          styleMask: style
                            backing: backingStoreType defer: flag
                             screen: screen];
  if (self) {
    [self commonInit];
  }

  return self;
}

- (instancetype)initWithContentRect:(NSRect)contentRect
                          styleMask:(NSWindowStyleMask)style
                            backing:(NSBackingStoreType)backingStoreType
                              defer:(BOOL)flag {
  self = [super initWithContentRect: contentRect
                          styleMask: style
                            backing: backingStoreType
                              defer: flag];
  if (self) {
    [self commonInit];
  }

  return self;
}

- (void) commonInit {
  self.delegate = self;
}

- (BOOL) canBecomeKeyWindow {
  return YES;
}

- (BOOL) canBecomeMainWindow {
  return YES;
}

#pragma mark - Window Delegate

- (void) windowWillClose:(NSNotification *)notification {
  if (self.wnd->closeBehavior == kCloseBehaviorExit) {
    [[NSApplication sharedApplication] terminate: nil];
  }
}

- (void)windowDidEnterFullScreen:(NSNotification *)notification {
  self.wnd->fullscreen = true;
}

- (void)windowDidExitFullScreen:(NSNotification *)notification {
  self.wnd->fullscreen = false;
}

@end
