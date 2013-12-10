//
//  FLSoapHttpRequest.m
//  FLCore
//
//  Created by Mike Fullerton on 11/4/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLSoapHttpRequest.h"
#import "FLXmlObjectBuilder.h"
#import "FLSoapError.h"
#import "FLSoapFault11.h"
#import "FLSoapStringBuilder.h"
#import "FLXmlDataEncoder.h"
#import "FLSoapParser.h"
#import "FLObjectDescriber.h"
#import "FLSoapFault11.h"
#import "FLStringToObjectConverting.h"
#import "FLParsedXmlElement.h"
#import "FLHttpResponse.h"
#import "FLHttpRequestBody.h"
#import "FLHttpRequest.h"

#define TRACE 0

#define BIG_TRACE 0

@implementation FLSoapHttpRequest 

#define MAX_ERR_LEN 500

- (id) init {	
    return [self initWithRequestURL:[NSURL URLWithString:self.url] httpMethod:@"POST"];
}

+ (id) soapRequest {
    return FLAutorelease([[[self class] alloc] init]);
}

+ (id) soapRequestWithURL:(NSURL*) url {
    return FLAutorelease([[[self class] alloc] initWithRequestURL:url httpMethod:@"POST"]);
}

- (NSString*) location {
    return nil;
}

- (NSString*) soapAction {
    return nil;
}

- (NSString*) targetNamespace {
    return nil;
}

- (NSString*) operationName {
    return nil;
}

- (NSString*) url {
    return nil;
}

- (id) input {
    return nil;
}

- (id) output {
    return nil;
}

+ (id) soapRequestWithURL:(NSURL*) url
               httpMethod:(NSString*) httpMethod {
    return FLAutorelease([[[self class] alloc] init]);
}

- (FLSoapFault11*) checkForSoapFaultInData:(NSData*) data {
	if(data && data.length >0 ) {
		char* first = strnstr((const char*) [data bytes], "Fault", MIN([data length], (unsigned int) MAX_ERR_LEN));
        if(first) {
            FLParsedXmlElement* soap = [[[FLSoapParser soapParser] parseData:data fileNameForErrors:self.soapAction] childElementWithName:@"Fault" maxSearchDepth:5];
            FLAssertNotNil(soap);

            FLSoapFault11* soapFault = [[FLXmlObjectBuilder xmlObjectBuilder] buildObjectOfClass:[FLSoapFault11 class] withXML:soap];

//            [FLSoapFault11 objectWithXmlElement:soap
//                                                               elementName:@"Fault"
//                                                         withObjectBuilder:[FLSoapObjectBuilder instance]];

            FLAssertNotNil(soapFault);
			FLLog(@"Soap Fault:%@/%@", [soapFault faultcode], [soapFault faultstring]);
            return soapFault;
		}
	}

	return nil;
}

- (void) willOpen {
    FLAssertStringIsNotEmpty(self.requestHeaders.requestURL.absoluteString);
    FLAssertStringIsNotEmpty(self.targetNamespace);
    FLAssertStringIsNotEmpty(self.operationName);

    FLSoapStringBuilder* soapStringBuilder = [FLSoapStringBuilder soapStringBuilder];
    
    FLObjectXmlElement* element = [FLObjectXmlElement soapXmlElementWithObject:self.input
                                                                 xmlElementTag:self.operationName
                                                                  xmlNamespace:self.targetNamespace];

	[soapStringBuilder appendSection:element];
    NSString* soap = [soapStringBuilder buildStringWithNoWhitespace];
    [self.requestHeaders setValue:self.soapAction forHTTPHeaderField:@"SOAPAction"];
    [self.requestBody setUtf8Content:soap];
    
#if BIG_TRACE
    FLLog(@"Soap Request:");
    FLLog([self.requestHeaders description]);
    FLLog(soap);
#endif

//#if DEBUG
//    FLPrettyString* debugString = [FLPrettyString prettyString];
//    [debugString appendBuildableString:soapStringBuilder];
//
//    self.requestBody.debugBody = debugString.string;
//    
//#if TRACE
////    FLTrace(@"Soap Request:"); 
//    
//    FLLogIndent(^{
//        FLLog([self.requestHeaders description]);
//        FLLog([self.requestBody description]);
//    });
//    
//    
////    , [self requestHeaders]);
////    FLTrace(@"%@", debugString.string);
//#endif    
//    
////    FLLog([self description]);
//#endif    
}

- (void) throwErrorIfResponseIsError:(FLHttpResponse*) httpResponse {

// TODO: this is prone to breakage - why is this here?
    [httpResponse.responseData closeSinkWithCommit:YES];
    
    NSData* data = httpResponse.responseData.data;
    FLAssertNotNil(data);
    
    FLSoapFault11* fault = [self checkForSoapFaultInData:data];
    if(fault) {
        NSError* error =  [NSError errorWithSoapFault:fault];
#if DEBUG
        FLLog(@"Soap Fault: %@", [fault description]);
#endif
        FLThrowError(error);
    }
}

- (id) convertResponseToPromisedResult:(FLHttpResponse *)httpResponse {
    
    NSData* data = [httpResponse.responseData data];
    FLAssertNotNil(data);

#if BIG_TRACE
    FLLog(@"Soap Response:");
    FLLog([[httpResponse responseHeaders] description]);
    FLLog(FLAutorelease([[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]));
#endif    

    FLParsedXmlElement* parsedSoap = [[FLSoapParser soapParser] parseData:data fileNameForErrors:self.soapAction];

    if(FLStringIsNotEmpty([self typeNameForSoapResponse])) {

        FLParsedXmlElement* elementForObject = [self findResponseElementInSoapResponse:parsedSoap];
        FLAssertNotNil(elementForObject);

        id soapResponse = [[FLXmlObjectBuilder xmlObjectBuilder] buildObjectOfType:[self typeNameForSoapResponse] withXML:elementForObject];
        FLAssertNotNil(soapResponse);

        return soapResponse;
    }

    return parsedSoap;
}

- (NSString*) xmlElementNameForResponse {
    return @"Body";
}

- (FLParsedXmlElement*) findResponseElementInSoapResponse:(FLParsedXmlElement*) soapResponse {
    return [soapResponse childElementWithName:[self xmlElementNameForResponse] maxSearchDepth:5];
}

- (NSString*) typeNameForSoapResponse {
    return nil;
}


@end

@implementation FLMutableSoapHttpRequest
//@synthesize input =_input;
//@synthesize output = _output;
@synthesize soapAction = _soapAction;
@synthesize targetNamespace = _targetNamespace;
@synthesize operationName = _operationName;

#if FL_MRC
- (void) dealloc {
//    [_input release];
    [_soapAction release];
    [_operationName release];
    [_targetNamespace release];
    [super dealloc];
}
#endif

@end


