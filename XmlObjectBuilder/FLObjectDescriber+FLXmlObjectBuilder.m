//
//  NSObject+FLXmlObjectBuilder.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 5/7/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLObjectDescriber+FLXmlObjectBuilder.h"
#import "FLXmlObjectBuilder.h"
#import "FLParsedXmlElement.h"
#import "FLModelObject.h"
#import "FLPropertyDescriber+XmlObjectBuilder.h"
#import "FLStringToObjectConversionManager.h"

@implementation FLObjectDescriber (FLXmlObjectBuilder)

- (id) buildObjectWithObjectBuilder:(FLXmlObjectBuilder*) builder
                            withXML:(FLParsedXmlElement*) element {

//    NSString* encodingKey = typeDesc.stringEncodingKeyForRepresentedData;
//    if(encodingKey) {
//        FLAssertNotNil(builder.decoder);
//        return [builder.decoder objectFromString:self forTypeName:forTypeName];

    NSString* forTypeName = [[self objectClass] typeNameForStringSerialization];
  
    id object = [builder.decoder objectFromString:[element elementValue] forTypeName:forTypeName];
    FLAssertNotNil(object);

    return object;
}
     
@end


@implementation NSObject (FLXmlObjectBuilder)

- (void) setPropertyWithXML:(FLParsedXmlElement*) element
          withObjectBuilder:(FLXmlObjectBuilder*) builder
    withPropertyDescriber:(FLPropertyDescriber*) propertyDescriber {

    NSString* propertyName = propertyDescriber.propertyName;

    id object = [propertyDescriber xmlObjectBuilder:builder
                             inflateElementContents:element];

    if(object) {
        if([self valueForKey:propertyName]) {
            FLTrace(@"replacing non-nil value for [%@ %@]", NSStringFromClass([object class]),  element.fullPath);
        } 
    
//                FLAssertNil([outObject valueForKey:element.elementName]);
    
        [self setValue:object forKey:propertyName];
    }
    else {

        if(FLStringIsNotEmpty(element.elementValue)) {

            FLTrace(@"object not inflated for %@.%@", NSStringFromClass([outObject class]), element.fullPath);

            if(builder.strict) {
                FLThrowErrorCodeWithComment(    FLXmlObjectBuilderErrorDomain,
                                                FLXmlObjectBuilderErrorObjectNotInflated,
                                                @"object not inflated for \"%@\" (%@)", element.fullPath, element.elementValue);

            }
        }
    }
}

- (void) setContainerPropertyWithXML:(FLParsedXmlElement*) element
          withObjectBuilder:(FLXmlObjectBuilder*) builder
    withPropertyDescriber:(FLPropertyDescriber*) propertyDescriber {

    if(propertyDescriber) {

    // TODO: (MWF) - support other types of containers!!

        NSString* propertyName = propertyDescriber.propertyName;
        NSMutableArray* array = [self valueForKey:propertyName];
        if(!array) {
            array = [NSMutableArray array];
            [self setValue:array forKey:propertyName];
        }
        
        FLParsedXmlElement* walker = element;
        while(walker){ 
            FLPropertyDescriber* containedType = [propertyDescriber containedTypeForName:walker.elementName];
            id objectForArray = [containedType xmlObjectBuilder:builder inflateElementContents:walker];
            
            if(objectForArray) {
                [array addObject:objectForArray];
            }
            else {
                FLTrace(@"array object not inflated for %@.%@",
                    NSStringFromClass([outObject class]),
                    walker.fullPath);

                if(builder.strict) {
                    FLThrowErrorCodeWithComment(    FLXmlObjectBuilderErrorDomain,
                                                    FLXmlObjectBuilderErrorObjectNotInflated,
                                                    @"Array object not inflated: %@:%@",
                                                     NSStringFromClass([self class]),
                                                     walker.fullPath);
                }

            }
            walker = walker.siblingElement;
        }
    }
    else {
        FLTrace(@"object builder skipped missing propertyDescriber named: %@:%@",
                NSStringFromClass(self.objectClass),
                element.fullPath);

        if(builder.strict) {
            FLThrowErrorCodeWithComment(    FLXmlObjectBuilderErrorDomain,
                                            FLXmlObjectBuilderErrorUnknownProperty,
                                            @"Unknown property: %@", element.fullPath);
        }

    }
}

- (id) initWithXMLElement:(FLParsedXmlElement*) xmlElement
        withObjectBuilder:(FLXmlObjectBuilder*) builder {

    self = [self init];
    if(self) {
        FLObjectDescriber* describer = [self objectDescriber];

        for(FLParsedXmlElement* element in [xmlElement.childElements objectEnumerator]) {
            
            FLPropertyDescriber* propertyDescriber = [describer propertyForName:element.elementName];

            if(propertyDescriber) {
                [self setPropertyWithXML:element
                       withObjectBuilder:builder
                   withPropertyDescriber:propertyDescriber];
            }
            else {
                [self setContainerPropertyWithXML:element
                                withObjectBuilder:builder
                            withPropertyDescriber:[describer propertyForContainerTypeByName:element.elementName]];

            }
            
        }
    }

    return self;
}

@end

@implementation FLModelObjectDescriber (FLXmlObjectBuilder)

- (id) buildObjectWithObjectBuilder:(FLXmlObjectBuilder*) builder
                            withXML:(FLParsedXmlElement*) parentElement {

    FLAssert([self.objectClass isModelObject]);
    id outObject = FLAutorelease([[self.objectClass alloc] initWithXMLElement:parentElement withObjectBuilder:builder]);
    FLAssertNotNil(outObject);
    return outObject;
}

@end


