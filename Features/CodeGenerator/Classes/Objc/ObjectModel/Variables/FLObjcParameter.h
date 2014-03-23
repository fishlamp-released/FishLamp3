//
//  FLObjcParameter.h
//  CodeGenerator
//
//  Created by Mike Fullerton on 5/31/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLObjcVariable.h"
@class FLObjcName;

@interface FLObjcParameter : FLObjcVariable {
@private
    NSString* _key;
}
@property (readwrite, strong, nonatomic) NSString* key;

- (id) initWithParameterName:(FLObjcName*) variableName parameterType:(FLObjcType*) parameterType key:(NSString*) key;
+ (id) objcParameter:(FLObjcName*) variableName parameterType:(FLObjcType*) parameterType key:(NSString*) key;
@end
