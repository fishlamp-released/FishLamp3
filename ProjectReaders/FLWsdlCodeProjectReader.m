//
//	FLWsdlCodeGenerator.m
//	PackMule
//
//	Created by Mike Fullerton on 8/9/09.
//	Copyright 2009 Greentongue Software. All rights reserved.
//

//#import "FLCodeGenerator.h"

#import "FLWsdlCodeProjectReader.h"
#import "FLCodeProjectLocation.h"
#import "FLWsdlObjects.h"
#import "FLCodeProject.h"
#import "FLSoapParser.h"
#import "FLXmlObjectBuilder.h"
#import "FLCodeTypeDefinition.h"
#import "FLCodeBuilder.h"
#import "FLCodeGeneratorErrors.h"
#import "FLWsdlCodeProjectReader.h"
#import "FLSoapParser.h"
#import "NSString+FishLamp.h"
#import "FLXmlStringBuilder.h"
#import "NSString+FishLamp.h"
#import "FLCodeProperty.h"

#import "FLWsdlCodeObject.h"
#import "FLWsdlCodeProperty.h"
#import "FLWsdlCodeArray.h"
#import "FLWsdlCodeMethod.h"
#import "FLWsdlCodeEnumType.h"
#import "FLWsdlSimpleTypeEnumCodeType.h"
#import "FLWsdlComplexTypeCodeObject.h"
#import "FLWsdlMessageCodeObject.h"
#import "FLWsdlBindingCodeObject.h"
#import "FLWsdlPortTypeCodeObject.h"
#import "FLWsdlOperationCodeObject.h"
#import "FLWsdlServiceCodeObject.h"

@interface FLWsdlCodeProjectReader ()
//@property (readwrite, assign, nonatomic) FLCodeProject* project;
@property (readwrite, strong, nonatomic) FLWsdlDefinitions* wsdlDefinitions;
//@property (readwrite, strong, nonatomic) FLCodeBuilder* output;
@end

@implementation FLWsdlCodeProjectReader
@synthesize wsdlDefinitions = _wsdlDefinitions;

- (id) init {
	if((self = [super init])) {
        _objects = [[NSMutableDictionary alloc] init];
        _enums = [[NSMutableDictionary alloc] init];
        _arrays = [[NSMutableDictionary alloc] init];
        _declaredTypes = [[NSMutableDictionary alloc] init];
        _ignoredMessages = [[NSMutableDictionary alloc] init];

        _messageObjects = [[NSMutableDictionary alloc] init];
	}
	return self;
}

#if FL_MRC
- (void) dealloc {
    [_ignoredMessages release];
    [_messageObjects release];
    [_declaredTypes release];
	[_arrays release];
    [_enums release];
    [_objects release];
	[_wsdlDefinitions release];
	[super dealloc];
}
#endif


- (id) codeObjectForClassName:(NSString*) key {
    FLAssertNotNil(key);

    return [_objects objectForKey:FLStringToKey(key)];
}

- (void) setCodeObject:(FLWsdlCodeObject*) object forKey:(NSString*) key {
    [_objects setObject:object forKey:FLStringToKey(key)];
}

- (void) addCodeObject:(FLWsdlCodeObject*) object {
    FLConfirmStringIsNotEmptyWithComment(object.name, @"object has no className");

    [self setCodeObject:object forKey:FLStringToKey(object.name)];
}

- (FLCodeEnumType*) enumForKey:(NSString*) key {
    return [_enums objectForKey:FLStringToKey(key)];
}

- (void) setEnum:(FLCodeEnumType*) theEnum forKey:(NSString*) key {
    FLAssert(theEnum.enums.count > 0);
    [_enums setObject:theEnum forKey:FLStringToKey(key)];
}


- (void) addCodeEnum:(FLWsdlCodeEnumType*) enumType {
    [self setEnum:enumType forKey:enumType.name];
}

- (void) addArray:(FLWsdlCodeArray*) array {
    FLConfirm(array.types.count > 0);

    [_arrays setObject:array forKey:FLStringToKey(array.name)];
}

- (FLWsdlCodeArray*) arrayForName:(NSString*) name {
    return [_arrays objectForKey:FLStringToKey(name)];
}


