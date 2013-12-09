//
//	FLXmlObjectBuilder.h
//	FishLamp
//
//	Created by Mike Fullerton on 5/8/09.
//	Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampMinimum.h"
//#import "FLParsedXmlElement.h"
//#import "FLObjectDescriber.h"
//#import "FLModelObject.h"
//#import "NSObject+FLXmlObjectBuilder.h"

@class FLStringToObjectConversionManager;
@class FLParsedXmlElement;

@interface FLXmlObjectBuilder : NSObject {
@private
    FLStringToObjectConversionManager* _decoder;

    BOOL _strict;
}
@property (readwrite, assign, nonatomic) BOOL strict;
@property (readonly, strong,nonatomic) FLStringToObjectConversionManager* decoder;

- (id) initWithDataDecoder:(FLStringToObjectConversionManager*) decoder;
+ (id) xmlObjectBuilder:(FLStringToObjectConversionManager*) decoder;
+ (id) xmlObjectBuilder;

- (id) buildObjectOfClass:(Class) aClass withXML:(FLParsedXmlElement*) element;
- (id) buildObjectOfType:(NSString*) type withXML:(FLParsedXmlElement*) element;

@end

#define FLXmlObjectBuilderErrorDomain @"FLXmlObjectBuilderErrorDomain"

typedef NS_ENUM(NSInteger, FLXmlObjectBuilderError) {
    FLXmlObjectBuilderErrorUnknownProperty = 1,
    FLXmlObjectBuilderErrorObjectNotInflated

};
