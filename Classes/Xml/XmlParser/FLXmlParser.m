//
//  FLXmlParser.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 3/13/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLXmlParser.h"
#import "FLXmlParserErrorCode.h"
#import "FLPrettyDescription.h"
#import "FLPrettyString.h"
#import "NSString+FishLamp.h"

#import "NSArray+FishLampCore.h"
#import "FishLampSimpleLogger.h"

@interface FLXmlParser ()
@property (readwrite, strong, nonatomic) NSMutableArray* stack;
@property (readwrite, strong, nonatomic) NSXMLParser* parser; // only valid during parse
@property (readwrite, strong, nonatomic) NSError* error; // only valid during parse
@property (readwrite, strong, nonatomic) FLParsedXmlElement* rootElement;
@property (readwrite, strong, nonatomic) NSString* fileNameForErrors;
@end

@implementation FLXmlParser
@synthesize stack = _stack;
@synthesize parser = _parser;
@synthesize error = _error;
@synthesize rootElement = _rootElement;
@synthesize fileNameForErrors = _fileNameForErrors;

+ (id) xmlParser {
    return FLAutorelease([[[self class] alloc] init]);
}

- (void) dealloc {
	_parser.delegate = nil;

#if FL_MRC
    [_fileNameForErrors release];
    [_rootElement release];
    [_parser release];
    [_stack release];
    [_error release];
//    [_prefixStack release];
//    [_]
    [super dealloc];
#endif
}

- (void) willParseXMLData:(NSData*) data withXMLParser:(NSXMLParser*) parser {
	[parser setShouldProcessNamespaces:NO];
	[parser setShouldReportNamespacePrefixes:NO];
	[parser setShouldResolveExternalEntities:NO];
}

- (void) pushElement:(FLParsedXmlElement*) newElement {
    if(!_rootElement) {
        self.rootElement = newElement;
    }
    else {
        FLParsedXmlElement* item = [self.stack lastObject];
        [item addChildElement:newElement];
    }
    
    [self.stack addObject:newElement];
}

- (void) popElement {
    [self.stack removeLastObject_fl];
}

- (void)parser:(NSXMLParser *)parser 
didStartElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI 
 qualifiedName:(NSString *)qName 
    attributes:(NSDictionary *)attributes {
        
    FLParsedXmlElement* newElement = [FLParsedXmlElement parsedXmlElement];
    newElement.elementName = elementName;
    newElement.namespaceURI = namespaceURI;
    newElement.qualifiedName = qName;
    
    if(attributes && attributes.count) {
        newElement.attributes = attributes;
        for(NSString* attributeName in attributes) {
            [newElement addChildElement:[FLParsedXmlElement parsedXmlElement:attributeName elementValue:[attributes objectForKey:attributeName]]];
        }
    }
    
//    if(_prefixStack && _prefixStack.count) {
//        newElement.prefix = [_prefixStack lastObject];
//        newElement.mappedToNamespace = [_prefixDictionary objectForKey:newElement.prefix];
//    }

    [self pushElement:newElement];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    [[self.stack lastObject] appendStringToValue:string];
}

    // sent when the parser first sees a namespace attribute.
    // In the case of the cvslog tag, before the didStartElement:, you'd get one of these with prefix == @"" and namespaceURI == @"http://xml.apple.com/cvslog" (i.e. the default namespace)
    // In the case of the radar:radar tag, before the didStartElement: you'd get one of these with prefix == @"radar" and namespaceURI == @"http://xml.apple.com/radar"

- (void)parser:(NSXMLParser *)parser didStartMappingPrefix:(NSString *)prefix toURI:(NSString *)namespaceURI {

//    if(!_prefixStack) {
//        _prefixStack = [[NSMutableArray alloc] init];
//        _prefixDictionary = [[NSMutableDictionary alloc] init];
//    }
//
//    [_prefixStack addObject:prefix];
//    [_prefixDictionary setObject:namespaceURI forKey:prefix];
}

