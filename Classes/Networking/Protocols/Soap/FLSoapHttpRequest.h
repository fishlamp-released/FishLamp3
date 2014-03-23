//
//  FLSoapHttpRequest.h
//  FLCore
//
//  Created by Mike Fullerton on 11/4/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLHttpRequest.h"
@class FLSoapFault11;
@class FLParsedXmlElement;

@interface FLSoapHttpRequest : FLHttpRequest

+ (id) soapRequestWithURL:(NSURL*) url;

+ (id) soapRequestWithURL:(NSURL*) url
               httpMethod:(NSString*) httpMethod; // is soap always POST??

+ (id) soapRequest;

- (NSString*) location;
- (NSString*) soapAction;
- (NSString*) targetNamespace;
- (NSString*) operationName;
- (NSString*) url;

- (NSString*) xmlElementNameForResponse;
- (NSString*) typeNameForSoapResponse;

- (FLSoapFault11*) checkForSoapFaultInData:(NSData*) data;

- (FLParsedXmlElement*) findResponseElementInSoapResponse:(FLParsedXmlElement*) soapResponse;
@end

@interface FLMutableSoapHttpRequest : FLSoapHttpRequest {
@private
    NSString* _targetNamespace;
    NSString* _soapAction;
    NSString* _operationName;
}
@property (readwrite, strong, nonatomic) NSString* soapAction;
@property (readwrite, strong, nonatomic) NSString* targetNamespace;
@property (readwrite, strong, nonatomic) NSString* operationName;

@end