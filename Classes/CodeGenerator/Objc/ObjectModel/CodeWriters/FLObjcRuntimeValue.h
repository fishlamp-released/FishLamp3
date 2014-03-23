//
//  FLObjcRuntimeValue.h
//  CodeGenerator
//
//  Created by Mike Fullerton on 5/12/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLObjcCodeWriter.h"

@class FLObjcType;
@protocol FLObjcType;

@interface FLObjcRuntimeValue : FLObjcCodeWriter {
@private
    NSString* _valueName;
    FLObjcType* _valueType;
}
@property (readwrite, strong, nonatomic) NSString* valueName;
@property (readwrite, strong, nonatomic) FLObjcType* valueType;

- (id) initWithValueName:(NSString*) name valueType:(FLObjcType*) type;

@end

@interface FLObjcRuntimeObject : FLObjcRuntimeValue
+ (id) objcRuntimeObject:(NSString*) name objectType:(FLObjcType*) type;
@end
