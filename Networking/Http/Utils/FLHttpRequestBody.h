//
//  FLHttpRequestBody.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 12/22/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampMinimum.h"
#import "FLHttpRequestHeaders.h"

@interface FLHttpRequestBody : NSObject {
@private
    FLHttpRequestHeaders* _requestHeaders;
    NSString* _postBodyFilePath;
    NSData* _postData;
    NSInputStream* _bodyStream;
#if DEBUG
    NSString* _debugBody;
#endif    
}

- (id) initWithHeaders:(FLHttpRequestHeaders*) headers;

@property (readonly, strong, nonatomic) FLHttpRequestHeaders* requestHeaders;

@property (readwrite, strong, nonatomic) NSData* bodyData;
@property (readwrite, strong, nonatomic) NSInputStream* bodyStream;
@property (readwrite, strong, nonatomic) NSString* postBodyFilePath;

- (void) setFormUrlEncodedContent:(NSString*) content;
 
- (void) setContentWithData:(NSData*) content
          typeContentHeader:(NSString*) typeContentHeader;

- (void) setContentWithFilePath:(NSString*) path 
              typeContentHeader:(NSString*) typeContentHeader;

- (void) setUtf8Content:(NSString*) content;

// TODO: refactor away from JPEG specific type
- (void) setJpegContentWithData:(NSData*) imageData;

- (void) setJpegContentWithFilePath:(NSString*) filePath;

#if DEBUG
@property (readwrite, strong, nonatomic) NSString* debugBody;
#endif
@end
