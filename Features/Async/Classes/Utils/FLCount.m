//
//  FLMutableCount.m
//  Pods
//
//  Created by Mike Fullerton on 2/2/14.
//
//

#import "FLCount.h"

@interface FLCount ()
@property (readwrite, assign) int64_t count;
@end

@implementation FLCount


@synthesize count =_count;

- (id) initWithCount:(int64_t) count {
	self = [super init];
	if(self) {
		_count = count;
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeInt64:self.count forKey:@"count"];
}
- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super init];
	if(self) {
        self.count = [aDecoder decodeInt64ForKey:@"count"];
	}
	return self;
}

- (id)copyWithZone:(NSZone *)zone {
    return [[[self class] alloc] initWithCount:self.count];
}


@end

@implementation FLMutableCount
@dynamic count;
@end
