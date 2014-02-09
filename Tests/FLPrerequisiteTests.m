//
//  FLPrerequisiteTests.m
//  FishLampCore
//
//  Created by Mike Fullerton on 11/7/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLPrerequisiteTests.h"

#import "FLPrerequisite.h"


@protocol FLBlarg <NSObject>
- (void) blarg;
@end


@interface FLBlargObject : NSObject<FLBlarg> {
@private
    BOOL _didBlarg;
}
+ (id) blargObject;
@end

@implementation FLBlargObject
- (void) blarg {
    _didBlarg = YES;;
}

+ (id) blargObject {
    return FLAutorelease([[[self class] alloc] init]);
}
@end




@implementation FLPrerequisiteTests

- (void) testProtocolPrerequisite {
    FLProtocolPrerequisite* pre = [FLProtocolPrerequisite protocolPrerequisite:@protocol(FLBlarg)];
    FLConfirmNotNil(pre);

    FLConfirm([pre objectMeetsCondition:self] == NO);

    FLBlargObject* b = [FLBlargObject blargObject];
    FLConfirm([pre objectMeetsCondition:b]);
}

@end
