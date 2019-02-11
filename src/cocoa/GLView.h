/*
 * Copyright (c), Recep Aslantas.
 *
 * MIT License (MIT), http://opensource.org/licenses/MIT
 * Full license can be found in the LICENSE file
 */

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@protocol GLViewDelegate;

@interface GLView : NSView {
  NSOpenGLContext     * m_openGLContext;
  NSOpenGLPixelFormat * m_pixelFormat;
  CVDisplayLinkRef      m_displink;
  const CVTimeStamp   * m_lasOutputTime;
}

+ (NSOpenGLPixelFormat *)defaultPixelFormat;

- (id)initWithFrame:(NSRect)frameRect
        pixelFormat:(NSOpenGLPixelFormat *)format;

- (void)setOpenGLContext:(NSOpenGLContext *)context;
- (NSOpenGLContext *)openGLContext;

- (void)setPixelFormat:(NSOpenGLPixelFormat *)pixelFormat;
- (NSOpenGLPixelFormat *)pixelFormat;

- (void)clearGLContext;
- (void)syncWithCurrentDisplay;
- (void)update;
- (void)reshape;
- (void)start;
- (void)stop;

@property (nonatomic, assign) BOOL started;
@property (nonatomic, assign) id<GLViewDelegate> delegate;

@end

@protocol GLViewDelegate <NSObject>
@required
- (void)render;
- (void)reshape;
@end

NS_ASSUME_NONNULL_END
