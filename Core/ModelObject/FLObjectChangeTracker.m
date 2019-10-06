//
//  FLObjectChangeTracker.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 6/23/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLObjectChangeTracker.h"
#import "FLObjectDescriber.h"
#import "FLPropertyDescriber.h"
#import "FLKeyValuePair.h"
#import "FLModelObject.h"

@interface FLObjectChangeTracker ()
@property (readwrite, strong, nonatomic) NSArray* changes;
@end

@implementation FLObjectChangeTracker

@synthesize changes= _changes;
@synthesize dirty =_dirty;
@synthesize disabled = _disabled;
@synthesize modelObject = _modelObject;

- (id) initWithModelObject:(id) object {

    self = [super init];
	if(self) {
        FLAssertNotNil(object);
        FLAssert([object isModelObject]);

        if(![object isModelObject]) {
            return nil;
        }

        self.modelObject = object;
    }
	return self;
}

+ (id) objectChangeTracker:(id) object {
    return FLAutorelease([[[self class] alloc] initWithModelObject:object]);
}

- (void) setModelObject:(id) object {
    if(_modelObject) {
        NSDictionary* properties = [[_modelObject objectDescriber] properties];
        for(NSString* prop in properties) {
            [object removeObserver:self forKeyPath:prop];
        }
    }
    self.changes = nil;
    _modelObject = object;

    if(_modelObject) {

        FLAssert([_modelObject isModelObject]);

        NSDictionary* properties = [[_modelObject objectDescriber] properties];
        for(NSString* prop in properties) {
            [object addObserver:self forKeyPath:prop options:
                NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        }
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
                       
    if(!self.isDisabled) {
        [self addChange:[FLKeyValuePair keyValuePair:keyPath value:[change objectForKey:NSKeyValueChangeOldKey]]];
    }
}

- (void) clearChanges {
    [_changes removeAllObjects];
}

- (void) addChange:(FLKeyValuePair*) change {
    if(!_changes) {
        _changes = [[NSMutableArray alloc] init];
    }

    [_changes addObject:change];
}

- (BOOL) isDirty {
    return _changes.count > 0;
}

- (BOOL) isPropertyDirty:(NSString*) propertyName {
    for(FLKeyValuePair* pair in [_changes objectEnumerator]) {
        if(FLStringsAreEqual(pair.key, propertyName)) {
            return YES;
        }
    }

    return NO;
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state
                                  objects:(id __unsafe_unretained [])buffer
                                  count:(NSUInteger)len {

    return [_changes countByEnumeratingWithState:state objects:buffer count:len];

}




@end
