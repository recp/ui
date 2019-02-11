//
//  display.h
//  ui
//
//  Created by Recep Aslantas on 2/11/19.
//  Copyright © 2019 Recep Aslantas. All rights reserved.
//

#ifndef display_h
#define display_h

UI_EXPORT
void
ui_display_setcb(UIDisplay * __restrict disp, void (*callback)(void));

UI_EXPORT
void
uiSetDisplayCallback(UIDisplay * __restrict disp, void (*callback)(void));

#endif /* display_h */
