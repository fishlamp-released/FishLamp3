//
//  FLWsdlSimpleTypeEnumCodeType.m
//  CodeGenerator
//
//  Created by Mike Fullerton on 5/29/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLWsdlSimpleTypeEnumCodeType.h"
#import "FLWsdlCodeProjectReader.h"
#import "FLWsdlSimpleType.h"
#import "FLWsdlEnumeration.h"
#import "FLWsdlRestrictionArray.h"
#import "FLWsdlList.h"
#import "FLWsdlCodeEnum.h"
#import "FLWsdlSequenceArray.h"

@implementation FLWsdlSimpleTypeEnumCodeType

- (void) addEnumTypesFromList:(FLWsdlRestrictionArray*) list {
    for(FLWsdlEnumeration* wsdlEnum in list.enumerations) {
        [self addEnum:wsdlEnum.value enumValue:nil];
    }
    
    FLAssert(list.sequence.elements.count == 0);
    
}

- (void) addEnumerationsFromSimpleType:(FLWsdlSimpleType*) simpleType {
    if(simpleType.restriction) {
        [self addEnumTypesFromList:simpleType.restriction];
        FLAssert(self.enums.count > 0);
        FLAssert(self.enums.count == simpleType.restriction.enumerations.count);
    
    }
    
    if(simpleType.list) {
        [self addEnumerationsFromSimpleType:simpleType.list.simpleType];
    }
}

+ (id) wsdlSimpleTypeEnumCodeType:(FLWsdlSimpleType*) simpleType {
	
    FLWsdlSimpleTypeEnumCodeType* enumType = FLAutorelease([[[self class] alloc] init]);
    enumType.name = simpleType.name;
    FLConfirmStringIsNotEmptyWithComment(enumType.name, @"expecting a name for the simple type here");
    
    [enumType addEnumerationsFromSimpleType:simpleType];
	return enumType;
}



@end
