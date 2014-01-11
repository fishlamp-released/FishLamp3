//
//  FLObjectChangeTracker.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 6/23/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FishLampCore.h"

@class FLKeyValuePair;

@interface FLObjectChangeTracker : NSObject<NSFastEnumeration> {
@private
    NSMutableArray* _changes;
    BOOL _dirty;
    BOOL _disabled;
    __unsafe_unretained id _modelObject;
}

- (id) initWithModelObject:(id) modelObject;
+ (id) objectChangeTracker:(id) modelObject;

@property (readwrite, assign, nonatomic) id modelObject;
@property (readwrite, assign, nonatomic, getter=isDisabled) BOOL disabled;

@property (readonly, strong, nonatomic) NSArray* changes;
@property (readonly, assign, nonatomic, getter=isDirty) BOOL dirty;

- (void) clearChanges;

- (void) addChange:(FLKeyValuePair*) change;

- (BOOL) isPropertyDirty:(NSString*) propertyName;


@end
