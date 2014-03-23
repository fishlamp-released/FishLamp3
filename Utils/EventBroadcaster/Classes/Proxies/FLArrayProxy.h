//
//  FLArrayProxy.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 7/13/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLAbstractObjectProxy.h"

@interface FLAbstractArrayProxy : NSProxy
- (NSArray*) array;
@end

/**
    @brief any message sent to this object is forward to the contained objects in the array.
 */
@interface FLArrayProxy : FLAbstractArrayProxy {
@private
    NSArray* _array;
}
- (id) initWithArray:(NSArray*) array;
+ (id) arrayProxy:(NSArray*) array;
@end
