//
//  FLWsdlComplexTypeCodeObject.m
//  CodeGenerator
//
//  Created by Mike Fullerton on 5/29/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLWsdlComplexTypeCodeObject.h"
#import "FLWsdlCodeProjectReader.h"
#import "FLWsdlComplexType.h"

@implementation FLWsdlComplexTypeCodeObject

//+ (id) wsdlComplexTypeCodeObject:(FLWsdlComplexType*) complexType 
//                                type:(NSString*) type 
//                                reader:(FLWsdlCodeProjectReader*) reader{
//	if(!type) {
//		type = complexType.name;
//	}
//	
//	FLConfirmStringIsNotEmpty(type);
//
//	if([complexType complexContent]) {
//		if([complexType.complexContent extension]) {
//			FLConfirmStringIsNotEmpty(complexType.complexContent.extension.base);
//
//			FLWsdlCodeObject* bizObj = [FLWsdlCodeObject wsdlCodeObject:type 
//                                                         superclassName:complexType.complexContent.extension.base];
//                                                         
//            [bizObject appendElementArrayAsProperties:complexType.complexContent.extension.sequences codeReader:self];
//            [self addCodeObject:bizObj];
//		}
//		else if([complexType.complexContent restriction]) {
//			BOOL isArray = complexType.complexContent.restriction.sequences &&
//						[[[complexType.complexContent.restriction.sequences objectAtIndex:0] maxOccurs] isEqualToString:@"unbounded"];
//		
//			if(isArray) {
//				FLWsdlCodeArray* array = [FLWsdlCodeArray wsdlCodeArray:type];
//				   
//				for(FLWsdlElement* obj in complexType.complexContent.restriction.sequences) {	  
//
//					[array addContainedType:obj.type identifier:obj.name];
//				}
//                
//                [self addArray:array];
//			}
//		}
//	}
//	else if([complexType sequences]) {
//		BOOL isArray = complexType.sequences.count == 1 && 
//			[[[complexType.sequences objectAtIndex:0] maxOccurs] isEqualToString:@"unbounded"];
//				
//		if(isArray) {
//            FLWsdlCodeArray* array = [FLWsdlCodeArray wsdlCodeArray:type];
//							   
//			for(FLWsdlElement* obj in complexType.sequences) {	  
//                [array addContainedType:obj.type identifier:obj.name];
//			}
//		
//			[self addArray:array];
//		}
//		else {
//			FLWsdlCodeObject* bizObj = [FLWsdlCodeObject wsdlCodeObject:type superclassName:nil];
//            
//            [bizObj appendElementArrayAsProperties:complexType.sequences codeReader:self];
//            
//            [self addCodeObject:bizObj];
//		}
//	}
//	else if([complexType choice]) {
//        FLWsdlCodeArray* array = [FLWsdlCodeArray wsdlCodeArray:type];
//					   
//		for(FLWsdlElement* obj in complexType.choice.elements) {	  
//			[array addContainedType:obj.type identifier:obj.name];
//		}
//	
//		[self addArray:array];
//	}
//	else {
//// create empty object? 
//		FLWsdlCodeObject* bizObj = [FLWsdlCodeObject wsdlCodeObject:type superclassName:nil];
//		[self addCodeObject:bizObj];
//	}
//}

@end
