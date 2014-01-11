//
//  FLDataSink.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 3/31/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLDataSink.h"

@interface FLDataSink ()
@property (readwrite, strong, nonatomic) NSData* data;
@property (readwrite, strong, nonatomic) NSMutableData* responseData;
@end

@implementation FLDataSink

@synthesize data = _data;
@synthesize responseData = _responseData;

+ (id) dataSink {
    return FLAutorelease([[[self class] alloc] init]);
}

- (void) appendBytes:(const void *)bytes length:(NSUInteger)length {
    [self.responseData appendBytes:bytes length:length];
}

- (void) openSink {
    FLAssertNil(self.responseData);

    self.responseData = [NSMutableData data];
    self.data = nil;
}

- (BOOL) isOpen {
    return self.responseData != nil;
}

- (void) closeSinkWithCommit:(BOOL) commit {

    if(commit) {
        self.data = self.responseData;
        self.responseData = nil;
    }
    else  {
        self.data = nil;
        self.responseData = nil;
    }
}

- (void) commit {
}

#if FL_MRC
- (void) dealloc {
    [_responseData release];
    [_data release];
    [super dealloc];
}
#endif

- (NSString*) filePath {
    return nil;
}
@end
