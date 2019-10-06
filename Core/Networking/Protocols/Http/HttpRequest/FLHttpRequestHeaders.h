//
//  FLHttpRequestHeaders.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 12/22/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampCore.h"

#define FLHttpRequestDefaultHTTPVersion @"1.1"

@interface FLHttpRequestHeaders : NSObject<NSCopying> {
@private 
    NSMutableDictionary* _headers;
    NSURL* _requestURL;
    NSString* _httpMethod;
    unsigned long long _postLength;
}
@property (readonly, strong, nonatomic) NSDictionary* allHeaders;

@property (readwrite, strong, nonatomic) NSURL* requestURL;

@property (readwrite, strong, nonatomic) NSString* httpMethod;

@property (readwrite, assign, nonatomic, getter=isPostRequest) BOOL postRequest;
@property (readwrite, strong, nonatomic) NSString* hostHeader;
@property (readwrite, strong, nonatomic) NSString* userAgentHeader;
@property (readwrite, assign, nonatomic) unsigned long long contentLengthHeader;
@property (readwrite, strong, nonatomic) NSString* contentTypeHeader;

@property (readwrite, assign, nonatomic) unsigned long long postLength;

- (void) setValue:(NSString *)value forHTTPHeaderField:(NSString *)field;

- (NSString *) valueForHTTPHeaderField:(NSString *) field;

- (BOOL) hasHTTPHeaderField:(NSString*) header;

- (void) removeHTTPHeaderField:(NSString*) field;


@end
