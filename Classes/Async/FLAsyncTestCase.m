//
//  FLAsyncTestCase.m
//  Pods
//
//  Created by Mike Fullerton on 2/8/14.
//
//

#import "FLAsyncTestCase.h"

#import "FLTimer.h"
//#import "FLTestCaseAsyncTest.h"

@interface FLAsyncTestCase ()
//@property (readwrite, strong) FLTestCaseAsyncTest* asyncTest;
@end

@implementation FLAsyncTestCase

#if 0
@synthesize asyncTest = _asyncTest;


- (id) init {	
	self = [super init];
	if(self) {

	}
	return self;
}

#if FL_MRC
- (void)dealloc {
	[_asyncTest release];
	[super dealloc];
}
#endif

- (void) startAsyncTestWithTimeout:(NSTimeInterval) timeout {
    self.asyncTest =  [FLTestCaseAsyncTest testCaseAsyncTest:self timeout:timeout];
}

- (void) startAsyncTest {
    return [self startAsyncTestWithTimeout:FLAsyncTestDefaultTimeout];
}

- (void) verifyAsyncResults:(dispatch_block_t) block {
    [self.asyncTest verifyAsyncResults:block];
}

- (void) finishAsyncTestWithBlock:(void (^)()) finishBlock {
    return [self.asyncTest setFinishedWithBlock:finishBlock];
}

- (void) finishAsyncTest {
    [self.asyncTest setFinished];
}
- (void) finishAsyncTestWithError:(NSError*) error {
    [self.asyncTest setFinishedWithError:error];
}

- (void) waitUntilAsyncTestIsFinished {

}

- (void) setFinishedWithError:(NSError*) error {
    [self.result setFailedWithError:error];
}

- (void) setFinished {
    [self.result setPassed];
}

- (BOOL) isAsyncTest {
    return _asyncTest != nil;
}



- (void) performTest {
    @try {
        if(self.isDisabled) {
            [finisher setFinished];
        }

        [self.result setStarted];

        switch(_selector.argumentCount) {
            case 0:
                [_selector performWithTarget:_target];
            break;

            case 1:
                [_selector performWithTarget:_target withObject:self];
            break;

            default:
                [self setDisabledWithReason:[NSString stringWithFormat:@"[%@ %@] has too many paramaters (%ld).",
                    NSStringFromClass([_target class]),
                    _selector.selectorString,
                    (unsigned long) _selector.argumentCount]];
            break;
        }
    }
    @catch(NSException* ex) {
        if(!finisher.isFinished) {
            [finisher setFinishedWithResult:ex.error];
        }
    }
    @finally {
        if(self.asyncTest) {
            [self.asyncTest setTestCaseStarted];
        }
        else if (!finisher.isFinished) {
            [finisher setFinished];
        }
    }
}

- (void) didFinishWithResult:(id)result {

    if([result isError]) {
        [self.result setFailedWithError:result];
    }
    else {
        [self.result setPassed];
    }


    [super didFinishWithResult:self.result];
}
#endif


@end
