//
//  FLSelector.h
//  FishLampCore
//
//  Created by Mike Fullerton on 3/13/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampObjc.h"

@interface FLSelector : NSObject<NSCopying> {
@private
    SEL _selector;
    NSUInteger _argumentCount;
    NSString* _selectorString;
    NSString* _selectorName;
}

@property (readonly, assign, nonatomic) SEL selector;
@property (readonly, assign, nonatomic) NSUInteger argumentCount;
@property (readonly, strong, nonatomic) NSString* selectorString;
@property (readonly, strong, nonatomic) NSString* selectorName;

- (id) initWithString:(NSString*) string;
- (id) initWithSelector:(SEL) selector;

+ (id) selector:(SEL) selector;
+ (id) selectorWithString:(NSString*) string;

- (BOOL) isEqualToSelector:(SEL) selector;

- (void) performWithTarget:(id) target;

- (void) performWithTarget:(id) target
                withObject:(id) object;

- (void) performWithTarget:(id) target
                withObject:(id) object1
                withObject:(id) object2;

- (void) performWithTarget:(id) target
                withObject:(id) object1
                withObject:(id) object2
                withObject:(id) object3;

- (void) performWithTarget:(id) target
                withObject:(id) object1
                withObject:(id) object2
                withObject:(id) object3
                withObject:(id) object4;

- (BOOL) willPerformOnTarget:(id) target;

@end