- (BOOL) isEnum:(FLWsdlElement*) element {
	FLConfirmNotNil(element);
    
    return [self enumForKey:FLStringToKey(element.type)];
    

//
//	for(FLCodeEnumType* anEnum in self.project.enumTypes) {
//		if([anEnum.typeName isEqualToString:element.type]) {
//			return YES;
//		}
//	}
//	
//	return NO;
}

- (void) createObjectFromComplexType:(FLWsdlComplexType*) complexType 
                                type:(NSString*) type {
	if(!type) {
		type = complexType.name;
	}
	
	FLConfirmStringIsNotEmpty(type);

	if([complexType complexContent]) {
		if([complexType.complexContent extension]) {
			FLConfirmStringIsNotEmpty(complexType.complexContent.extension.base);

			FLWsdlCodeObject* object = [FLWsdlComplexTypeCodeObject wsdlCodeObject:type 
                                                         superclassName:complexType.complexContent.extension.base];
                                                         
            [object appendElementArrayAsProperties:complexType.complexContent.extension.sequence.elements codeReader:self];
            [self addCodeObject:object];
		}
		else if([complexType.complexContent restriction]) {
			BOOL isArray = complexType.complexContent.restriction.sequence.elements &&
						[[[complexType.complexContent.restriction.sequence.elements objectAtIndex:0] maxOccurs] isEqualToString:@"unbounded"];
		
			if(isArray) {
				FLWsdlCodeArray* array = [FLWsdlCodeArray wsdlCodeArray:type];
				   
				for(FLWsdlElement* obj in complexType.complexContent.restriction.sequence.elements) {	  
                    [array addContainedType:obj.type identifier:obj.name];
				}
                
                [self addArray:array];
			}
		}
	}
	else if(complexType.sequence.elements) {
		
        BOOL isArray = complexType.sequence.elements.count == 1 && 
			[[[complexType.sequence.elements objectAtIndex:0] maxOccurs] isEqualToString:@"unbounded"];
				
		if(isArray) {
            FLWsdlCodeArray* array = [FLWsdlCodeArray wsdlCodeArray:type];
							   
			for(FLWsdlElement* obj in complexType.sequence.elements) {	  
                [array addContainedType:obj.type identifier:obj.name];
			}
		
			[self addArray:array];
		}
		else {
			FLWsdlCodeObject* object = [FLWsdlComplexTypeCodeObject wsdlCodeObject:type superclassName:nil];
            
            [object appendElementArrayAsProperties:complexType.sequence.elements codeReader:self];
            
            [self addCodeObject:object];
		}
	}
	else if([complexType choice]) {
        FLWsdlCodeArray* array = [FLWsdlCodeArray wsdlCodeArray:type];
					   
		for(FLWsdlElement* obj in complexType.choice.elements) {	  
			[array addContainedType:obj.type identifier:obj.name];
		}
	
		[self addArray:array];
	}
	else {
// create empty object? 
		FLWsdlCodeObject* object = [FLWsdlComplexTypeCodeObject wsdlCodeObject:type superclassName:nil];
		[self addCodeObject:object];
	}
}

- (BOOL) partTypeIsObject:(FLWsdlPart*) part
{
	NSString* partType = nil;
	if(FLStringIsNotEmpty(part.type)) {
		partType = part.type;
	}
	else if(FLStringIsNotEmpty(part.element)) {
		partType = part.element;
	}
	
	FLConfirmNotNil(partType);

	return [self codeObjectForClassName:partType] != nil;
}

//- (FLWsdlMessage*) wsdlMessageForName:(NSString*) name  {
//	name = FLStringToKey(name);
//
//	for(FLWsdlMessage* msg in self.wsdlDefinitions.messages) {
//		if([FLStringToKey(msg.name) isEqualToString:name]) {
//			return msg;
//		}
//	}
//	
//	FLConfirmationFailureWithComment(@"Didn't find expected message object %@ (object referenced but not defined)", name);
//	
//	return nil;
//}  

