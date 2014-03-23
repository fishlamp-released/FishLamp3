//
//  FLWsdlProperty.h
//  CodeGenerator
//
//  Created by Mike Fullerton on 5/29/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLCodeProperty.h"
@class FLWsdlCodeArrayContainedType;

@interface FLWsdlCodeProperty : FLCodeProperty

+ (id) wsdlCodeProperty:(NSString*) propertyName propertyType:(NSString*) propertyType;

- (void) addContainedType:(FLWsdlCodeArrayContainedType*) type;
- (void) addContainedType:(NSString*) typeName identifier:(NSString*) identifier;

@end
