//
//  FLCickableImageView.m
//  FishLampOSX
//
//  Created by Mike Fullerton on 3/11/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLCickableImageView.h"

@implementation FLCickableImageView

- (void)mouseUp:(NSEvent *) event {
 //   NSPoint location = [self convertPoint:[event locationInWindow] fromView:nil];
 //   BOOL mouseIn = CGRectContainsPoint(self.bounds, location);

//    if(mouseIn) {
//        [self.target performSelector:self.action withObject:self];
//    }
  
    [self resignFirstResponder];
        
//    [self.window makeFirstResponder:self.window]
}

//- (void)mouseEntered:(NSEvent *)event  {
//    [self mouseUpdate:event];
//}
//
//- (void) mouseDragged:(NSEvent *)event {
//    [self mouseUpdate:event];
//}
//
- (void)mouseDown:(NSEvent *)event {
//    [self mouseUpdate:event];
}
//
//- (void)mouseMoved:(NSEvent *)event {
//    [self mouseUpdate:event];
//}



@end
