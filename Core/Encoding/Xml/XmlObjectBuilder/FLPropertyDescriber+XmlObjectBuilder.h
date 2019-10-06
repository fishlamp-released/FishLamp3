//
//  FLPropertyDescriber+XmlObjectBuilder.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 5/7/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLPropertyDescriber.h"
@class FLXmlObjectBuilder;
@class FLParsedXmlElement;

@interface FLPropertyDescriber (XmlObjectBuilder)
- (id) xmlObjectBuilder:(FLXmlObjectBuilder*) builder 
inflateObjectWithElement:(FLParsedXmlElement*) element;

- (id) xmlObjectBuilder:(FLXmlObjectBuilder*) builder 
 inflateElementContents:(FLParsedXmlElement*) element;
@end
