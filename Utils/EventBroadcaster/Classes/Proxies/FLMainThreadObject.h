//
//  FLMainThreadObject.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 6/24/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLRetainedObject.h"

@interface FLMainThreadObject : FLRetainedObject
+ (id) mainThreadObject:(id) object;
@end

@interface NSObject (FLMainThreadObject)
- (id) onMainThread;
@end