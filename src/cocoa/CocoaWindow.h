/*
 * Copyright (c), Recep Aslantas.
 *
 * MIT License (MIT), http://opensource.org/licenses/MIT
 * Full license can be found in the LICENSE file
 */

#import <Cocoa/Cocoa.h>
#include "../types/impl_window.h"

NS_ASSUME_NONNULL_BEGIN

@interface CocoaWindow : NSWindow <NSWindowDelegate>

@property (nonatomic, assign) UIWindow *wnd;

@end

NS_ASSUME_NONNULL_END
