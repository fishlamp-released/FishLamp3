//
//  FLPromise.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 4/27/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//
#import "FishLampCore.h"
#import "FLAsyncBlockTypes.h"
#import "FLPromisedResult.h"

/**
 *  Represents the current state of a promise
 */
typedef NS_ENUM(NSInteger, FLPromiseState) {
/**
 *  The promise is not complete, so it doesn't have a valid result
 */
    FLPromiseStateUnfufilled,
/**
 *  The promise has been fufilled and has a successful result
 */
    FLPromiseStateResolved,
/**
 *  The promise has been fufilled and has an error result
 */
    FLPromiseStateRejected
};

/**
 *  Represents in progress asynchronous state.
 */
@interface FLPromise : NSObject {
@private
    dispatch_semaphore_t _semaphore;
    FLPromisedResult _result;
    fl_completion_block_t _completion;
    FLPromise* _nextPromise;
    __unsafe_unretained id _target;
    SEL _action;
    BOOL _isFinished;
}

/**
 *  Result of finished promised. This is nil if promise unfufilled.
 */
@property (readonly, strong) FLPromisedResult result;

/**
 *  returns YES if promis has been been fufilled (or was rejected)
 */
@property (readonly, assign) BOOL isFinished;

/**
 *  returns current state of promise
 */
@property (readonly, assign) FLPromiseState state;

/**
 *  init a promise with a completion block that will be called when the promise is fufilled
 *  
 *  @param completion block taking FLPromisedResult as parameter
 *  
 *  @return the promise
 */
- (id) initWithCompletion:(fl_completion_block_t) completion;


/**
 *  init a promise with a target and action
 *  
 *  @param target the target to invoke action selector on
 *  @param action the selector to call with FLPromisedResult as parameter - @selector(didComplete:)
 *  
 *  @return the promise
 */
- (id) initWithTarget:(id) target action:(SEL) action; // @selector(FLPromisedResult result)

/**
 *  init a promise without a callback or target
 *  
 *  @return the promise
 */
+ (id) promise;

/**
 *  create a promise with a completion block
 *  
 *  @param completion blocks take a FLPromisedResult as a parameter
 *  
 *  @return the promise
 */
+ (id) promise:(fl_completion_block_t) completion;

/**
 *  crate a promise with a target and action
 *  
 *  @param target the target
 *  @param action the action selector
 *  
 *  @return the promise
 */
+ (id) promise:(id) target action:(SEL) action;

/**
 *  block in current thread until the promise is fufilled
 *  
 *  @return the promised results
 */
- (FLPromisedResult) waitUntilFinished;

/**
 *  Add a another promise to this promise that will be fufilled when this promise is fufilled
 *  
 *  @param promise the promise to add
 */
- (void) addPromise:(FLPromise*) promise;

/**
 *  Add an empty promise to this promise
 *  
 *  @return the new promise added
 */
- (FLPromise*) addPromise;

/**
 *  Add a promise with a completion block
 *  
 *  @param completion the completion block
 *  
 *  @return the promise just added
 */
- (FLPromise*) addPromiseWithBlock:(fl_completion_block_t) completion;

/**
 *  Add a promise with a target and action
 *  
 *  @param target the target
 *  @param action the action selector
 *  
 *  @return the promise just added
 */
- (FLPromise*) addPromiseWithTarget:(id) target action:(SEL) action;

@end

// TODO:
// 2. add ability to chain promises after "begin" is called
