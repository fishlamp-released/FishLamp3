//
//  FLEnumSet.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 5/30/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLEnumSet.h"

@implementation FLEnumSet

- (id) init {	
	self = [super init];
	if(self) {
		_enumValues = [[NSMutableArray alloc] init];
	}
	return self;
}

+ (id) enumSet {
    return FLAutorelease([[[self class] alloc] init]);
}

#if FL_MRC
- (void) dealloc {
	[_enumValues release];
	[super dealloc];
}
#endif

- (NSUInteger) count {
    return [_enumValues count];
}

- (NSUInteger) enumForIndex:(NSUInteger) enumIndex {
    return [[_enumValues objectAtIndex:enumIndex] enumValue];
}

- (NSString*) stringForIndex:(NSUInteger) enumIndex{
    return [[_enumValues objectAtIndex:enumIndex] enumName];
}

- (FLEnumPair*) pairForIndex:(NSUInteger) enumIndex {
    return [_enumValues objectAtIndex:enumIndex];
}

- (BOOL) hasEnum:(NSUInteger) theEnum {
    for(FLEnumPair* pair in _enumValues) {
        if(pair.enumValue == theEnum) {
            return YES;
        }   
    }
    return NO;
}

- (BOOL) hasEnumString:(NSString*) theEnumName {
    theEnumName = [theEnumName lowercaseString];
    for(FLEnumPair* pair in _enumValues) {
        if(FLStringsAreEqual(theEnumName, pair.enumName)) {
            return YES;
        }   
    }
    
    return NO;
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id __unsafe_unretained [])buffer count:(NSUInteger)len {
    return [_enumValues countByEnumeratingWithState:state objects:buffer count:len];
}

- (void) addEnum:(NSInteger) theEnum withName:(NSString*) name {
    [_enumValues addObject:[FLEnumPair enumPair:name enumValue:theEnum]];
}

- (void) removeAllEnums {
    [_enumValues removeAllObjects];
}

@end