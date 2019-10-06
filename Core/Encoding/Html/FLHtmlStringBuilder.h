//
//	FLHtmlBuilder.h
//	FishLamp
//
//	Created by Mike Fullerton on 1/26/10.
//	Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampCore.h"

#import "FLXmlStringBuilder.h"
#import "FLXmlElement.h"

// html

extern NSString* const FLXmlDocTypeHtml5;
extern NSString* const FLXmlDocTypeHtml4_01Strict;
extern NSString* const FLXmlDocTypeHtml4_01Transitional;
extern NSString* const FLXmlDocTypeHtml4_01Frameset;
extern NSString* const FLXmlDocTypeXHtml1_0Strict;
extern NSString* const FLXmlDocTypeXHtml1_0Transitional;
extern NSString* const FLXmlDocTypeXHtml1_0Frameset;
extern NSString* const FLXMLDocTypeXHtml1_1;

@interface FLHtmlStringBuilder : FLXmlStringBuilder {
@private
    FLXmlElement* _htmlElement;
    FLXmlElement* _headElement;
    FLXmlElement* _bodyElement;
}

+ (FLHtmlStringBuilder*) htmlStringBuilder:(NSString*) docType;

@property (readonly, strong, nonatomic) FLXmlElement* htmlElement;
@property (readonly, strong, nonatomic) FLXmlElement* headElement;
@property (readonly, strong, nonatomic) FLXmlElement* bodyElement;

// converts \n <-> <BR/> and back. 
+ (NSString*) convertNewlinesToHtmlBreaks:(NSString*) input;
+ (NSString*) convertHtmlBreaksToNewlines:(NSString*) input;
+ (BOOL) hasHtmlLineBreaks:(NSString*) input;


- (FLXmlElement*) addLinkElement:(NSString*) href 
                            link:(NSString*) link 
                            text:(NSString*) text;
                            
- (FLXmlElement*) addBreakElement;

- (FLXmlElement*) addDivElement;

@end

@interface FLXmlElement (FLHtmlStringBuilder)

// these are style attributes!
- (void) addStyleHorizontallyCenter;
- (void) addStyleWidth:(NSUInteger) width;
- (void) addStyleClearBackgroundColor;


@end

