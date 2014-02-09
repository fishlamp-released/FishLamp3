//
//  FLMainThreadObject.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 6/24/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLMainThreadObject.h"
#import "FishLampAssertions.h"

@implementation FLMainThreadObject

+ (id) mainThreadObject:(id) object {
    return FLAutorelease([[[self class] alloc] initWithRetainedObject:object]);
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    
    id object = [self representedObject];
    FLAssertNotNil(object);

    if(![NSThread isMainThread] &&
        [object respondsToSelector:[anInvocation selector]]) {

        __block id blockObject = FLRetain(object);
        __block NSInvocation* theInvocation = FLRetain(anInvocation);

        NSUInteger argCount = theInvocation.methodSignature.numberOfArguments;

        for(int i = 2; i < argCount; i++) {
            id arg = nil;
            [theInvocation getArgument:&arg atIndex:i];
            FLRetain(arg);
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            [theInvocation invokeWithTarget:object];

            for(int i = 2; i < argCount; i++) {
                id arg = nil;
                [theInvocation getArgument:&arg atIndex:i + 2];
                FLRelease(arg);
            }

            FLReleaseWithNil(theInvocation);
            FLReleaseWithNil(blockObject);
        });
    }
    else {
        [super forwardInvocation:anInvocation];
    }
}

@end

@implementation NSObject (FLMainThreadObject)
- (id) onMainThread {
    return [FLMainThreadObject mainThreadObject:self];
}
@end
