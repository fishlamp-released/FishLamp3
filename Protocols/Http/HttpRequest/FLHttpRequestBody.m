//
//  FLHttpRequestBody.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 12/22/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLHttpRequestBody.h"

@interface FLHttpRequestBody ()
@property (readwrite, strong, nonatomic) FLHttpRequestHeaders* requestHeaders;
@end

@implementation FLHttpRequestBody

@synthesize requestHeaders = _requestHeaders;

@synthesize postBodyFilePath = _postBodyFilePath;
@synthesize bodyData = _postData;
@synthesize bodyStream = _bodyStream;
#if DEBUG
@synthesize debugBody = _debugBody;
#endif

- (id) init {
    self = [super init];
    if(self) {
    }
    return self;
}

- (id) initWithHeaders:(FLHttpRequestHeaders*) headers {
    self = [super init];
    if(self) {
        self.requestHeaders = headers;
    }
    return self;

}

#if FL_MRC
- (void) dealloc {
    [_requestHeaders release];
    [_postData release];
    [_bodyStream release];
    [_postBodyFilePath release];
#if DEBUG
    [_debugBody release];
#endif    
    [super dealloc];
}
#endif

-(void) setUtf8Content:(NSString*) content {
    FLAssertIsNotNilWithComment(content, nil);

	[self setContentWithData:[content dataUsingEncoding:NSUTF8StringEncoding]
           typeContentHeader:@"text/xml; charset=utf-8" ];
}

- (void) setFormUrlEncodedContent:(NSString*) content {
    FLAssertIsNotNilWithComment(content, nil);
    
	[self setContentWithData:[content dataUsingEncoding:NSUTF8StringEncoding]
           typeContentHeader:@"application/x-www-form-urlencoded" ]; 
}

- (void) setContentWithData:(NSData*) content
          typeContentHeader:(NSString*) typeContentHeader {
    FLAssertIsNotNilWithComment(content, nil);
	FLAssertStringIsNotEmptyWithComment(typeContentHeader, nil);

    self.bodyData = content;
	[self.requestHeaders setContentTypeHeader:typeContentHeader];
	[self.requestHeaders setContentLengthHeader:[content length]];
}

- (void) setContentWithFilePath:(NSString*) path 
              typeContentHeader:(NSString*) typeContentHeader {
	FLAssertStringIsNotEmptyWithComment(typeContentHeader, nil);
    FLAssertWithComment([[NSFileManager defaultManager] fileExistsAtPath:path], @"File at %@ doesn't exist", path);

	[self.requestHeaders setContentTypeHeader:typeContentHeader];
    self.postBodyFilePath = path;
}

- (void) setJpegContentWithFilePath:(NSString*) filePath {
	[self setContentWithFilePath:filePath typeContentHeader:@"image/jpeg"];
}

- (void) setJpegContentWithData:(NSData*) imageData {
	FLAssertIsNotNilWithComment(imageData, nil);
	FLAssertWithComment(imageData.length > 0, @"Empty data");
	[self setContentWithData:imageData typeContentHeader:@"image/jpeg"];
}

- (void) setBodyData:(NSData*) data {
    self.requestHeaders.postLength = 0;
    FLReleaseWithNil(_postBodyFilePath);
    FLSetObjectWithRetain(_postData, data);
    if (_postData) {
        self.requestHeaders.postLength = _postData.length;
        self.requestHeaders.httpMethod = @"POST";
	}
}

- (void) setPostBodyFilePath:(NSString*) path {
    self.requestHeaders.postLength = 0;
    FLReleaseWithNil(_postData);
    
    FLSetObjectWithRetain(_postBodyFilePath, path);
    if(FLStringIsNotEmpty(_postBodyFilePath)) {
        NSError* err = nil;
            self.requestHeaders.postLength = [[[NSFileManager defaultManager] attributesOfItemAtPath:self.postBodyFilePath error:&err] fileSize];
        
        if(err) {
           FLThrowIfError(FLAutorelease(err));
        }
        self.requestHeaders.httpMethod = @"POST";
	}
}

- (NSInputStream*) bodyStream {
    if(!_bodyStream) {
        if(FLStringIsNotEmpty(self.postBodyFilePath)) {
            _bodyStream = [[NSInputStream alloc] initWithFileAtPath:self.postBodyFilePath];
        }
    }
    return _bodyStream;
}

- (NSString*) description {

    NSMutableString* desc = [NSMutableString stringWithFormat:@"%@\r\n", [super description]];

#if DEBUG
    if(FLStringIsNotEmpty(_debugBody)) {
        [desc appendFormat:@"body:\r\n%@", _debugBody];
    }
#endif
    
    if(_postData) {
//        @try {
//            NSString* postDataString = FLAutorelease([[NSString alloc] initWithData:_postData encoding:NSUTF8StringEncoding]);
//            if(postDataString && postDataString.length) {
//                [desc appendFormat:@"Request body:\r\n%@\r\n", postDataString];
//            }
//        }
//        @catch(NSException* ex) {
//        
//        }
    }

    if(FLStringIsNotEmpty(_postBodyFilePath)) {
        [desc appendFormat:@"request body (file path):%@\r\n", _postBodyFilePath];
    }

    return desc;
}



@end
