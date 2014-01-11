//
//  FLObjcVariable.h
//  CodeGenerator
//
//  Created by Mike Fullerton on 2/10/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLObjcCodeWriter.h"

@class FLObjcType;
@class FLObjcName;
@class FLObjcRuntimeValue;
@protocol FLObjcType;

@interface FLObjcVariable : NSObject<FLObjcCodeWriter> {
    FLObjcName* _variableName;
    FLObjcType* _variableType;
    FLObjcRuntimeValue* _runtimeValue;
}
@property (readwrite, strong, nonatomic) FLObjcName* variableName;
@property (readwrite, strong, nonatomic) FLObjcType* variableType;
@property (readwrite, strong, nonatomic) FLObjcRuntimeValue* runtimeValue;

- (id) initWithVariableName:(FLObjcName*) variableName variableType:(FLObjcType*) variableType;
@end




