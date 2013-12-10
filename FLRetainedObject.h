//
//  FLRetainedObject.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 6/24/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLAbstractObjectProxy.h"

@interface FLRetainedObject : FLAbstractObjectProxy {
@private
    id _containedObject;
}

@property (readonly, strong) id containedObject;

- (id) initWithRetainedObject:(id) object;
+ (id) retainedObject:(id) object;

@end
