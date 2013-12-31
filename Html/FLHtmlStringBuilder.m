//
//	FLHtmlStringBuilder.m
//	FishLamp
//
//	Created by Mike Fullerton on 1/26/10.
//	Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLHtmlStringBuilder.h"

NSString* const FLXmlDocTypeHtml5 = @"html";
NSString* const FLXmlDocTypeHtml4_01Strict = @"HTML PUBLIC \"-//W3C//DTD HTML 4.01//EN\" \"http://www.w3.org/TR/html4/strict.dtd\"";
NSString* const FLXmlDocTypeHtml4_01Transitional = @"HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\" \"http://www.w3.org/TR/html4/loose.dtd\"";
NSString* const FLXmlDocTypeHtml4_01Frameset = @"HTML PUBLIC \"-//W3C//DTD HTML 4.01 Frameset//EN\" \"http://www.w3.org/TR/html4/frameset.dtd\"";
NSString* const FLXmlDocTypeXHtml1_0Strict = @"html PUBLIC \"-//W3C//DTD XHTML 1.0 Strict//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd\"";
NSString* const FLXmlDocTypeXHtml1_0Transitional = @"html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\"";
NSString* const FLXmlDocTypeXHtml1_0Frameset = @"html PUBLIC \"-//W3C//DTD XHTML 1.0 Frameset//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-frameset.dtd\"";
NSString* const FLXMLDocTypeXHtml1_1 = @"html PUBLIC \"-//W3C//DTD XHTML 1.1//EN\" \"http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd\"";

@interface FLHtmlStringBuilder ()
-(void) addDocTypeHeader:(NSString*) header;
@end

@implementation FLHtmlStringBuilder

@synthesize htmlElement = _htmlElement;
@synthesize headElement = _headElement;
@synthesize bodyElement = _bodyElement;

- (id) initWithDocType:(NSString*) docType {
    
    self = [super init];
    if(self) {
        [self addDocTypeHeader:docType];
        _htmlElement = [FLXmlElement xmlElement:@"html"];
        _headElement = [FLXmlElement xmlElement:@"head"];
        _bodyElement = [FLXmlElement xmlElement:@"body"];
        [self openSection:_htmlElement];
        [self appendSection:_headElement];
        [self openSection:_bodyElement];
    }

    return self;
}

+ (FLHtmlStringBuilder*) htmlStringBuilder:(NSString*) docType {
    return FLAutorelease([[FLHtmlStringBuilder alloc] initWithDocType:docType]);
}

-(void) addDocTypeHeader:(NSString*) header {
    [self appendFormat:@"<!DOCTYPE %@>", header];
    [self closeLine];
}

+ (NSString*) convertNewlinesToHtmlBreaks:(NSString*) input {
	NSString* string = [input stringByReplacingOccurrencesOfString:@"\r\n" withString:@"\n"];
	return [string stringByReplacingOccurrencesOfString:@"\n" withString:@"<br/>"];
}

+ (NSString*) convertHtmlBreaksToNewlines:(NSString*) input {
	return [input stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
}

+ (BOOL) hasHtmlLineBreaks:(NSString*) input {
	return [input rangeOfString:@"<br/>"].length > 0;
}

#if FL_MRC
- (void) dealloc {
    [_htmlElement release];
    [_headElement release];
    [_bodyElement release];
    [super dealloc];
}
#endif


- (FLXmlElement*) addBreakElement {
    FLXmlElement* element = [FLXmlElement xmlElement:@"br"];
    [self appendSection:element];
    return element;
}

- (FLXmlElement*) addDivElement {
    FLXmlElement* element = [FLXmlElement xmlElement:@"div"];
    [self appendSection:element];
    return element;
}

- (FLXmlElement*) addLinkElement:(NSString*) href 
                            link:(NSString*) link 
                            text:(NSString*) text {
                            
    FLXmlElement* element = [FLXmlElement xmlElement:@"a"];
    [element setAttribute:link forKey:@"href"];
    [element appendString:text];
    [self appendSection:element];
	return element;
}
@end

@implementation FLXmlElement (FLHtmlStringBuilder)

- (void) addStyleClearBackgroundColor {
	[self appendAttribute:@"background-color:transparent; " forKey:@"style"];
}

- (void) addStyleWidth:(NSUInteger) width {
	[self appendAttribute:[NSString stringWithFormat:@"width:%ldpx; ", (long) width] forKey:@"style"];
}

- (void) addStyleHorizontallyCenter {
	[self appendAttribute:@"margin-left:auto; margin-right:auto; " forKey:@"style"];
}

@end

