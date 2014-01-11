//
//  FLWsdlCodeArray.h
//  CodeGenerator
//
//  Created by Mike Fullerton on 5/29/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLCodeArray.h"

@class FLWsdlCodeArrayContainedType;

@interface FLWsdlCodeArray : FLCodeArray

+ (id) wsdlCodeArray:(NSString*) arrayName;

- (void) addContainedType:(FLWsdlCodeArrayContainedType*) type;
- (void) addContainedType:(NSString*) typeName identifier:(NSString*) identifier;

@end


