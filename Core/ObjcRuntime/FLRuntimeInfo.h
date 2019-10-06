//
//  FLRuntimeInfo.h
//  FishLamp
//
//  Created by Mike Fullerton on 10/21/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton.. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampCore.h"

typedef struct {
    __unsafe_unretained Class class;
    SEL selector;
    unsigned int index;
    unsigned int total;
    unsigned int isMetaClass: 1;
} FLRuntimeInfo;

@interface FLSelectorInfo : NSObject {
@private
    __unsafe_unretained id _object;
    __unsafe_unretained id _target;
    __unsafe_unretained Class _class;
    __unsafe_unretained Class _metaClass;
    SEL _selector;
    NSString* _selectorString;
}
/**
    @brief the target is chooses the right target
    first it will try the object if non nil, but if that's nil or doesn't peformSelector, it will try the objectClass 
    running a selector on metaClass will always fail.
 */
@property (readonly, assign, nonatomic) id target;
// the only time I forsee this being needed is if there are identical selectors in class and object
// and you want to class's version
- (void) setTargetToClass;
- (void) setTargetToObject;

@property (readonly, assign, nonatomic) BOOL targetRespondsToSelector;
@property (readonly, assign, nonatomic) BOOL objectRespondsToSelector;
@property (readonly, assign, nonatomic) BOOL classRespondsToSelector;

@property (readonly, assign, nonatomic) SEL selector;

@property (readonly, assign, nonatomic) id object;
@property (readonly, assign, nonatomic) Class objectClass;
@property (readonly, assign, nonatomic) Class metaClass;

@property (readonly, assign, nonatomic) uint32_t argumentCount;

+ (id) selectorInfoWithClass:(Class) aClass selector:(SEL) selector;
+ (id) selectorInfoWithObject:(id) object selector:(SEL) selector;

- (id) initWithObject:(id) object selector:(SEL) selector;
- (id) initWithClass:(Class) aClass selector:(SEL) selector;

@property (readonly, assign, nonatomic) NSString* prettyString;
@property (readonly, assign, nonatomic) NSString* stringFromSelector;

+ (NSString*) prettyString:(id) target selector:(SEL) selector;
@end
