//
//  FLAsyncTestCase.h
//  Pods
//
//  Created by Mike Fullerton on 2/8/14.
//
//

#import "FLTestCase.h"

//@class FLTestCaseAsyncTest;

#define FLTestCaseDefaultAsyncTimeout 2.0f

typedef void (^FLAsyncTestResultBlock)();

@interface FLAsyncTestCase : FLTestCase {
@private
//    FLTestCaseAsyncTest* _asyncTest;
}

#if 0
- (void) setFinishedWithError:(NSError*) error;
- (void) setFinished;

- (void) startAsyncTest;
- (void) startAsyncTestWithTimeout:(NSTimeInterval) timeout;

- (void) verifyAsyncResults:(dispatch_block_t) block;

- (void) finishAsyncTestWithBlock:(void (^)()) finishBlock;
- (void) finishAsyncTest;
- (void) finishAsyncTestWithError:(NSError*) error;

- (void) waitUntilAsyncTestIsFinished;
#endif

@end
