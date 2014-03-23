//
//  FLObjcObjectBuilder.h
//  FishLampCodeGenerator
//
//  Created by Mike Fullerton on 8/17/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FLObjcObject;
@class FLCodeProperty;
@class FLObjcProject;

@class FLObjcProperty;

@interface FLObjcObjectBuilder : NSObject

- (void) addPropertiesToObjcObject:(FLObjcObject*) object
                withCodeProperty:(FLCodeProperty*) codeProperty;

- (FLObjcProperty*) addPropertyToObjcObject:(FLObjcObject*) object
                           withCodeProperty:(FLCodeProperty*) codeProperty;


@end
