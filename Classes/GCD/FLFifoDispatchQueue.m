//
//  FLFifoDispatchQueue.m
//  FishLamp
//
//  Created by Mike Fullerton on 1/4/14.
//  Copyright (c) 2014 Mike Fullerton. All rights reserved.
//

#import "FLFifoDispatchQueue.h"

#if __MAC_10_8
#define ATTRIBUTE DISPATCH_QUEUE_SERIAL
#else
#define ATTRIBUTE nil
#endif

@implementation FLFifoDispatchQueue

+ (NSString*) queueLabel {
    static int s_count = 0;
    return [NSString stringWithFormat:@"com.fishlamp.queue.fifo%d", s_count++];
}

+ (id) fifoDispatchQueue:(NSString*) label {
    return FLAutorelease([[[self class] alloc] initWithLabel:label attr:ATTRIBUTE]);
}

+ (id) fifoDispatchQueue {
    return FLAutorelease([[[self class] alloc] init]);
}

- (id) init {
    return [self initWithLabel:[FLFifoDispatchQueue queueLabel] attr:ATTRIBUTE];
}

@end