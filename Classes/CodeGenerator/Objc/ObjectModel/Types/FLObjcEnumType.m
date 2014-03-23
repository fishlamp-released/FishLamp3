//
//  FLObjcEnumType.m
//  CodeGenerator
//
//  Created by Mike Fullerton on 5/31/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLObjcEnumType.h"
#import "FLObjcCodeGeneratorHeaders.h"

@implementation FLObjcEnumType

+ (id) objcEnumType:(FLObjcName*) typeName 
       importFileName:(NSString*) importFileName {
    return FLAutorelease([[[self class] alloc] initWithTypeName:typeName importFileName:importFileName]);
}

- (void) addEnumPropertyToObject:(FLObjcObject*) object withProperty:(FLObjcProperty*) property {
    FLObjcCustomProperty* newProperty = [FLObjcCustomProperty objcCustomProperty:object.project];
    NSString* newName = [NSString stringWithFormat:@"%@Enum", property.propertyName.generatedName];
    
    newProperty.propertyName = FLAutorelease([[property propertyName] copyWithNewName:newName]);
    
    newProperty.propertyType = [FLObjcValueType objcValueType:[FLObjcImportedName objcImportedName:self.generatedName] importFileName:nil];
    
    [object addProperty:newProperty];
    
    [newProperty.getter.code appendReturnValue:[NSString stringWithFormat:@"%@(self.%@)", 
        [self enumFromStringFunctionName], 
        property.propertyName.generatedName]];


    [newProperty.setter.code appendAssignment:[NSString stringWithFormat:@"%@(value)", self.stringFromEnumFunctionName]
        to:[NSString stringWithFormat:@"self.%@", property.propertyName.generatedName]]; 


}

- (void) addEnumSetPropertyToObject:(FLObjcObject*) object withProperty:(FLObjcProperty*) property {
    FLObjcCustomProperty* newProperty = [FLObjcCustomProperty objcCustomProperty:object.project];
    
    FLObjcName* name = [[property propertyName] copyWithNewName:[NSString stringWithFormat:@"%@EnumSet", property.propertyName.generatedName]];
    newProperty.propertyName = FLAutorelease(name);
    
    newProperty.propertyType = [FLObjcImmutableObjectType objcImmutableObjectType:[FLObjcImportedName objcImportedName:self.enumSetClassName] importFileName:nil];
    
    [object addProperty:newProperty];

    [newProperty.getter.code appendReturnValue:[NSString stringWithFormat:@"[%@ enumSet:self.%@];", 
        self.enumSetClassName, 
        property.propertyName.generatedName]];


    [newProperty.setter.code appendAssignment:@"value.concatenatedString"
        to:[NSString stringWithFormat:@"self.%@", property.propertyName.generatedName]]; 

}


- (void) addPropertiesToObjcObject:(FLObjcObject*) object
                withCodeProperty:(FLCodeProperty*) codeProperty {

    FLObjcProperty* property = [self addPropertyToObjcObject:object withCodeProperty:codeProperty];

    FLObjcEnumCodeWriter* theEnum = [object.project.generatedEnums objectForObjcName:property.propertyType.typeName];

    [self addEnumPropertyToObject:object withProperty:property];

    [self addEnumSetPropertyToObject:object withProperty:property];

}

- (NSString*) enumSetClassName {
    return  [NSString stringWithFormat:@"%@EnumSet", self.generatedName];
}

- (NSString*) stringFromEnumFunctionName {
    return [NSString stringWithFormat:@"%@StringFromEnum", self.generatedName];
}

- (NSString*) enumFromStringFunctionName {
    return [NSString stringWithFormat:@"%@EnumFromString", self.generatedName];
}

- (NSString*) stringFromEnumFunctionPrototype {
    return [NSString stringWithFormat:@"NSString* %@(%@ theEnum)", self.stringFromEnumFunctionName, self.generatedName];
}

- (NSString*) enumFromStringFunctionPrototype {
    return [NSString stringWithFormat:@"%@ %@(NSString* theString)", self.generatedName, self.enumFromStringFunctionName];
}


- (NSString*) generatedReference {
    return @"NSString*";
}

- (BOOL) canForwardReference {
    return NO;
}

@end
