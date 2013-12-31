//
//  FLObjcIvar.h
//  CodeGenerator
//
//  Created by Mike Fullerton on 5/31/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLObjcVariable.h"

@interface FLObjcIvar : FLObjcVariable 
+ (id) objcIvar:(FLObjcName*) variableName ivarType:(FLObjcType*) variableType;
@end