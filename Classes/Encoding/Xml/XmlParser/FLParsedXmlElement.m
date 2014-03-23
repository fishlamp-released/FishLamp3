//
//  FLParsedXmlElement.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 3/13/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLParsedXmlElement.h"
#import "FLPrettyDescription.h"

@interface FLParsedXmlElement ()
@property (readwrite, assign, nonatomic) FLParsedXmlElement* parentElement;
@property (readwrite, strong, nonatomic) NSString* prefix;

@end

@implementation FLParsedXmlElement

@synthesize attributes = _attributes;
@synthesize namespaceURI = _namespace;
@synthesize elementName = _elementName;
@synthesize qualifiedName = _qualifiedName;
@synthesize elementValue = _elementValue;
@synthesize childElements = _childElements;
@synthesize parentElement = _parentElement;
@synthesize siblingElement = _siblingElement;
@synthesize prefix = _prefix;

- (id) initWithName:(NSString*) name elementValue:(NSString*) elementValue {	
	self = [super init];
	if(self) {
		self.elementName = name;
        _elementValue = [elementValue mutableCopy];
	}
	return self;
}

+ (id) parsedXmlElement {
    return FLAutorelease([[[self class] alloc] init]);
}

+ (id) parsedXmlElement:(NSString*) name elementValue:(NSString*) elementValue {
    return FLAutorelease([[[self class] alloc] initWithName:name elementValue:elementValue]);
}

#if FL_MRC
- (void) dealloc {
    [_prefix release];
    [_siblingElement release];
    [_attributes release];
    [_namespace release];
    [_elementName release];
    [_qualifiedName release];
    [_elementValue release];
    [_childElements release];
    [super dealloc];
}
#endif

- (void) setElementValue:(NSString*) string {
    FLSetObjectWithMutableCopy(_elementValue, string);
}

- (void) appendStringToValue:(NSString*) string {
    if(FLStringIsNotEmpty(string)) {
        if(_elementValue) {
            [_elementValue appendString:string];
        }
        else {
            _elementValue = [string mutableCopy];
        }
    }
}

- (void) addSibling:(FLParsedXmlElement*) siblingElement {
    FLParsedXmlElement* walker = self;
    while(walker.siblingElement) {
        walker = walker.siblingElement;
    }
    FLAssertNotNil(walker);
    FLAssertNil(walker.siblingElement);
    walker.siblingElement = siblingElement;
}

- (void) addChildElement:(FLParsedXmlElement*) element {
    if(!_childElements) {
        _childElements = [[NSMutableDictionary alloc] init];
    }
    element.parentElement = self;

    FLParsedXmlElement* current = [_childElements objectForKey:element.elementName];
    if(current) {
        [current addSibling:element];
    }
    else {
        [_childElements setObject:element forKey:element.elementName];
    }
}

- (FLParsedXmlElement*) childElementWithName:(NSString*) name {
    return [self childElementWithName:name maxSearchDepth:FLParsedElementDefaultSearchDepth];
}

- (FLParsedXmlElement*) childElementWithName:(NSString*) name maxSearchDepth:(NSInteger) maxSearchDepth {
    FLParsedXmlElement* item = [_childElements objectForKey:name];
    if(item) {
        return item;
    }

    if(maxSearchDepth > 0) {
        maxSearchDepth--;
        
        for(FLParsedXmlElement* childElement in [_childElements objectEnumerator]) {
            FLParsedXmlElement* found = [childElement childElementWithName:name maxSearchDepth:maxSearchDepth];
            if(found) {
                return found;
            }
        }
    }
    
    return nil;
}

- (FLParsedXmlElement*) childElementWithPath:(NSString*) path {
    FLParsedXmlElement* obj = self;
    NSArray* pathComponents = [path pathComponents];
    for(NSString* component in pathComponents) {
        obj = [obj childElementWithName:component maxSearchDepth:0];
    }
    return obj;
}

//- (NSDictionary*) childrenAtPath:(NSString*) parentalPath {
//    return [[self elementAtPath:parentalPath] childElement];
//}

- (void) prettyDescription:(id<FLStringFormatter>) stringFormatter {
    [stringFormatter appendFormat:@"<%@", self.elementName];
    if(FLStringIsNotEmpty(self.namespaceURI)) {
        [stringFormatter appendFormat:@" %@=\"%@\"", @"namespace", self.namespaceURI];
    }
    if(FLStringIsNotEmpty(self.qualifiedName)) {
        [stringFormatter appendFormat:@" %@=\"%@\"", @"qualifiedName", self.qualifiedName];
    }
    for(NSString* attr in self.attributes) {
        [stringFormatter appendFormat:@" %@=\"%@\"", attr, [self.attributes objectForKey:attr]];
    }
    [stringFormatter appendLine:@">"];
    [stringFormatter indentLinesInBlock:^{
        if(FLStringIsNotEmpty(self.elementValue)) {
            [stringFormatter appendLineWithFormat:@"%@", self.elementValue];
        }
        for(FLParsedXmlElement* element in [self.childElements objectEnumerator]) {
            [stringFormatter appendPrettyDescriptionForObject:element];
        }
    }];

    [stringFormatter appendLineWithFormat:@"</%@>", self.elementName];

    [stringFormatter appendLineWithFormat:@"<!-- %ld siblings -->", (unsigned long) self.countSiblingElements];
}

- (NSString*) description {
    return [self prettyDescription];
}

- (BOOL) isQualified {
    return FLStringsAreEqual(@"qualified", [_attributes objectForKey:@"elementFormDefault"]);
}

- (NSString*) targetNamespace {
    return [_attributes objectForKey:@"targetNamespace"];
}

- (NSString*) prefix {
    if(!_prefix) {
        _prefix = @"";
        for(NSInteger i = 0; i < _qualifiedName.length; i++) {
            if([_qualifiedName characterAtIndex:i] == ':') {
                self.prefix = [_qualifiedName substringToIndex:i];
                break;
            }
        }
        
    }
    
    return _prefix;
}



- (NSUInteger) countSiblingElements {
    NSUInteger count = 0;
    FLParsedXmlElement* walker = self;
    while(walker.siblingElement) {
        walker = walker.siblingElement;
        
        ++count;
    }
    
    return count;
}

- (void) appendFullPath:(NSMutableString*) path {
    if(self.parentElement) {
        [self.parentElement appendFullPath:path];
    }

    [path appendFormat:@"<%@>", self.elementName];
}

- (NSString*) fullPath {
    NSMutableString* fullPath = [NSMutableString string];
    [self appendFullPath:fullPath];
    return fullPath;
}

@end