- (NSString*) servicePortLocationFromBinding:(FLWsdlBinding*) binding {
	FLConfirmStringIsNotEmpty(binding.name);
	
	// this is attempting to get the binding attribute from the port element
	// in the superclass service element, using the name of the bindings array
	// e.g. the point it to get the location url from the address element
	// and return it
	
/*
	<wsdl:service name="AmazonSimpleDB">
		<wsdl:documentation>
			Amazon SimpleDB is a web service for running queries on structured
			data in real time. This service works in close conjunction with Amazon 
			Simple Storage Service (Amazon S3) and Amazon Elastic Compute Cloud 
			(Amazon EC2), collectively providing the ability to store, process 
			and query data sets in the cloud. These services are designed to make 
			web-scale computing easier and more cost-effective for developers.

			Traditionally, this type of functionality has been accomplished with 
			a clustered relational database that requires a sizable upfront 
			investment, brings more complexity than is typically needed, and often 
			requires a DBA to maintain and administer. In contrast, Amazon SimpleDB 
			is easy to use and provides the core functionality of a database - 
			real-time lookup and simple querying of structured data without the 
			operational complexity.	 Amazon SimpleDB requires no schema, automatically 
			indexes your data and provides a simple API for storage and access.	 
			This eliminates the administrative burden of data modeling, index 
			maintenance, and performance tuning. Developers gain access to this 
			functionality within Amazon's proven computing environment, are able 
			to scale instantly, and pay only for what they use. 
		</wsdl:documentation>
		<wsdl:port name="AmazonSDBPortType" binding="tns:AmazonSDBBinding">
			<soap:address location="https://sdb.amazonaws.com"/>
		</wsdl:port>
	</wsdl:service>

*/				
	for(FLWsdlPortType* port in self.wsdlDefinitions.service.ports) {
		if([port.binding isEqualToString:binding.type]) {
			return port.address.location;
		}
	}
	
    FLThrowCodeGeneratorError(FLCodeGeneratorErrorCodeTranslatorFailed, @"Service location string not found in service %@", self.wsdlDefinitions.service.name);
	return nil;
}



+ (FLWsdlCodeProjectReader*) wsdlCodeReader {
    return FLAutorelease([[[self class] alloc] init]);
}

- (void) addEnumerationsInSimpleTypes:(NSArray*) simpleTypes {
    for(FLWsdlSimpleType* simpleType in simpleTypes) {
        [self addCodeEnum:[FLWsdlSimpleTypeEnumCodeType wsdlSimpleTypeEnumCodeType:simpleType]];
    }
    
}

- (void) addObjectsInComplexTypes:(NSArray*) complexTypes {
    for(FLWsdlComplexType* complexType in complexTypes) {
        [self createObjectFromComplexType:complexType type:nil];
    }
}

- (void) addObjectsFromElements:(NSArray*) elements {
    for(FLWsdlElement* element in elements) {
        if([element complexType]) {
            [self createObjectFromComplexType:element.complexType type:element.name];
        }
        else {
            [_declaredTypes setObject:[FLWsdlCodeObject wsdlCodeObject:element.name superclassName:element.type] forKey:FLStringToKey(element.type)];
        }
    }
}

- (void) addMessageObject:(FLWsdlMessageCodeObject*) object {
    [_objects setObject:object forKey:FLStringToKey(object.name)];
}

//- (void) addMessageObjects:(NSArray*) messages {
//
//    NSMutableArray* objectsToCreate = [NSMutableArray array];
//
//    for(FLWsdlMessage* message in messages) {
//        if(message.parts.count == 1) {	
//            FLWsdlPart* part = [message.parts objectAtIndex:0];
//            if(FLStringIsNotEmpty(part.element)) {
//
//            }
//        }
//
//    }
//
//    for(FLWsdlMessage* message in messages) {
////        if(message.parts.count == 1) {	
////            FLWsdlPart* part = [message.parts objectAtIndex:0];
////            
////            if(FLStringIsNotEmpty(part.element)) {
////                // this means we'll be using a different object here, and we don't need a message object.
////                // this is for an input/output object
////
////                // note that this if for wsdl:part that has elements, not type.
////                
////    //			  <wsdl:message name="GetChallengeSoapIn">
////    //			  <wsdl:part name="parameters" element="tns:GetChallenge"/>
////    //			  </wsdl:message>
////
////                FLTrace(@"skipping part - name:%@, element: %@", part.name, part.element);
////                
////                continue;
////            }
////        }
//
//        if([_ignoredMessages objectForKey:message.name] == 0) {
//            [self addMessageObject:[FLWsdlMessageCodeObject wsdlMessageCodeObject:message]];
//        }
//        else {
//            FLLog(@"ignored message %@", message.name);
//        }
//	}
//}

