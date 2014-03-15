//
//  FLWsdlCodeMethod.h
//  CodeGenerator
//
//  Created by Mike Fullerton on 5/29/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLCodeMethod.h"

@interface FLWsdlCodeMethod : FLCodeMethod

+ (id) wsdlCodeMethod:(NSString*) methodName methodReturnType:(NSString*) returnType;

@end
