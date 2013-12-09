//
//  NSURLRequest+HTTP.h
//  FishLamp
//
//  Created by Mike Fullerton on 5/19/11.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton.
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampMinimum.h"

@interface NSURLRequest (HTTP)

- (BOOL) hasHeader:(NSString*) header;

- (NSString*) postHeader;

@end

@interface NSMutableURLRequest (HTTP)

- (void) setUserAgentHeader:(NSString*) userAgent;

- (void) setUserAgentHeader;

- (void) setHeader:(NSString*)headerName 
			  data:(NSString*)data;

- (void) setFormUrlEncodedContent:(NSString*) content;


- (void) setHostHeader:(NSString*) host;
- (void) setHTTPMethodToPost;

/**
    set content
 */
 
- (void) setContentWithData:(NSData*) content
          typeContentHeader:(NSString*) typeContentHeader;

- (void) setContentWithInputStream:(NSInputStream*) stream
                 typeContentHeader: (NSString*) typeContentHeader 
                         inputSize:(unsigned long long) size;

- (void) setContentWithFilePath:(NSString*) path 
              typeContentHeader:(NSString*) typeContentHeader;

- (void) setUtf8Content:(NSString*) content;

- (void) setContentLengthHeader:(unsigned long long) length;
- (void) setContentTypeHeader:(NSString*) contentType;

- (void) setImageContentWithData:(NSData*) imageData;
- (void) setImageContentWithFilePath:(NSString*) filePath;
- (void) setImageContentWithInputStream:(NSInputStream*) stream	 inputSize:(NSUInteger) size;


@end

