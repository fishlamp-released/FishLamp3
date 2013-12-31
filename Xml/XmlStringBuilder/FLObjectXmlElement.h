//
//  FLObjectXmlElement.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 12/29/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLXmlElement.h"
#import "FLPropertyDescriber.h"

@interface FLObjectXmlElement : FLXmlElement {
@private
    id _object;
    FLPropertyDescriber* _propertyDescriber;
}

- (id) initWithObject:(id) object 
        xmlElementTag:(NSString*) xmlElementTag;

+ (id) objectXmlElement:(id) object 
          xmlElementTag:(NSString*) xmlElementTag;

+ (id) objectXmlElement:(id) object 
          xmlElementTag:(NSString*) xmlElementTag
      propertyDescriber:(FLPropertyDescriber*) propertyDescriber;

@end

@protocol FLXMLSeriliazable <NSObject>
- (void) addToXmlElement:(FLXmlElement*) xmlElement
       propertyDescriber:(FLPropertyDescriber*) propertyDescriber;
@end

