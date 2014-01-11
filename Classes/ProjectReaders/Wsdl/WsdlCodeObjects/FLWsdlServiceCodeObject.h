//
//  FLWsdlServiceCodeObject.h
//  CodeGenerator
//
//  Created by Mike Fullerton on 5/29/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLWsdlCodeObject.h"
@class FLWsdlCodeProjectReader;
@class FLWsdlService;

@interface FLWsdlServiceCodeObject : FLWsdlCodeObject

+ (id) wsdlServiceCodeObject:(FLWsdlService*) service codeReader:(FLWsdlCodeProjectReader*) reader;

@end
