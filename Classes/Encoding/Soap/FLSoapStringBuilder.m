//
//	FLSoapStringBuilder.m
//	FishLamp
//
//	Created By Mike Fullerton on 4/20/09.
//	Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLSoapStringBuilder.h"
#import "FLXmlDataEncoder.h"
#import "FLObjectXmlElement.h"

@interface FLSoapStringBuilder ()
@property (readonly, strong, nonatomic) FLXmlElement* envelope;
@property (readonly, strong, nonatomic) FLXmlElement* body;
@end

@implementation FLSoapStringBuilder

@synthesize body = _bodyElement;
@synthesize envelope = _envelopeElement;

+ (id) soapStringBuilder {
    return FLAutorelease([[[self class] alloc] init]);
}

#if FL_MRC
- (void) dealloc {
    [_envelopeElement release];
    [_bodyElement release];
    [super dealloc];
}
#endif

- (void) openXmlDocument {
    self.dataEncoder = [FLXmlDataEncoder instance];
    
    [self appendDefaultXmlHeader];

    _envelopeElement = [[FLXmlElement alloc] initWithXmlElementTag:@"soap:Envelope"];
    [self openSection:_envelopeElement];

    [_envelopeElement setAttribute:@"http://www.w3.org/2001/XMLSchema-instance"  forKey:@"xmlns:xsi"];
    [_envelopeElement setAttribute:@"http://www.w3.org/2001/XMLSchema" forKey:@"xmlns:xsd"];
    [_envelopeElement setAttribute:@"http://schemas.xmlsoap.org/soap/envelope/"forKey:@"xmlns:soap" ];
    
    _bodyElement = [[FLXmlElement alloc] initWithXmlElementTag:@"soap:Body"];
    [self openSection:_bodyElement];
}

-(void) appendXmlVersionHeader:(NSString*) version 
               andEncodingHeader:(NSString*) encoding
               standalone:(BOOL) standalone {
    
    [self appendLineWithFormat:@"<?xml version=\"%@\" encoding=\"%@\"?>", version, encoding];
}

@end

@implementation FLXmlElement (Soap)

//- (NSString*) encodeString:(NSString*) string {
//	return [string xmlEncode];
//}

+ (id) soapXmlElementWithObject:(id) object                 
                  xmlElementTag:(NSString*) functionName 
                   xmlNamespace:(NSString*) xmlNamespace {

    FLObjectXmlElement* element = [FLObjectXmlElement objectXmlElement:object xmlElementTag:functionName];
    [element setAttribute:xmlNamespace forKey:@"xmlns"];
    return element;
}

- (void) addSoapParameter:(NSString*) name value:(NSString*) value {
    FLXmlElement* element = [FLXmlElement xmlElement:name];
    [element appendLine:value];
	[self appendSection:element];
}

- (void) addSoapParameters:(NSDictionary*) parameters {
	for(NSString* key in parameters) {
		[self addSoapParameter:key value:[parameters valueForKey:key]];
	}
}

@end