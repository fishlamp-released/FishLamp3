//
//  FLAsyncTestGroup.m
//  FishLampCore
//
//  Created by Mike Fullerton on 11/2/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLAsyncTestGroup.h"

#import "FLCoreTestGroup.h"

@implementation FLAsyncTestGroup

+ (void) specifyRunOrder:(id<FLTestableRunOrder>)runOrder {
    [runOrder orderClass:[self class] afterClass:[FLCoreTestGroup class]];
}
@end
