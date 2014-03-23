//
//  FLWsdlBindingCodeObject.h
//  CodeGenerator
//
//  Created by Mike Fullerton on 5/29/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLWsdlCodeObject.h"
@class FLWsdlBinding;
@class FLWsdlCodeProjectReader;
@class FLWsdlPortType;

@interface FLWsdlBindingCodeObject : FLWsdlCodeObject {
@private
    NSMutableArray* _operations;
}

+ (id) wsdlBindingCodeObject:(NSString*) name codeReader:(FLWsdlCodeProjectReader*) reader;

+ (id) wsdlBindingCodeObjectWithBinding:(FLWsdlBinding*) binding 
                  codeReader:(FLWsdlCodeProjectReader*) reader;

+ (id) wsdlBindingCodeObjectWithPortType:(FLWsdlPortType*) portType 
                              codeReader:(FLWsdlCodeProjectReader*) reader;

                         
@end
