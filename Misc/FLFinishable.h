//
//  FLFinishable.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 9/1/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FishLampCore.h"
#import "FLPromisedResult.h"

@protocol FLFinishable <NSObject>

/*!
 *  Finish this operation with any result
 *  
 *  @param result the result (an NSError or anything is success).
 */
- (void) setFinishedWithResult:(id) result;

/*!
 *  Set result to a successful result and fufill promises. This calls setFinishedWithResult with the defualt success result.
 */
- (void) setFinished;

/*!
 *  Set finished with default failed result.
 */
- (void) setFinishedWithFailedResult;

/*!
 *  Set finished with cancel error.
 */
- (void) setFinishedWithCancel;

@end
