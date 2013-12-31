//
//  NSArray+FLXmlObjectBuilder.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 5/7/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "NSArray+FLXmlObjectBuilder.h"
#import "FLXmlObjectBuilder.h"
#import "FLParsedXmlElement.h"
#import "FLModelObject.h"
#import "FLPropertyDescriber+XmlObjectBuilder.h"

@implementation NSArray (FLXmlObjectBuilder) 

//- (void) inflateElement:(FLParsedXmlElement*) element 
//              intoArray:(NSMutableArray*) newArray
//           propertyDescriber:(FLPropertyDescriber*) propertyDescriber {
//
//    FLAssertNotNil(newArray);
//    FLAssertNotNil(propertyDescriber);
//  //  FLConfirmNotNilWithComment(propertyDescriber.subtypes, @"expecting an array propertyDescriber");
//
//    for(id elementName in element.elements) {
//        id elementOrArray = [element.elements objectForKey:elementName];
//
//        FLPropertyDescriber* arrayType = [propertyDescriber containedTypeForName:elementName];
//        
//        FLConfirmNotNilWithComment(arrayType, @"arrayType for element \"%@\" not found", elementName);
//        
//        if([elementOrArray isArray]) {
//            for(FLParsedXmlElement* child in elementOrArray) {			
//                [newArray addObject:[self inflatePropertyObject:arrayType withElement:child]];
//            }
//        }
//        else {
//            FLAssert([elementOrArray isKindOfClass:[FLParsedXmlElement class]]);
//            id value = [self inflatePropertyObject:arrayType withElement:elementOrArray];
//            if(value) {
//                [newArray addObject:value];
//            }
//            else {
//                FLLog(@"Unable to inflate xml element %@:%@", elementName, [elementOrArray description]);
//            }
//        }
//    }
//}

- (id) xmlObjectBuilder:(FLXmlObjectBuilder*) builder 
arrayWithElementContents:(FLPropertyDescriber*) propertyDescriber {

    NSMutableArray* newArray = [NSMutableArray arrayWithCapacity:self.count];

    // we're building array from array of xmlElements
    
    for(FLParsedXmlElement* element in self) {
        FLPropertyDescriber* elementDescriber = [propertyDescriber containedTypeForName:element.elementName];
        FLConfirmNotNilWithComment(elementDescriber, @"arrayType for element \"%@\" not found", element.elementName);
        
        id object = [elementDescriber xmlObjectBuilder:builder inflateObjectWithElement:element];
        FLAssertNotNil(object);
        
        [newArray addObject:object];                    
    }
    
    return newArray;
}

@end



@implementation FLParsedXmlElement (FLXmlObjectBuilder)


- (id) objectForArray:(FLParsedXmlElement*) element 
    propertyDescriber:(FLPropertyDescriber*) propertyDescriber 
    objectBuilder:(FLXmlObjectBuilder*) builder {
  
    FLPropertyDescriber* arrayType = [propertyDescriber containedTypeForName:element.elementName];
    id object = [arrayType xmlObjectBuilder:builder inflateElementContents:element];
    
    return object;
 
    
//[propertyDescriber xmlObjectBuilder:builder  
//                                 inflateElementContents:childElement];
                  
}    

- (id) xmlObjectBuilder:(FLXmlObjectBuilder*) builder 
arrayWithElementContents:(FLPropertyDescriber*) propertyDescriber {

    NSMutableArray* newArray = [NSMutableArray arrayWithCapacity:self.childElements.count];
    
    for(FLParsedXmlElement* element in [self.childElements objectEnumerator]) {
        
        if(element.siblingElement != nil) {
            FLParsedXmlElement* walker = element;
            while(walker != nil) {
                id object = [self objectForArray:walker propertyDescriber:propertyDescriber objectBuilder:builder];
                if(object) {
                    [newArray addObject:object];
                }
                else {
#if DEBUG
                    if(FLStringIsNotEmpty(walker.elementValue)) {
                        FLLog(@"Unable to inflate xml element %@:%@", walker.elementName, [walker description]);
                    }
#endif                    
                }
                
                walker = walker.siblingElement;
            }
        }
        else {
//            FLPropertyDescriber* arrayType = [propertyDescriber containedTypeForName:[element elementName]];
//                
//            id object = [arrayType xmlObjectBuilder:builder inflateElementContents:element];
            
            id object = [self objectForArray:element propertyDescriber:propertyDescriber objectBuilder:builder];
            if(object) {
                [newArray addObject:object];
            }
            else {
                FLLog(@"Unable to inflate xml element %@:%@", [element elementName], [element description]);
            }
        }
    }
        
    return newArray;
}

@end


