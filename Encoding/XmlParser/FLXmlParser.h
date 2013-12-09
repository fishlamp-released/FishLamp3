//
//  FLXmlParser.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 3/13/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampMinimum.h"
#import "FLParsedXmlElement.h"

#define FLXmlParserDomain @"FLXmlParserDomain"

@interface FLXmlParser : NSObject<NSXMLParserDelegate> {
@private
    NSXMLParser* _parser;
    NSMutableArray* _stack;
    NSError* _error;

    NSString* _fileNameForErrors;

    FLParsedXmlElement* _rootElement;
    
//    NSMutableDictionary* _prefixDictionary;
//    NSMutableArray* _prefixStack;
}

+ (id) xmlParser;

- (FLParsedXmlElement*) parseFileAtPath:(NSString*) path;

- (FLParsedXmlElement*) parseFileAtURL:(NSURL*) url;

- (FLParsedXmlElement*) parseData:(NSData*) data fileNameForErrors:(NSString*) fileName;

// optional override
- (void) willParseXMLData:(NSData*) data 
            withXMLParser:(NSXMLParser*) parser;

+ (BOOL) canParseData:(NSData*) data;

+ (NSString*) removePrefix:(NSString*) string;
@end
