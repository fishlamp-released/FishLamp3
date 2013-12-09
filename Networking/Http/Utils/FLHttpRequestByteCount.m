//
//  FLHttpRequestByteCount.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 4/26/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLHttpRequestByteCount.h"


@interface FLHttpRequestByteCount ()
@property (readwrite, assign) unsigned long long byteCount;
@property (readwrite, assign) NSTimeInterval startTime;
@property (readwrite, assign) NSTimeInterval lastTime;
@property (readwrite, assign) unsigned long lastIncrementAmount;
@end

@implementation FLHttpRequestByteCount
@synthesize byteCount = _byteCount;
@synthesize startTime = _startTime;
@synthesize lastTime = _lastTime;
@synthesize lastIncrementAmount = _lastIncrementAmount;

#define kMegaBits 131072

- (double) bytesPerSecond {
    NSTimeInterval elapsedTime = self.elapsedTime;
    unsigned long long downloadedByteCount = self.byteCount;
    
    if(elapsedTime && downloadedByteCount) {
        return (downloadedByteCount / elapsedTime);
    }
    
    return 0;
}
- (NSTimeInterval) elapsedTime {
    return self.lastTime - self.startTime;
}

+ (id) httpRequestByteCount {
    return FLAutorelease([[[self class] alloc] init]);
}

- (id) copyWithZone:(NSZone *)zone {
    FLHttpRequestByteCount* count = [[FLHttpRequestByteCount alloc] init];
    count.byteCount = self.byteCount;
    count.startTime = self.startTime;
    count.lastTime = self.lastTime;
    count.lastIncrementAmount = self.lastIncrementAmount;
    return count;
}

- (void) setStartTime {
    self.startTime = [NSDate timeIntervalSinceReferenceDate]; 
}

- (void) setFinishTime {
    self.lastTime = [NSDate timeIntervalSinceReferenceDate]; 
}

- (void) incrementByteCount:(NSNumber*) amount {
    self.lastIncrementAmount = [amount unsignedLongValue];
    self.byteCount += self.lastIncrementAmount;
    self.lastTime = [NSDate timeIntervalSinceReferenceDate]; 
}


@end
    
    