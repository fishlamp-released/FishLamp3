//
//  FLModelObject.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 4/21/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampMinimum.h"

@class FLObjectDescriber;
@class FLObjectChangeTracker;

@protocol FLModelObject <NSCopying, NSCoding>
- (void) startTrackingChanges;
- (void) setChangeTracker:(FLObjectChangeTracker*) changeTracker;
- (FLObjectChangeTracker*) changeTracker;
@end

@interface FLModelObject : NSObject<FLModelObject> {
@private
    FLObjectChangeTracker* _changeTracker;
}
@end

@interface NSObject (FLModelObject)
+ (BOOL) isModelObject;
- (BOOL) isModelObject;

- (FLObjectChangeTracker*) changeTracker;
@end

typedef enum {
	FLMergeModePreserveDestination,		//! always keep dest value, even if src has value.
	FLMergeModeSourceWins,				//! if src has value, overwrite dest value.
} FLMergeMode;

// this only works for objects with valid describers.
extern id FLModelObjectCopy(id object, Class classOrNil);
extern void FLModelObjectEncode(id object, NSCoder* aCoder);
extern void FLModelObjectDecode(id object, NSCoder* aCoder);

extern void FLMergeObjects(id dest, id src, FLMergeMode mergeMode);
extern void FLMergeObjectArrays(NSMutableArray* dest, NSArray* src, FLMergeMode mergeMode, NSArray* arrayItemTypes);

#define FLSynthesizeObjectDescriber() \
            + (BOOL) isModelObject { \
                return YES; \
            } \
            - (BOOL) isModelObject { \
                return YES; \
            }
                        
#define FLSynthesizeCoding() \
            - (id)initWithCoder:(NSCoder *)aCoder { \
                FLModelObjectDecode(self, aCoder); \
                return self; \
            } \
            - (void) encodeWithCoder:(NSCoder*) coder { \
                FLModelObjectEncode(self, coder); \
            }

#define FLSynthesizeCopying() \
            - (id) copyWithZone:(NSZone*) zone { \
                return FLModelObjectCopy(self, [self class]); \
            }        

#define FLSynthesizeChangeTracking() \
            - (void) startTrackingChanges { \
                self.changeTracker = [FLObjectChangeTracker objectChangeTracker:self]; \
            }

#define FLSynthesizeModelObjectMethods() \
            FLSynthesizeObjectDescriber() \
            FLSynthesizeCopying() \
            FLSynthesizeCoding() \
            FLSynthesizeChangeTracking()

