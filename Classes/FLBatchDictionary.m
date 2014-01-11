//
//  FLArrayDictionary.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 12/26/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLBatchDictionary.h"

#define kSelfDot        @"self."
#define kBracketSelf    @"[self "

NSString* _FLKeyForProperty(NSString* prop) {
    if([prop hasPrefix:kSelfDot]) {
        return [prop substringFromIndex:kSelfDot.length];
    }
    else if ([prop hasPrefix:kBracketSelf]) {
        int len = kBracketSelf.length;
        return [prop substringWithRange:NSMakeRange(len, prop.length - len - 1)];
    }

    return prop;
}

#define FLEncoderEncodeProperty(__ENCODER__, __PROP__) \
    [__ENCODER__ encodeObject:__PROP__ forKey:_FLKeyForProperty(@#__PROP__)]

#define FLDecoderDecodeProperty(__DECODER__, __PROP__) \
    self.__PROP__ = [__DECODER__ decodeObjectForKey:_FLKeyForProperty(@#__PROP__)]

@interface FLBatchDictionary ()
@property (readwrite, strong, nonatomic) NSMutableDictionary* sets;
@end

@implementation FLBatchDictionary

@synthesize sets = _sets;

- (id) initWithDictionary:(NSDictionary*) dictionary {
    self = [super init];
    if(self) {
        _sets = [dictionary mutableCopy];
    }
    return self;
}

- (id) init {
    self = [super init];
    if(self) {
        _sets = [[NSMutableDictionary alloc] init];
    }
    return self;
}

#if FL_MRC
- (void) dealloc {
    [_sets release];
    [super dealloc];
}
#endif

+ (id) batchDictionary {
    return FLAutorelease([[[self class] alloc] init]);
}

- (NSSet*) objectsForKey:(id) key {
    return [_sets objectForKey:key];
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id __unsafe_unretained [])buffer count:(NSUInteger)len {
    return [_sets countByEnumeratingWithState:state objects:buffer count:len];
}

- (id)copyWithZone:(NSZone *)zone {
    return [[[self class] alloc] initWithDictionary:_sets];
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return [[FLMutableBatchDictionary alloc] initWithDictionary:_sets];
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    FLEncoderEncodeProperty(aCoder, self.sets);
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if(self) {
        FLDecoderDecodeProperty(aDecoder, self.sets);
    }
    return self;
}

@end

@implementation FLMutableBatchDictionary
- (void) addObject:(id) object forKey:(id) key {
    NSMutableSet* set = [self.sets objectForKey:key];
    if(!set) {
        set = [NSMutableSet set];
        [self.sets setObject:set forKey:key];
    }
    
    [set addObject:object];
}

- (void) removeObject:(id) object forKey:(id) key {
    NSMutableSet* set = [self.sets objectForKey:key];
    [set removeObject:key];
}

- (void) removeObject:(id) object {
    for(NSMutableSet* set in [self.sets objectEnumerator]) {
        [set removeObject:object];
    }
}

- (void) removeAllObjectsForKey:(id) key {
    [self.sets removeObjectForKey:key];
}

- (void) removeAllObjects {
    [self.sets removeAllObjects];
}

@end

