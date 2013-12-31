//
//  FLPrerequisite.h
//  FishLampCore
//
//  Created by Mike Fullerton on 11/6/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FishLampCore.h"

@protocol FLPrerequisite <NSObject>
- (BOOL) objectMeetsCondition:(id) object;
@end

@interface FLProtocolPrerequisite : NSObject<FLPrerequisite> {
@private
    Protocol* _protocol;
}

+ (id) protocolPrerequisite:(Protocol*) protocol;

@end
