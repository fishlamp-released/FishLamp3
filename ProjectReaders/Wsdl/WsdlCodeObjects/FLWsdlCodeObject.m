//
//  FLWsdlCodeObject.m
//  CodeGenerator
//
//  Created by Mike Fullerton on 5/29/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLWsdlCodeObject.h"
#import "FLWsdlCodeProperty.h"
#import "FLWsdlCodeProjectReader.h"
#import "FLWsdlElement.h"
#import "FLWsdlCodeMethod.h"
#import "FLWsdlCodeArray.h"
#import "FLCodeArrayType.h"

@implementation FLWsdlCodeObject

- (id) initWithClassName:(NSString*) name superclassName:(NSString*) superclassName {
	self = [self init];
	if(self) {
//		self.protocols = @"NSCoding, NSCopying";
        self.name = name;
		self.superclass = superclassName;
    }
	return self;
}

+ (id) wsdlCodeObject:(NSString*) className superclassName:(NSString*) superclassName {
    return FLAutorelease([[[self class] alloc] initWithClassName:className superclassName:superclassName]);
}

- (void) setName:(NSString*) className {
    [super setName:FLDeleteNamespacePrefix(className)];
    FLConfirmStringIsNotEmptyWithComment(self.name, @"object needs a className");
}

- (void) setSuperclass:(NSString*) className {
    [super setSuperclass:FLDeleteNamespacePrefix(className)];
}

- (void) appendElementArrayAsProperties:(NSArray*) elementArray codeReader:(FLWsdlCodeProjectReader*) codeReader {
	
    for(FLWsdlElement* obj in elementArray) {

		if([obj.maxOccurs isEqualToString:@"unbounded"]) {
            FLWsdlCodeProperty* prop = [self addProperty:obj.name propertyType:@"array"];
            [prop addContainedType:obj.type identifier:obj.name];
            
            
//			FLCodeArrayType* type = [FLCodeArrayType arrayType];
//			type.name = obj.name; //obj.name;
//			type.typeName = FLDeleteNamespacePrefix(obj.type);
//			[prop.arrayTypes addObject:type];
		}
		else if([codeReader isEnum:obj]) {
        
// TODO: ENUM PROPERTY        
//            [self addProperty:obj.name propertyType:@"enum"];
            [self addProperty:obj.name propertyType:obj.type];
		}
		else if(FLStringIsNotEmpty(obj.ref)) {
            [self addProperty:obj.ref propertyType:obj.ref];
//			prop.name = obj.ref;
//			prop.type = FLDeleteNamespacePrefix(obj.ref);
		}
		else {
            [self addProperty:obj.name propertyType:obj.type];
//			prop.name = obj.name;
//			prop.type = FLDeleteNamespacePrefix(obj.type);
		}
	}
}


- (FLCodeMethod*) methodForName:(NSString*) name {
//	FLCodeProperty* input = 

    name = FLStringToKey(name);

	for(FLCodeMethod* method in self.methods) {
		if(FLStringsAreEqual(FLStringToKey(method.name), name)) {
			return method;
		}
	}

	return nil;
} 

- (FLCodeProperty*) propertyForName:(NSString*) name {
//	FLCodeProperty* input = 

    name = FLStringToKey(name);

	for(FLCodeProperty* prop in self.properties) {
		if(FLStringsAreEqual(FLStringToKey(prop.name), name)) {
			return prop;
		}
	}

	return nil;
} 

- (FLWsdlCodeProperty*) addProperty:(NSString*) propertyName 
                       propertyType:(NSString*) propertyType {
    
    FLWsdlCodeProperty* property = [FLWsdlCodeProperty wsdlCodeProperty:propertyName propertyType:propertyType];
    FLConfirmNilWithComment([self propertyForName:propertyName], @"property %@ already added", propertyName);

    [self.properties addObject:property];
    FLAssertStringIsNotEmpty(property.name);
    FLAssertStringIsNotEmpty(property.type);

    
    return property;
}                       

- (FLWsdlCodeMethod*) addMethod:(NSString*) methodName 
               methodReturnType:(NSString*) methodReturnType {


    FLWsdlCodeMethod* method = [FLWsdlCodeMethod wsdlCodeMethod:methodName methodReturnType:methodReturnType];
    FLConfirmNilWithComment([self methodForName:methodName], @"method %@ already added", methodName);

    [self.methods addObject:method];
    
    return method;
               
}

- (void) replaceWsdlArrays:(FLWsdlCodeProjectReader*) codeReader {

    // replace Arrays

    for(FLWsdlCodeProperty* property in self.properties) {
        FLWsdlCodeArray* array = [codeReader arrayForName:property.type];
        if(array) {
//            FLWsdlCodeObject* codeObject = [codeReader codeObjectForClassName:property.type];

            property.type = @"array";
            FLTrace(@"found array: %@", property.name);
            
            [property.arrayTypes removeAllObjects];
            for(FLCodeArrayType* subtype in array.types) {
                [property addContainedType:subtype.type  identifier:subtype.name];
            }
            
            FLConfirm(property.arrayTypes.count > 0);
            
        }
    }
    

}

- (void) removeUnwantedObjects:(FLWsdlCodeProjectReader*) reader {
}


@end

