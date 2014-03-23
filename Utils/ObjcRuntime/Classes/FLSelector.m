//
//  FLSelector.m
//  FishLampCore
//
//  Created by Mike Fullerton on 3/13/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLSelector.h"
#import "FLObjcRuntime.h"
#import "FishLampCore.h"

@interface FLSelector ()
@property (readwrite, strong, nonatomic) NSString* selectorName;
@property (readwrite, strong, nonatomic) NSString* selectorString;
@end

@implementation FLSelector 

@synthesize selectorString = _selectorString;
@synthesize selectorName = _selectorName;
@synthesize selector = _selector;

- (id) init {
    return [self initWithSelector:nil];
}

- (id) initWithSelector:(SEL) selector {

    self = [super init];
    if(self) {
        _selector = selector;
        _argumentCount = ULONG_MAX;
    }
    return self;
}

- (id) initWithString:(NSString*) string {
    self = [self initWithSelector:NSSelectorFromString(string)];
    if(self) {
        _selectorString = FLRetain(string);
    }

    return self;
}

+ (id) selector:(SEL) selector {
    return FLAutorelease([[[self class] alloc] initWithSelector:selector]);
}

+ (id) selectorWithString:(NSString*) string {
    return FLAutorelease([[[self class] alloc] initWithString:string]);
}

#if FL_MRC
- (void) dealloc {
    [_selectorString release];
    [super dealloc];
}
#endif

- (NSString*) selectorName {

    if(!_selectorName) {

        if(self.argumentCount == 0) {
            self.selectorName = [self selectorString];
        }
        else {
            NSString* string = [self selectorString];
            for(int i = 0; i < string.length; i++) {
                if([string characterAtIndex:i] == ':') {
                    self.selectorName = [string substringToIndex:i];
                }
            }
        }
    }

    return _selectorName;
}

- (NSString*) selectorString {
    if(!_selectorString) {
        self.selectorString = NSStringFromSelector(_selector);
    }
    return _selectorString;
}

- (NSUInteger) argumentCount {
    if(_argumentCount == ULONG_MAX) {
        _argumentCount = FLArgumentCountForSelector(_selector);
    }
    return _argumentCount;
}

- (id) copyWithZone:(NSZone *)zone {
    return FLRetain(self);
}

- (BOOL) isEqualToSelector:(SEL) selector {
    return FLSelectorsAreEqual(selector, _selector);
}

- (BOOL) isEqual:(id)object {
    return [self.selectorString isEqualToString:[object selectorString]];
}

- (NSUInteger)hash {
    return (NSUInteger) [self.selectorString hash];
}

- (NSString*) description {
    return self.selectorString;
}

- (BOOL) willPerformOnTarget:(id) target {
    return [target respondsToSelector:_selector];
}

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Warc-performSelector-leaks"

- (void) performWithTarget:(id) target {
    FLAssert(self.argumentCount == 0);
    [target performSelector:_selector];
}

- (void) performWithTarget:(id) target
                withObject:(id) object {
    FLAssert(self.argumentCount == 1);
    [target performSelector:_selector withObject:object];
}

- (void) performWithTarget:(id) target
                withObject:(id) object1
                withObject:(id) object2 {
    FLAssert(self.argumentCount == 2);
    [target performSelector:_selector withObject:object1 withObject:object2];
}

- (void) performWithTarget:(id) target
                withObject:(id) object1
                withObject:(id) object2
                withObject:(id) object3 {
    FLAssert(self.argumentCount == 3);
    [target performSelector_fl:_selector withObject:object1 withObject:object2 withObject:object3];
}

- (void) performWithTarget:(id) target
                withObject:(id) object1
                withObject:(id) object2
                withObject:(id) object3
                withObject:(id) object4 {
    FLAssert(self.argumentCount == 4);
    [target performSelector_fl:_selector withObject:object1 withObject:object2 withObject:object3 withObject:object4];
}

#pragma GCC diagnostic pop

@end
