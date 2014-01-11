//
//  FLTestGroup.m
//  FishLampCore
//
//  Created by Mike Fullerton on 11/2/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLTestGroup.h"

@implementation FLTestGroup

+ (void) specifyRunOrder:(id<FLTestableRunOrder>) runOrder {

}

+ (NSString*) testGroupName {
    return NSStringFromClass([self class]);
}

@end
