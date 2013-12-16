//
//  NSObject+FLPerformSelector.h
//  FishLampCore
//
//  Created by Mike Fullerton on 4/28/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampObjc.h"

@protocol FLPerformer <NSObject>
@optional

// in addition to sdk versions
- (void) performSelector_fl:(SEL) selector
              withObject:(id) object1
              withObject:(id) object2 
              withObject:(id) object3;

- (void) performSelector_fl:(SEL) selector
              withObject:(id) object1
              withObject:(id) object2
              withObject:(id) object3 
              withObject:(id) object4;

// send in 100 if you want. see if I care.
- (void) performSelector_fl:(SEL) selector
           withArguments:(id __strong *) objects
         argumumentCount:(NSUInteger) argCount;

    
// these return an object
                        
- (void) performSelector_fl:(SEL) selector
               outObject:(id*) outObject;

- (void) performSelector_fl:(SEL) selector
              withObject:(id) object
               outObject:(id*) outObject;


// The difference between these and performSelector:
// if the object upon whom "performOptionalSelector" is called does NOT respond to the selector
// NOTHING happens, performSelector will throw an exception.
// this is appropriate for delegates with optional methods.

- (BOOL) performOptionalSelector_fl:(SEL) selector;

- (BOOL) performOptionalSelector_fl:(SEL) selector
             withObject:(id) object;

- (BOOL) performOptionalSelector_fl:(SEL) selector
               withObject:(id) object1
               withObject:(id) object2;

- (BOOL) performOptionalSelector_fl:(SEL) selector
               withObject:(id) object1
               withObject:(id) object2
               withObject:(id) object3;

- (BOOL) performOptionalSelector_fl:(SEL) selector
                 withObject:(id) object1 
                 withObject:(id) object2 
                 withObject:(id) object3
                 withObject:(id) object4;
                 
@end

@interface NSObject (FLPerformSelector)

- (void) performSelector_fl:(SEL) selector
              withObject:(id) object1
              withObject:(id) object2 
              withObject:(id) object3;

- (void) performSelector_fl:(SEL) selector
              withObject:(id) object1
              withObject:(id) object2
              withObject:(id) object3 
              withObject:(id) object4;

// send in 100 if you want. see if I care.
- (void) performSelector_fl:(SEL) selector
           withArguments:(id __strong *) objects
         argumumentCount:(NSUInteger) argCount;

    
// these return an object
                        
- (void) performSelector_fl:(SEL) selector
               outObject:(id*) outObject;

- (void) performSelector_fl:(SEL) selector
              withObject:(id) object
               outObject:(id*) outObject;


// The difference between these and performSelector:
// if the object upon whom "performOptionalSelector" is called does NOT respond to the selector
// NOTHING happens, performSelector will throw an exception.
// this is appropriate for delegates with optional methods.

- (BOOL) performOptionalSelector_fl:(SEL) selector;

- (BOOL) performOptionalSelector_fl:(SEL) selector
             withObject:(id) object;

- (BOOL) performOptionalSelector_fl:(SEL) selector
               withObject:(id) object1
               withObject:(id) object2;

- (BOOL) performOptionalSelector_fl:(SEL) selector
               withObject:(id) object1
               withObject:(id) object2
               withObject:(id) object3;

- (BOOL) performOptionalSelector_fl:(SEL) selector
                 withObject:(id) object1 
                 withObject:(id) object2 
                 withObject:(id) object3
                 withObject:(id) object4;

@end

