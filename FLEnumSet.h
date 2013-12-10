//
//  FLEnumSet.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 5/30/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampCore.h"
#import "FLEnumPair.h"

@interface FLEnumSet : NSObject<NSFastEnumeration> {
@private
    NSMutableArray* _enumValues;
}

+ (id) enumSet;

@property (readonly, assign, nonatomic) NSUInteger count;

- (NSUInteger) enumForIndex:(NSUInteger) enumIndex;
- (NSString*) stringForIndex:(NSUInteger) enumIndex;
- (FLEnumPair*) pairForIndex:(NSUInteger) enumIndex;

- (void) addEnum:(NSInteger) theEnum withName:(NSString*) name;

- (BOOL) hasEnum:(NSUInteger) theEnum;
- (BOOL) hasEnumString:(NSString*) theEnumName;

- (void) removeAllEnums;

@end
