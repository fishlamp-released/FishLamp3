//
//  FLWsdlSimpleTypeEnumCodeType.h
//  CodeGenerator
//
//  Created by Mike Fullerton on 5/29/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLWsdlCodeEnumType.h"

@class FLWsdlCodeProjectReader;
@class FLWsdlSimpleType;

@interface FLWsdlSimpleTypeEnumCodeType : FLWsdlCodeEnumType

+ (id) wsdlSimpleTypeEnumCodeType:(FLWsdlSimpleType*) simpleType;

@end
