//
//  FLXmlElement.m
//  FishLamp
//
//  Created by Mike Fullerton on 9/6/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLXmlElement.h"
#import "FLXmlStringBuilder.h"
#import "FLStringToObjectConversionManager.h"
#import "FLXmlComment.h"

@interface FLXmlElement ()
@property (readwrite, strong, nonatomic) NSString* xmlElementTag;
@property (readwrite, strong, nonatomic) NSString* xmlElementCloseTag;
@end

@implementation FLXmlElement

@synthesize xmlElementTag = _openTag;
@synthesize xmlElementCloseTag = _closeTag;
@synthesize dataEncoder = _dataEncoder;

- (id) initWithXmlElementTag:(NSString*) xmlElementTag 
          xmlElementCloseTag:(NSString*) xmlElementCloseTag {

    FLAssertStringIsNotEmpty(xmlElementTag);

    self = [super init];
    if(self) {
        self.xmlElementTag = xmlElementTag;
        self.xmlElementCloseTag = FLStringIsNotEmpty(xmlElementCloseTag) ? xmlElementCloseTag : xmlElementTag;
    }
    return self;
}

- (id) initWithXmlElementTag:(NSString*) xmlElementTag {
    return [self initWithXmlElementTag:xmlElementTag xmlElementCloseTag:xmlElementTag];
}

+ (id) xmlElement:(NSString*) xmlElementTag xmlElementCloseTag:(NSString*) xmlElementCloseTag {
    return FLAutorelease([[[self class] alloc] initWithXmlElementTag:xmlElementTag xmlElementCloseTag:xmlElementCloseTag]);
}

+ (id) xmlElement:(NSString*) name {
    return FLAutorelease([[[self class] alloc] initWithXmlElementTag:name xmlElementCloseTag:name]);
}

#if FL_MRC
- (void) dealloc {
    [_dataEncoder release];
    [_openTag release];
    [_closeTag release];
    [_attributes release];
    [_comments release];
    [super dealloc];
}
#endif

- (FLStringToObjectConversionManager*) dataEncoder {
//    if(!_dataEncoder) {
//        id walker = self.parent;
//        while(walker) {
//            if([walker respondsToSelector:@selector(dataEncoder)]) {
//                id dataEncoder = [walker dataEncoder];
//                if(dataEncoder) {
//                    self.dataEncoder = dataEncoder;
//                    break;
//                }
//
//            }
//            walker = [walker parent];
//        }
//    
//        FLAssertNotNil(_dataEncoder);
//    }
//
//
    FLAssertNotNil(self.stringDocument);

    FLStringToObjectConversionManager* encoder = [self.stringDocument dataEncoder];
    FLAssertNotNil(encoder);

    return encoder;
}


- (void) appendFullPath:(NSMutableString*) path {
    if(self.stringDocument) {
        FLAssert([self.stringDocument isKindOfClass:[FLXmlElement class]]);
        [((id)self.stringDocument) appendFullPath:path];
    }

    if(path.length) {
        [path appendFormat:@"/%@", self.xmlElementTag];
    }
    else {
        [path appendString:self.xmlElementTag];
    }
}

- (NSString*) fullPath {
    NSMutableString* fullPath = [NSMutableString string];
    [self appendFullPath:fullPath];
    return fullPath;
}

- (void) setAttribute:(NSString*) attributeValue forKey:(NSString*) key {
    FLAssertNotNil(attributeValue);
    FLAssertNotNil(key);

    if(!_attributes) {
        _attributes = [[NSMutableDictionary alloc] init];
    }
    
    [_attributes setObject:attributeValue forKey:key];
}

- (void) appendAttribute:(NSString*) attributeValue forKey:(NSString*) key {

    FLAssertNotNil(attributeValue);
    FLAssertNotNil(key);

    if(!_attributes) {
        [self setAttribute:attributeValue forKey:key];
    }
    else {
        NSString* value = [_attributes objectForKey:key];
        if(value) {
            value = [NSString stringWithFormat:@"%@%@", value, attributeValue];
        }
        if(value) {
            [_attributes setObject:value forKey:key];
        }
    }
}

- (FLXmlComment*) comments {
    
    if(!_comments) {
        _comments = [FLXmlComment xmlComment];
    }
    
    return _comments;
}

//- (void) appendSection:(FLXmlElement*) element {
//    FLAssertNotNil(element);
//    [self appendSection:element];
//}

- (NSString*) xmlOpenTag:(BOOL) isEmpty {
    
    if(_attributes && _attributes.count) {
    
        NSMutableString* attributedOpenTag = [NSMutableString stringWithFormat:@"<%@", self.xmlElementTag];
    
        for(NSString* key in _attributes) {
            [attributedOpenTag appendFormat:@" %@=\"%@\"", key, [_attributes objectForKey:key]];
        }
        
        if(isEmpty) {
            [attributedOpenTag appendString:@"/>"];
        }
        else {
            [attributedOpenTag appendString:@">"];
        }
        
        return attributedOpenTag;
    }
    else if(isEmpty) {
        return [NSString stringWithFormat:@"<%@ />", self.xmlElementTag];
    }
    else {
        return [NSString stringWithFormat:@"<%@>", self.xmlElementTag];
    }
    
}

- (void) stringFormatter:(FLStringFormatter *)formatter
appendContentsToStringFormatter:(id<FLStringFormatter>)stringFormatter {

    FLAssertNotNil(stringFormatter);
    FLAssertNotNil(self.lines);

  //  FLLog(@"appending %@ to %@", [self description], [stringFormatter description]);

    if(_comments) {
        [stringFormatter appendString:_comments];
    }

    BOOL hasLines = self.lines.count > 0;
//    FLAssert(hasLines); // xml element should always have something, right?

#if TRACE
    if(!hasLines) {
        FLLog(@"xml element %@ has no lines", self.xmlElementTag)
    }
#endif

    [stringFormatter appendLine:[self xmlOpenTag:!hasLines]];
    if(hasLines) {
        [stringFormatter indentLinesInBlock:^{
            [super stringFormatter:self appendContentsToStringFormatter:stringFormatter];
        }];

        [stringFormatter appendLine:[NSString stringWithFormat:@"</%@>", self.xmlElementCloseTag]];
    }
}      

@end



