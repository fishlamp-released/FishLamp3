//
//  FLPropertyDescriber+XmlObjectBuilder.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 5/7/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLPropertyDescriber+XmlObjectBuilder.h"
#import "FLXmlObjectBuilder.h"
#import "FLParsedXmlElement.h"
#import "FLModelObject.h"
#import "NSArray+FLXmlObjectBuilder.h"
#import "FLStringToObjectConversionManager.h"
#import "FLObjectDescriber+FLXmlObjectBuilder.h"

@implementation FLPropertyDescriber (XmlObjectBuilder)
- (id) xmlObjectBuilder:(FLXmlObjectBuilder*) builder 
inflateObjectWithElement:(FLParsedXmlElement*) element {
    
    if(FLStringIsNotEmpty([element elementValue])) {
    
        NSString* forTypeName = self.stringEncodingKeyForRepresentedData;
        FLAssertNotNilWithComment(forTypeName, @"no encoder found for property: %@", self.propertyName);

        if(forTypeName) {
            id object = [builder.decoder objectFromString:[element elementValue] forTypeName:forTypeName];
            
            FLAssertNotNilWithComment(object,
                    @"object not expanded for %@:%@", [element elementName], [element elementValue]);
            
            return object;
        }
    }
    return nil;
}
- (id) xmlObjectBuilder:(FLXmlObjectBuilder*) builder 
 inflateElementContents:(FLParsedXmlElement*) element {
    return [self xmlObjectBuilder:builder inflateObjectWithElement:element];
}

@end

//@implementation FLObjectPropertyDescriber (FLXmlObjectBuilder) 
//
//- (id) xmlObjectBuilder:(FLXmlObjectBuilder*) builder 
// inflateElementContents:(id) element {
//
//    FLAssert([element isKindOfClass:[FLParsedXmlElement class]]);
//
//    return [self xmlObjectBuilder:builder inflateObjectWithElement:element];
//}
//
//
//@end

@implementation FLModelObjectPropertyDescriber (FLXmlObjectBuilder)

- (id) xmlObjectBuilder:(FLXmlObjectBuilder*) builder 
inflateObjectWithElement:(FLParsedXmlElement*) xmlElement {

    return [builder buildObjectOfClass:self.representedObjectClass withXML:xmlElement];

}

@end

@implementation FLArrayPropertyDescriber (FLXmlObjectBuilder) 

- (id) xmlObjectBuilder:(FLXmlObjectBuilder*) builder 
 inflateElementContents:(FLParsedXmlElement*) contents {
    return [contents xmlObjectBuilder:builder arrayWithElementContents:self];
}

@end