//
//  FLParsedXmlElement.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 3/13/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampMinimum.h"

#define FLParsedElementDefaultSearchDepth 0

@interface FLParsedXmlElement : NSObject {
@private
    NSDictionary* _attributes;
    NSString* _namespace;
    NSString* _elementName;
    NSString* _qualifiedName;
    NSMutableString* _elementValue;
    NSMutableDictionary* _childElements;
    FLParsedXmlElement* _siblingElement;
    NSString* _prefix;

    __unsafe_unretained FLParsedXmlElement* _parentElement;
}
- (id) initWithName:(NSString*) name elementValue:(NSString*) elementValue;

+ (id) parsedXmlElement;
+ (id) parsedXmlElement:(NSString*) name elementValue:(NSString*) elementValue;

@property (readwrite, strong, nonatomic) NSDictionary* attributes;
@property (readwrite, strong, nonatomic) NSString* namespaceURI;
@property (readwrite, strong, nonatomic) NSString* qualifiedName;
@property (readwrite, strong, nonatomic) NSString* elementName;
@property (readwrite, strong, nonatomic) NSString* elementValue;
@property (readonly, strong, nonatomic) NSString* prefix;
@property (readonly, assign, nonatomic) BOOL isQualified;
@property (readonly, strong, nonatomic) NSString* targetNamespace;
@property (readonly, strong, nonatomic) NSString* fullPath;

- (void) appendStringToValue:(NSString*) string;

// parentElement
@property (readonly, assign, nonatomic) FLParsedXmlElement* parentElement;

// siblings
@property (readwrite, strong, nonatomic) FLParsedXmlElement* siblingElement;
- (NSUInteger) countSiblingElements;

// childElements 
@property (readonly, strong, nonatomic) NSDictionary* childElements;
- (void) addChildElement:(FLParsedXmlElement*) childElement;

- (FLParsedXmlElement*) childElementWithPath:(NSString*) path;

- (FLParsedXmlElement*) childElementWithName:(NSString*) name;

- (FLParsedXmlElement*) childElementWithName:(NSString*) name
                              maxSearchDepth:(NSInteger) maxDepth;

@end

