//
//  FLObjcConstructor.h
//  FishLampCodeGenerator
//
//  Created by Mike Fullerton on 6/8/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLObjcMethod.h"

@class FLCodeConstructor;
@class FLObjcProject;

@interface FLObjcConstructor : FLObjcMethod {

}

+ (id) objcConstructor:(FLObjcProject*) project;

- (void) configureWithInputConstructor:(FLCodeConstructor*) constructor 
                            withObject:(FLObjcObject*) object;

+ (FLObjcMethodName*) methodNameForConstructor:(FLCodeConstructor*) constructor;

@end

