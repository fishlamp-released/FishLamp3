//
//  FLObjcCodeBuilder+FLCodeElement.h
//  FishLampCodeGenerator
//
//  Created by Mike Fullerton on 6/19/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLObjcCodeBuilder.h"

@class FLCodeElement;
@class FLObjcProject;

@interface FLObjcCodeBuilder (FLCodeElement)
- (void) appendCodeElement:(FLCodeElement*) codeLine
               withProject:(FLObjcProject*) project;

@end

@interface NSObject (FLCodeElement)
- (NSString*) stringForObjcProject:(FLObjcProject*) project;
@end
