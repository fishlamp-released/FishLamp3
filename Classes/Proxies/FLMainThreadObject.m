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
    
    __block id object = [self representedObject];
    FLAssertNotNil(object);
    
    if(![NSThread isMainThread] &&
        [object respondsToSelector:[anInvocation selector]]) {

        __block NSInvocation* theInvocation = FLRetain(anInvocation);
        [theInvocation retainArguments];

        FLRetainObject(object);
        dispatch_async(dispatch_get_main_queue(), ^{
            [theInvocation invokeWithTarget:object];
            FLReleaseWithNil(theInvocation);
            FLReleaseWithNil(object);
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
