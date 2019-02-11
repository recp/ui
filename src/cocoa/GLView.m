/*
 * Copyright (c), Recep Aslantas.
 *
 * MIT License (MIT), http://opensource.org/licenses/MIT
 * Full license can be found in the LICENSE file
 */

#import "GLView.h"
#import <OpenGL/OpenGL.h>
#import <OpenGL/gl3.h>

#define PixelFormatAttrib(...) __VA_ARGS__

static
CVReturn
displink_refresh(CVDisplayLinkRef    CV_NONNULL  displayLink,
                 const CVTimeStamp * CV_NONNULL  inNow,
                 const CVTimeStamp * CV_NONNULL  inOutputTime,
                 CVOptionFlags                   flagsIn,
                 CVOptionFlags     * CV_NONNULL  flagsOut,
                 void              * CV_NULLABLE displayLinkContext);

@implementation GLView

- (void) initDetails {
  NSNotificationCenter *ntfcenter;

  [self setWantsBestResolutionOpenGLSurface: YES];
  [self setPostsFrameChangedNotifications: YES];

  ntfcenter = [NSNotificationCenter defaultCenter];
  [ntfcenter addObserver: self
                selector: @selector(_surfaceNeedsUpdate:)
                    name: NSViewGlobalFrameDidChangeNotification
                  object: self];

  [ntfcenter addObserver: self
                selector: @selector(_surfaceNeedsUpdate:)
                    name: NSViewFrameDidChangeNotification
                  object: self];

  [self syncWithCurrentDisplay];
}

- (instancetype)initWithCoder:(NSCoder *)coder {
  self = [super initWithCoder: coder];

  if (self) {
    if ([coder allowsKeyedCoding]) {
      id pformat = [coder decodeObjectForKey: @"NSPixelFormat"];
      if (!pformat)
        pformat = [[self class] defaultPixelFormat];

      [self setPixelFormat: pformat];
    } else {
      [self setPixelFormat: [[self class] defaultPixelFormat]];
    }

    [self initDetails];
  }

  return self;
}

- (instancetype)initWithFrame:(NSRect)frameRect {
  return [self initWithFrame: self.frame
                 pixelFormat: [[self class] defaultPixelFormat]];
}

- (instancetype)initWithFrame:(NSRect)frameRect
                  pixelFormat:(NSOpenGLPixelFormat *)format {

  self = [super initWithFrame:frameRect];

  if (self) {
    [self setPixelFormat: format];
    [self initDetails];
  }

  return self;
}

- (BOOL)isFlipped {
  return NO;
}

- (BOOL)mouseDownCanMoveWindow {
  return NO;
}

- (void) _surfaceNeedsUpdate:(NSNotification *)notification {
  [[self openGLContext] makeCurrentContext];
  [self update];
  [self reshape];
}

- (void)lockFocus {
  NSOpenGLContext *context;
  [super lockFocus];

  context = [self openGLContext];

  if ([context view] != self) {
    [context setView: self];
  }
}

- (void) viewDidMoveToWindow {
  [super viewDidMoveToWindow];

  if (!self.window) {
    [[self openGLContext] clearDrawable];
    return;
  }

  [self.openGLContext setView: self];
}

#pragma mark -

+ (NSOpenGLPixelFormat *)defaultPixelFormat {
  static NSOpenGLPixelFormat *pixelFormat;

  if (pixelFormat)
    return pixelFormat;

  NSOpenGLPixelFormatAttribute attribs[] = {
    PixelFormatAttrib(NSOpenGLPFADoubleBuffer),
    PixelFormatAttrib(NSOpenGLPFAAccelerated),
    PixelFormatAttrib(NSOpenGLPFABackingStore, YES),
    PixelFormatAttrib(NSOpenGLPFAColorSize, 24),
    PixelFormatAttrib(NSOpenGLPFADepthSize, 24),
    PixelFormatAttrib(NSOpenGLPFAAlphaSize, 8),
    PixelFormatAttrib(NSOpenGLPFAOpenGLProfile),
    PixelFormatAttrib(NSOpenGLProfileVersion3_2Core),
    PixelFormatAttrib(NSOpenGLPFASampleBuffers, 1),
    PixelFormatAttrib(NSOpenGLPFASamples, 4),
    PixelFormatAttrib(NSOpenGLPFASupersample),
    0
  };

  pixelFormat = [[NSOpenGLPixelFormat alloc] initWithAttributes: attribs];
  return pixelFormat;
}

