//
//  FLWsdlOperationCodeObject.h
//  CodeGenerator
//
//  Created by Mike Fullerton on 5/29/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLWsdlCodeObject.h"
@class FLWsdlOperation;
@class FLWsdlPortType;
@class FLWsdlCodeProjectReader;
@class FLWsdlBinding;
@class FLWsdlInputOutput;

@interface FLWsdlOperationCodeObject : FLWsdlCodeObject {
@private
    FLWsdlInputOutput* _wsdlOutput;
    FLWsdlInputOutput* _wsdlInput;
}

+ (id) wsdlOperationCodeObject:(NSString*) className;

- (void) addPropertiesWithOperation:(FLWsdlOperation*) operation codeReader:(FLWsdlCodeProjectReader*) reader ;

- (void) addPropertiesWithPortType:(FLWsdlPortType*) portType
                     wsdlOperation:(FLWsdlOperation*) operation
                        codeReader:(FLWsdlCodeProjectReader*) reader;

- (void) addPropertiesWithBinding:(FLWsdlBinding*) binding 
                    withOperation:(FLWsdlOperation*) operation 
                       codeReader:(FLWsdlCodeProjectReader*) reader;



@end