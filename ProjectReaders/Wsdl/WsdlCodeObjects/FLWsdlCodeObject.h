//
//  FLWsdlCodeObject.h
//  CodeGenerator
//
//  Created by Mike Fullerton on 5/29/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLCodeObject.h"
@class FLWsdlCodeProjectReader;
@class FLWsdlCodeProperty;
@class FLWsdlCodeMethod;

@interface FLWsdlCodeObject : FLCodeObject

+ (id) wsdlCodeObject:(NSString*) className superclassName:(NSString*) superclassName;

- (void) appendElementArrayAsProperties:(NSArray*) elementArray 
                             codeReader:(FLWsdlCodeProjectReader*) codeReader;


- (FLWsdlCodeProperty*) addProperty:(NSString*) propertyName 
                       propertyType:(NSString*) propertyType;

- (FLWsdlCodeMethod*) addMethod:(NSString*) methodName 
               methodReturnType:(NSString*) methodReturnType;

- (FLCodeProperty*) propertyForName:(NSString*) name;
- (FLCodeMethod*) methodForName:(NSString*) name;

- (void) replaceWsdlArrays:(FLWsdlCodeProjectReader*) codeReader;
- (void) removeUnwantedObjects:(FLWsdlCodeProjectReader*) reader;

@end



