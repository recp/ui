# 📐 User Interface Library top of OpenGL/Metal/Vulkan

This proejct will allow to create user interfaces without any native dependencies and restrictions. This library will use graphics libraires e.g. OpenGL/Metal/Vulkan to render UI elements. 

Window itself will be native window. All other elements will be independent ot platform. 

**Initial Sample:**

```C
#include <ui/ui.h>

int
main(int argc, const char * argv[]) {
  UIApp          *app;
  UIWindow       *window;
  UIWindowOptions opt;

  opt.surface = kUIWindowSurfaceOpenGL;

  window = uiCreateWindow((UISize){800, 600}, &opt);
  app    = uiCreateApp(window);

  uiRunApp(app);

  return 0;
}

```
