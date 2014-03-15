//
//  FLObjcNumberValueType.m
//  CodeGenerator
//
//  Created by Mike Fullerton on 5/31/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLObjcNumberValueType.h"
#import "FishLampCodeGeneratorObjects.h"
#import "FLObjcCodeGeneratorHeaders.h"

@implementation FLObjcNumberValueType 

- (NSString*) generatedObjectClassName {
    return @"NSNumber";
}

- (FLCodeElement*) defaultValueForString:(NSString*) string {
    return [FLCodeStatement codeStatement:
                [FLCodeReturn codeReturn:string]];
}

- (void) addPropertiesToObjcObject:(FLObjcObject*) object
                withCodeProperty:(FLCodeProperty*) codeProperty {

    FLObjcProperty* property = [self addPropertyToObjcObject:object withCodeProperty:codeProperty];

    FLObjcCustomProperty* newProperty = [FLObjcCustomProperty objcCustomProperty:object.project];

    FLObjcName* name = [[property propertyName] copyWithNewName:[NSString stringWithFormat:@"%@AsObject", property.propertyName.generatedName]];
    newProperty.propertyName = FLAutorelease(name);
    newProperty.propertyType = [object.project.typeRegistry typeForKey:@"NSNumber"];
    

    FLObjcNumberValueType* numberType = [object.project.typeRegistry typeForKey:codeProperty.type];
    [newProperty.getter.code appendReturnValue:[NSString stringWithFormat:@"[NSNumber %@:self.%@]",
        numberType.numberWithString,
        property.propertyName.generatedName]];

    [newProperty.setter.code appendLineWithFormat:@"self.%@ = [value %@];",
        property.propertyName.generatedName,
        numberType.numberValueString];

    [object addProperty:newProperty];


}

- (NSString*) numberWithString {
    return nil;
}
- (NSString*) numberValueString {
    return nil;
}

@end

@implementation FLObjcCharType 
- (NSString*) numberWithString {
    return @"numberWithChar";
}
- (NSString*) numberValueString {
    return @"charValue";
}
@end

@implementation FLObjcUnsignedCharType 
- (NSString*) numberWithString {
    return @"numberWithUnsignedChar";
}
- (NSString*) numberValueString {
    return @"unsignedCharValue";
}
@end

@implementation FLObjcNSIntegerType 
- (NSString*) numberWithString {
    return @"numberWithInteger";
}
- (NSString*) numberValueString {
    return @"integerValue";
}
@end

@implementation FLObjcNSUIntegerType 
- (NSString*) numberWithString {
    return @"numberWithUnsignedInteger";
}
- (NSString*) numberValueString {
    return @"unsignedIntegerValue";
}
@end

@implementation FLObjcSInt32Type 
- (NSString*) numberWithString {
    return @"numberWithInt";
}
- (NSString*) numberValueString {
    return @"intValue";
}
@end

@implementation FLObjcUInt32Type 
- (NSString*) numberWithString {
    return @"numberWithUnsignedInt";
}
- (NSString*) numberValueString {
    return @"unsignedIntValue";
}
@end

@implementation FLObjcSInt64Type 
- (NSString*) numberWithString {
    return @"numberWithLongLong";
}
- (NSString*) numberValueString {
    return @"longLongValue";
}
@end

@implementation FLObjcUInt64Type 
- (NSString*) numberWithString {
    return @"numberWithUnsignedLongLong";
}
- (NSString*) numberValueString {
    return @"unsignedLongLongValue";
}
@end

@implementation FLObjcSInt16Type 
- (NSString*) numberWithString {
    return @"numberWithShort";
}
- (NSString*) numberValueString {
    return @"shortValue";
}
@end

@implementation FLObjcUInt16Type 
- (NSString*) numberWithString {
    return @"numberWithUnsignedShort";
}
- (NSString*) numberValueString {
    return @"unsignedShortValue";
}
@end

@implementation FLObjcFloatType 
- (NSString*) numberWithString {
    return @"numberWithFloat";
}
- (NSString*) numberValueString {
    return @"floatValue";
}
@end

@implementation FLObjcDoubleType 
- (NSString*) numberWithString {
    return @"numberWithDouble";
}
- (NSString*) numberValueString {
    return @"doubleValue";
}
@end
