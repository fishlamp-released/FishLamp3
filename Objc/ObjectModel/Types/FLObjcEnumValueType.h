//
//  FLObjcEnumValueType.h
//  CodeGenerator
//
//  Created by Mike Fullerton on 5/31/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLObjcValueType.h"

@interface FLObjcEnumValueType : FLObjcValueType {
@private
    NSUInteger _enumValue;
}
@property (readwrite, assign, nonatomic) NSUInteger enumValue;

+ (id) objcEnumValue:(FLObjcName*) name value:(NSUInteger) value;
@end
