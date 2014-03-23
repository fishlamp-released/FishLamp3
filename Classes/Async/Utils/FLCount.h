//
//  FLMutableCount.h
//  Pods
//
//  Created by Mike Fullerton on 2/2/14.
//
//

#import "FishLampCore.h"

@interface FLCount : NSObject<NSCopying, NSCoding> {
@private
    int64_t _count;
}

- (id) initWithCount:(int64_t) count;

@property (readonly, assign) int64_t count;

@end

@interface FLMutableCount : FLCount
@property (readwrite, assign) int64_t count;
@end

