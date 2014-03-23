//
//  FLCoreTestGroup.m
//  FishLampCore
//
//  Created by Mike Fullerton on 11/2/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLCoreTestGroup.h"

@implementation FLCoreTestGroup
+ (void) specifyRunOrder:(id<FLTestableRunOrder>)runOrder {
    [runOrder orderClassFirst:[self class]];
}

@end
