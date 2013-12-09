//
//  FLHttpMessage.h
//  FishLamp
//
//  Created by Mike Fullerton on 10/22/11.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//
#import "FishLampMinimum.h"

#import "FishLampMinimum.h"

@interface FLHttpMessage : NSObject<NSCopying> {
@private
    CFHTTPMessageRef _message;
}
@property (readonly, assign, nonatomic) CFHTTPMessageRef messageRef; 

@property (readonly, assign, nonatomic) BOOL isHeaderComplete;
@property (readonly, strong, nonatomic) NSString* httpVersion;
@property (readonly, copy, nonatomic) NSDictionary* allHeaders;

/** request */ 
@property (readonly, assign, nonatomic) BOOL isRequest;
@property (readonly, strong, nonatomic) NSURL* requestURL;
@property (readonly, strong, nonatomic) NSString* httpMethod;

/** response */
@property (readonly, assign, nonatomic) NSInteger responseStatusCode;
@property (readonly, strong, nonatomic) NSString* responseStatusLine;

/** body */
@property (readwrite, strong, nonatomic) NSData* bodyData;

- (id) initWithHttpMessageRef:(CFHTTPMessageRef) ref; // takes ownership
- (id) initWithURL:(NSURL*) url httpMethod:(NSString*) httpMethodOrNil; // defaults to GET if nil
- (id) init;

+ (id) httpMessageWithHttpMessageRef:(CFHTTPMessageRef) ref; // takes ownership
+ (id) httpMessageWithURL:(NSURL*) url httpMethod:(NSString*) httpMethodOrNil; // defaults to GET if nil

- (void) setHeader:(NSString*) header value:(NSString*) value;
- (NSString*) valueForHeader:(NSString*) header;

- (void) setHeaders:(NSDictionary*) headers;

@end
