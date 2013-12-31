//
//  FLWsdlProperty.m
//  CodeGenerator
//
//  Created by Mike Fullerton on 5/29/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLWsdlCodeProperty.h"
#import "FLWsdlCodeProjectReader.h"
#import "FLWsdlCodeArrayContainedType.h"

@implementation FLWsdlCodeProperty

+ (id) wsdlCodeProperty:(NSString*) propertyName propertyType:(NSString*) propertyType {
    FLWsdlCodeProperty* property = FLAutorelease([[[self class] alloc] init]);
    property.name = propertyName;
    property.type = propertyType;
    return property;
}

- (void) setName:(NSString*) name {
    [super setName:FLDeleteNamespacePrefix(name)];
    FLConfirmStringIsNotEmptyWithComment(self.name, @"property needs a name");
}

- (void) setType:(NSString*) typeName {
    [super setType:FLDeleteNamespacePrefix(typeName)];
    FLConfirmStringIsNotEmptyWithComment(self.type, @"property needs a propertyType");
}

- (void) addContainedType:(FLWsdlCodeArrayContainedType*) type {
    [self.arrayTypes addObject:type];
}

- (void) addContainedType:(NSString*) typeName identifier:(NSString*) identifier {
    [self addContainedType:[FLWsdlCodeArrayContainedType wsdlCodeArrayContainedType:typeName identifier:identifier]];
}


@end