- (void)parser:(NSXMLParser *)parser didEndMappingPrefix:(NSString *)prefix {
//    FLAssert(FLStringsAreEqual(prefix, [_prefixStack lastObject]));
//    [_prefixStack removeLastObject];
}


- (void)parser:(NSXMLParser *)parser 
	didEndElement:(NSString *)elementName 
	namespaceURI:(NSString *)namespaceURI 
	qualifiedName:(NSString *)qName {
    
    FLParsedXmlElement* lastElement = FLRetainWithAutorelease([self.stack lastObject]);
    FLAssertStringsAreEqual(elementName, lastElement.elementName);

    if(FLStringIsNotEmpty(lastElement.elementValue)) {
        lastElement.elementValue = [lastElement.elementValue trimmedString_fl];
    }

    
    [self popElement];
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {

    FLPrettyString* prettyString = [FLPrettyString prettyString];
    [prettyString appendFormat: @"XMLParsing Error: %@ (%ld) at line: %ld, column: %ld in %@",
                                FLXmlParserErrorCodeStringFromEnum(parseError.code),
                                (unsigned long) parseError.code,
                                (unsigned long) parser.lineNumber,
                                (unsigned long) parser.columnNumber,
                                self.fileNameForErrors];

    for(FLParsedXmlElement* element in _stack) {
        if(FLStringIsNotEmpty(element.elementName)) {
            [prettyString appendFormat:@" <%@>", [element elementName]];
        }
    }

#if DEBUG
    FLLog(@"Parsing error: %@", prettyString.string);
#endif

    self.error = [NSError errorWithDomain:parseError.domain code:parseError.code localizedDescription:prettyString.string];

    [parser abortParsing];
}

- (void)parser:(NSXMLParser *)parser validationErrorOccurred:(NSError *)validationError {
#if DEBUG
    FLLog(@"Parsing validation error: %@", validationError);
#endif

    self.error = validationError;
    [parser abortParsing];
}

- (FLParsedXmlElement*) parseData:(NSData*) data
                fileNameForErrors:(NSString*) fileName {

    FLAssertNotNil(data);
    FLAssert(data.length > 0);

    self.stack = [NSMutableArray array];
    self.fileNameForErrors = fileName;

    @try {
        FLAutoreleasePool(
            _parser = [[NSXMLParser alloc] initWithData:data]; 
            [_parser setDelegate:self];
            
            [self willParseXMLData:data withXMLParser:_parser];
            [_parser parse];
        ) 

        FLThrowIfError(self.error);
        
//        FLPrettyString* string = [FLPrettyString prettyString];
//        [self.rootElement describeToStringFormatter:string];

        return FLRetainWithAutorelease(self.rootElement);
    }
    @finally {
		_parser.delegate = nil;
        self.fileNameForErrors = nil;
        self.parser = nil;
        self.stack = nil;
        self.error = nil;
        self.rootElement = nil;
    }
}

- (FLParsedXmlElement*) parseFileAtPath:(NSString*) path {
    return [self parseFileAtURL:[NSURL fileURLWithPath:path]];
}

- (FLParsedXmlElement*) parseFileAtURL:(NSURL*) url {
    NSError* err = nil;
    NSData* data = [NSData dataWithContentsOfURL:url options:0  error:&err];
    FLThrowIfError(FLAutorelease(err));
        
    return [self parseData:data fileNameForErrors:url.absoluteString];
}

+ (BOOL) canParseData:(NSData*) data {
    NSXMLParser* parser = FLAutorelease([[NSXMLParser alloc] initWithData:data]);

    return [parser parse];
}

+ (NSString*) removePrefix:(NSString*) string {
    for(NSInteger i = 0; i < string.length; i++) {
        if([string characterAtIndex:i] == ':') {
            return [string substringFromIndex:i + 1];
        }
    }

    return string;
}


@end
