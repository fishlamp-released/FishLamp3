//
//  FLWsdlMessageCodeObject.h
//  CodeGenerator
//
//  Created by Mike Fullerton on 5/29/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLWsdlCodeObject.h"
@class FLWsdlMessage;

@interface FLWsdlMessageCodeObject : FLWsdlCodeObject

+ (id) wsdlMessageCodeObject:(FLWsdlMessage*) message;

@end
