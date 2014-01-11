//
//  FLDrawingUtils.h
//  FishLamp-iOS
//
//  Created by Mike Fullerton on 5/14/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampCore.h"

extern void FLDrawLinearGradient(CGContextRef context, 
    CGRect rect, 
    CGColorRef startColor, 
    CGColorRef endColor);
   
typedef struct {
    CGPoint startPoint; 
    CGPoint endPoint; 
    CGFloat width;
    CGLineCap cap;
    CGColorRef color;
} FLLine_t;    
      
extern void FLDrawLine(CGContextRef context, FLLine_t line);    

//NS_INLINE
//CGContextRef FLPushContext() {
//	CGContextRef context = CGGetCurrentContext();
//	CGContextSaveGState(context);
//    return context;
//}
//
//NS_INLINE 
//void FLPopContext(CGContextRef context) {
//	CGContextRestoreGState(context);
//}
