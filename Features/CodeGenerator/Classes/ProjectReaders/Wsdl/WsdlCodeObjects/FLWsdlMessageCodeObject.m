//
//  FLWsdlMessageCodeObject.m
//  CodeGenerator
//
//  Created by Mike Fullerton on 5/29/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLWsdlMessageCodeObject.h"
#import "FLWsdlMessage.h"
#import "FLWsdlPart.h"

@implementation FLWsdlMessageCodeObject

+ (id) wsdlMessageCodeObject:(FLWsdlMessage*) message {

    FLWsdlCodeObject* object = [FLWsdlMessageCodeObject wsdlCodeObject:message.name superclassName:nil];
	
	for(FLWsdlPart* part in message.parts) {

        NSString* typeName = nil;
		if(FLStringIsNotEmpty(part.type)) {
			typeName = part.type;
		}
		else if(FLStringIsNotEmpty(part.element)) {
			typeName = part.element;
		}
        
        [object addProperty:part.name propertyType:typeName];
	}

    return object;
}



@end