- (NSOpenGLContext *)openGLContext {
  if (!m_openGLContext) {
    m_openGLContext = [[NSOpenGLContext alloc] initWithFormat: m_pixelFormat
                                                 shareContext: nil];

    [self setOpenGLContext: m_openGLContext];
  }

  return m_openGLContext;
}

- (void)setOpenGLContext:(NSOpenGLContext *)context {
  if (context != m_openGLContext) {
    [self clearGLContext];
    m_openGLContext = context;
    [m_openGLContext setView: self];
  }
}

- (NSOpenGLPixelFormat *)pixelFormat {
  return m_pixelFormat;
}

- (void)setPixelFormat:(NSOpenGLPixelFormat *)pixelFormat {
  m_pixelFormat = pixelFormat;
}

- (void)clearGLContext {
  if (m_openGLContext) {
    [m_openGLContext clearDrawable];
  }
}

/* https://developer.apple.com/library/mac/qa/qa1385/_index.html */
- (void)syncWithCurrentDisplay {
  NSOpenGLContext  *openGLContext;
  CGLContextObj     cglContext;
  CGLPixelFormatObj cglPixelFormat;
  GLint             swapInt;

  openGLContext = [self openGLContext];

  /* Synchronize buffer swaps with vertical refresh rate */
  swapInt = 1;
  [openGLContext setValues: &swapInt forParameter: NSOpenGLCPSwapInterval];

  /* Create a display link capable of being used with all active displays */
  CVDisplayLinkCreateWithActiveCGDisplays(&m_displink);

  /* Set the renderer output callback function */
  CVDisplayLinkSetOutputCallback(m_displink, displink_refresh, self);

  /* Set the display link for the current renderer */
  cglContext     = [openGLContext CGLContextObj];
  cglPixelFormat = [[self pixelFormat] CGLPixelFormatObj];

  CVDisplayLinkSetCurrentCGDisplayFromOpenGLContext(m_displink,
                                                    cglContext,
                                                    cglPixelFormat);
}

- (void)update {
  NSOpenGLContext *context;
  context = [self openGLContext];

  [context makeCurrentContext];

  /* because display link is threaded */
  CGLLockContext([context CGLContextObj]);
  [context update];
  CGLUnlockContext([context CGLContextObj]);
}

- (void) renderOnce {
  NSOpenGLContext *context;
  context = [self openGLContext];

  [context makeCurrentContext];

  /* because display link is threaded */
  CGLLockContext([context CGLContextObj]);
  [[self delegate] render];
  [context flushBuffer];
  CGLUnlockContext([context CGLContextObj]);
}

- (void) reshape {
  [self update];
  [self.delegate reshape];

  if (self.started)
    [self renderOnce];
}

#pragma mark -

- (void)drawRect:(NSRect)dirtyRect {
  [super drawRect: dirtyRect]; /* TODO: */

  if (self.started)
    [self renderOnce];
}

- (void) start {
  if (!self.started) {
    CVDisplayLinkStart(m_displink);
    self.started = YES;
  }
}

- (void) stop {
  CVDisplayLinkStop(m_displink);
  self.started = NO;
}

- (void)dealloc {
  [super dealloc];

  [[NSNotificationCenter defaultCenter] removeObserver: self];
  [NSOpenGLContext clearCurrentContext];
  [self clearGLContext];

  CVDisplayLinkStop(m_displink);
  CVDisplayLinkRelease(m_displink);

  m_openGLContext = nil;
  m_pixelFormat   = nil;
}

@end

static
CVReturn
displink_refresh(CVDisplayLinkRef    CV_NONNULL  displayLink,
                 const CVTimeStamp * CV_NONNULL  inNow,
                 const CVTimeStamp * CV_NONNULL  inOutputTime,
                 CVOptionFlags                   flagsIn,
                 CVOptionFlags     * CV_NONNULL  flagsOut,
                 void              * CV_NULLABLE displayLinkContext) {
  /* TODO: get rid of this, sync threads... */
  dispatch_sync(dispatch_get_main_queue(), ^{
    [(GLView *)displayLinkContext renderOnce];
  });

  return kCVReturnSuccess;
}