- (void) addBindingObject:(FLWsdlBindingCodeObject*) bindingObject {
    [_objects setObject:bindingObject forKey:FLStringToKey(bindingObject.name)];
}

- (void) addBindingObjects:(NSArray*) bindings {
	for(FLWsdlBinding* binding in bindings) {
        [self addBindingObject:[FLWsdlBindingCodeObject wsdlBindingCodeObjectWithBinding:binding codeReader:self]];
	}
}

- (void) addPortObjects:(NSArray*) portTypes {
    for(FLWsdlPortType* portType in portTypes) {
        FLWsdlBindingCodeObject* portObject = [FLWsdlBindingCodeObject wsdlBindingCodeObjectWithPortType:portType codeReader:self];

        [self addCodeObject:portObject];
	}
}

- (void) addServiceObject:(FLWsdlService*) service {
    [self addCodeObject:[FLWsdlServiceCodeObject wsdlServiceCodeObject:service codeReader:self]];
}

- (void) addIgnoredMessage:(FLWsdlMessage*) message {
    [_ignoredMessages setObject:message forKey:message.name];
}

- (void) prepareMessageObjects {
    for(FLWsdlMessage* message in self.wsdlDefinitions.messages) {
        NSString* name = [FLXmlParser removePrefix:message.name];

        if(message.parts.count == 1) {	
            FLWsdlPart* part = [message.parts objectAtIndex:0];
            if(FLStringIsNotEmpty(part.element)) {
                NSString* replacement = [FLXmlParser removePrefix:part.element];
                [_messageObjects setObject:replacement forKey:name];
                FLLog(@"replaced %@ with %@", name, replacement);
                continue;
            }
        }

        [_messageObjects setObject:name forKey:name];
        
        [self addMessageObject:[FLWsdlMessageCodeObject wsdlMessageCodeObject:message]];
    }
}

- (NSString*) typeNameForMessageName:(NSString*) messageName {

    messageName = [FLXmlParser removePrefix:messageName];

    NSString* mappedName = [_messageObjects objectForKey:messageName];
    FLConfirmStringIsNotEmptyWithComment(mappedName, @"message object for %@ not found", messageName);

    return mappedName;
}

- (FLCodeProject *) parseProjectFromData:(NSData*) data fromURL:(NSURL*) url {
        
    FLParsedXmlElement* parsedSoap = nil;
    @try {
        parsedSoap = [[FLSoapParser soapParser] parseData:data fileNameForErrors:url.absoluteString];
            
        if(!FLStringsAreEqual(@"definitions", parsedSoap.elementName)) {
            return nil;
        }    
    }
    @catch(NSException* ex) {
        return nil;
    }

    FLWsdlDefinitions* definitions = [[FLXmlObjectBuilder xmlObjectBuilder] buildObjectOfClass:[FLWsdlDefinitions class]
                                                                                       withXML:parsedSoap];

    FLAssertNotNil(definitions);

    self.wsdlDefinitions = definitions;

    [self prepareMessageObjects];

	for(FLWsdlSchema* schema in self.wsdlDefinitions.types) {
        [self addEnumerationsInSimpleTypes:schema.simpleTypes];
        [self addObjectsInComplexTypes:schema.complexTypes];
        [self addObjectsFromElements:schema.elements];
	}
    
    [self addBindingObjects:self.wsdlDefinitions.bindings];
    [self addPortObjects:self.wsdlDefinitions.portTypes];

    [self addServiceObject:self.wsdlDefinitions.service];

    
    for(FLWsdlCodeObject* object in [_objects objectEnumerator]) {
        [object replaceWsdlArrays:self];
    }

    FLCodeProject* project = [FLCodeProject codeProject];
	if(FLStringIsNotEmpty(self.wsdlDefinitions.documentation)) {
		project.comment = self.wsdlDefinitions.documentation;
	}
    [project.classes addObjectsFromArray:[_objects allValues]];
    [project.arrays addObjectsFromArray:[_arrays allValues]];
    [project.enumTypes addObjectsFromArray:[_enums allValues]];

    return project;

}




@end

