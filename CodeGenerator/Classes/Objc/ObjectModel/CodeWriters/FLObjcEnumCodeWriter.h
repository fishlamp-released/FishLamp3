//
//  FLObjcEnumCodeWriter.h
//  CodeGenerator
//
//  Created by Mike Fullerton on 5/13/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLObjcCodeWriter.h"
#import "FLObjcType.h"
#import "FLObjcObjectBuilder.h"

@class FLObjcProject;
@class FLCodeEnumType;
@class FLObjcEnumValueType;
@class FLObjcEnumType;

@interface FLObjcEnumCodeWriter : FLObjcCodeWriter {
@private
    NSMutableArray* _enumValues;
    FLObjcEnumType* _enumType;
    FLObjcName* _enumName;
    
    NSMutableDictionary* _defines;
}

+ (id) objcEnum:(FLObjcProject*) project;

@property (readonly, strong, nonatomic) NSArray* enumValues;
@property (readwrite, strong, nonatomic) FLObjcEnumType* enumType;
@property (readwrite, strong, nonatomic) FLObjcName* enumName;

- (void) addValue:(FLObjcEnumValueType*) enumValueType;
- (void) configureWithCodeEnumType:(FLCodeEnumType*) codeEnumType;

@end

