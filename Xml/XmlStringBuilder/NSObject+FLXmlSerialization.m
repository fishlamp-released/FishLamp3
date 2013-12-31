//
//  NSObject+FLXmlSerialization.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 12/29/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "NSObject+FLXmlSerialization.h"
#import "FLObjectXmlElement.h"
#import "FLObjectDescriber.h"
#import "FLStringToObjectConversionManager.h"
#import "FLXmlElement.h"

@implementation NSObject (FLXmlSerialization)

- (void) addToXmlElement:(FLXmlElement*) xmlElement
       propertyDescriber:(FLPropertyDescriber*) propertyDescriber {

    FLAssertNotNil(propertyDescriber);
    FLAssertNotNil(xmlElement);

	if([[self class] isModelObject]) {

        BOOL foundIt = NO;

      	FLObjectDescriber* typeDesc = [[self class] objectDescriber];
        for(FLPropertyDescriber* property in [typeDesc.properties objectEnumerator]) {

            id object = [self valueForKey:property.propertyName];

            if(FLStringsAreEqual(@"photoSetId",property.propertyName)) {
                FLAssertNotNil(object);
                foundIt = YES;
            }

//            FLLog(@"%@.%@ = %@", NSStringFromClass([self class]), property.propertyName, [object description])

            if(object) {
                [xmlElement appendSection:[FLObjectXmlElement objectXmlElement:object
                                                              xmlElementTag:property.serializationKey 
                                                          propertyDescriber:property]];
            }
        }

        if(FLStringsAreEqual(@"ZFLoadPhotoSet", NSStringFromClass([self class]))) {
            FLAssert(foundIt);
        }

    }
    else {


        NSString* forTypeName = [propertyDescriber stringEncodingKeyForRepresentedData];
        if(forTypeName) {
            NSString* line = [xmlElement.dataEncoder stringFromObject:self forTypeName:forTypeName];
            FLAssertStringIsNotEmpty(line);

//            NSString* line = [objectEncoder encodeObjectToString:self withEncoder:xmlElement.dataEncoder];
            [xmlElement appendLine:line];
        }
        else {
            FLLog(@"No encoder for %@ found", NSStringFromClass([self class]));
        }
    }
}

@end


@implementation NSArray (FLXmlSerialization)

- (void) addToXmlElement:(FLXmlElement*) xmlElement
       propertyDescriber:(FLPropertyDescriber*) propertyDescriber {

    FLAssertNotNil(propertyDescriber);
    FLAssertNotNil(xmlElement);

	if(propertyDescriber && self.count) {

		if(propertyDescriber.containedTypes.count == 1) {
			FLPropertyDescriber* elementDesc = [propertyDescriber.containedTypes objectAtIndex:0];

			for(id obj in self){
                [xmlElement appendSection:[FLObjectXmlElement objectXmlElement:obj xmlElementTag:elementDesc.serializationKey propertyDescriber:elementDesc]];
			}
		}
		else {
        
            for(id obj in self) {
				// hmm. expensive. need to decide for each item.
                
                FLPropertyDescriber* containedType = [propertyDescriber containedTypeForClass:[obj class]];
                if(containedType) {
                    [xmlElement appendSection:[FLObjectXmlElement objectXmlElement:obj 
                                                                  xmlElementTag:containedType.serializationKey 
                                                              propertyDescriber:containedType]];
                }
                else {
                    FLLog(@"array property describer for %@ not found", NSStringFromClass([obj class]));
                }
                
//                BOOL found = NO;
//                for(FLPropertyDescriber* subType in propertyDescriber.containedTypes) {
//					if([obj isKindOfClass:[subType propertyClass]]) {
//                        [xmlElement appendSection:[FLObjectXmlElement objectXmlElement:obj xmlElementTag:subType.propertyName propertyDescriber:subType]];
//                        found = YES;
//						break;
//					}
//				}
//                if(!found) {
//                    FLLog(@"array property describer for %@ not found", NSStringFromClass([obj class]));
//                
//                }
			}		
		}
	}
#if DEBUG
	else if(!propertyDescriber) {
		FLLog(@"Warning not streaming object of type: %@", NSStringFromClass([self class]));
	}
#endif	
}
@end

