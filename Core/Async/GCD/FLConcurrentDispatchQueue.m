//
//  FLConcurrentDispatchQueue.m
//  FishLamp
//
//  Created by Mike Fullerton on 1/4/14.
//  Copyright (c) 2014 Mike Fullerton. All rights reserved.
//

#import "FLConcurrentDispatchQueue.h"


#if __MAC_10_8
#define ATTRIBUTE DISPATCH_QUEUE_CONCURRENT
#else
#define ATTRIBUTE nil
#endif

@implementation FLConcurrentDispatchQueue

+ (NSString*) queueLabel {
    static int s_count = 0;
    return [NSString stringWithFormat:@"com.fishlamp.queue.concurrent%d", s_count++];
}

+ (FLDispatchQueue*) concurrentDispatchQueue:(NSString*) label {
    return FLAutorelease([[[self class] alloc] initWithLabel:label attr:ATTRIBUTE]);
}

+ (id) concurrentDispatchQueue {
    return FLAutorelease([[[self class] alloc] init]);
}

- (id) init {
    return [self initWithLabel:[FLConcurrentDispatchQueue queueLabel] attr:ATTRIBUTE];
}


@end
