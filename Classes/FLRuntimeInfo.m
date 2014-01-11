//
//  FLRuntimeInfo.m
//  FishLamp
//
//  Created by Mike Fullerton on 10/21/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton.. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLRuntimeInfo.h"
#import "FLObjcRuntime.h"
#import "FLSelectorPerforming.h"

@implementation FLSelectorInfo

@synthesize selector = _selector;
@synthesize object = _object;
@synthesize objectClass = _class;
@synthesize metaClass = _metaClass;
@synthesize target = _target;

- (void) setClass:(Class) aClass selector:(SEL) selector {
    if(class_isMetaClass(aClass)) {
        _metaClass = aClass;
        _class = objc_getClass(class_getName(aClass));
    }
    else {
        _metaClass = objc_getMetaClass(class_getName(aClass));
        _class = aClass;
    }
    _selector = selector;
}

#if FL_MRC
- (void) dealloc {
    [_selectorString release];
    [super dealloc];
}
#endif

- (void) setTarget {
    if([self objectRespondsToSelector]) {
        _target = _object;
        if(!_target) {
            _target = [NSNull null];
        }
        
    }
    else if([self classRespondsToSelector]) {
        _target = _class;
    }
    else {
        _target = nil;
    }
}

- (id) initWithClass:(Class) aClass selector:(SEL) selector {
    self = [super init];
    if(self) {
        [self setClass:aClass selector:selector];
        [self setTarget];
    }
    return self;
}

- (id) initWithObject:(id) object selector:(SEL) selector {
    self = [super init];
    if(self) {
        [self setClass:[object class] selector:selector];
        _object = object;
        [self setTarget];
    }
    
    return self;
}

+ (id) selectorInfoWithClass:(Class) aClass selector:(SEL) selector {
    return FLAutorelease([[FLSelectorInfo alloc] initWithClass:aClass selector:selector]);
}

+ (id) selectorInfoWithObject:(id) object selector:(SEL) selector {
    return FLAutorelease([[FLSelectorInfo alloc] initWithObject:object selector:selector]);
}

- (BOOL) targetRespondsToSelector {
    return _target ? [_target respondsToSelector:_selector] : NO;
}

- (BOOL) objectRespondsToSelector {
    return class_respondsToSelector(_class, _selector);
}

- (BOOL) classRespondsToSelector {
    return class_respondsToSelector(_metaClass, _selector);
//    [_metaClass respondsToSelector:_selector];
}

- (void) setTargetToClass {
    _target = _class;
}

- (void) setTargetToObject {
    _target = _object;
}

//- (BOOL) targetRespondsToSelector {
//
//    if(_object) {
//        [_object respondsToSelector:_selector];
//        return _object;
//    }
//    Class objectClass = self.objectClass;
//    if(objectClass && [objectClass respondsToSelector:_selector]) {
//        return objectClass;
//    }
//    return nil;
//}

- (uint32_t) argumentCount {
    return (uint32_t) FLArgumentCountForClassSelector([self objectClass], _selector);
}

+ (NSString*) prettyString:(id) target selector:(SEL) selector {
    FLSelectorInfo* info = [FLSelectorInfo selectorInfoWithObject:target selector:selector];
    return info.prettyString;
}


- (NSString*) prettyString {
    NSString* leadingChar = nil;
    if(_target == _class) {
        leadingChar = @"+";
    }
    else if(_target == _object) {
        leadingChar = @"-";
    }
    
    if(!leadingChar) {
        leadingChar = @"?";
    }
    
    NSString* targetString = nil;
    if(_target) {
        if(_target == [NSNull null]) {
            targetString = NSStringFromClass(_class);
            leadingChar = @"-";
        }
        else {
            targetString = NSStringFromClass(_target);
        }
    }
    else {
        targetString = @"(NULL)";
    }
    
    return [NSString stringWithFormat:@"%@[%@ %@]", leadingChar, targetString, self.stringFromSelector];
}

- (NSString*) description {
    return [NSString stringWithFormat:@"%@ %@", [super description], [self prettyString]];
}

- (NSString*) stringFromSelector {
    if(!_selectorString) {
        _selectorString = FLRetain(NSStringFromSelector(_selector));
    }
    return _selectorString;
}

@end


