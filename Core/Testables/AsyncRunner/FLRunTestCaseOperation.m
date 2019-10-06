//
//  FLRunTestCaseOperation.m
//  Pods
//
//  Created by Mike Fullerton on 2/8/14.
//
//

#if 0
#import "FLRunTestCaseOperation.h"

@implementation FLRunTestCaseOperation()
@property (readwrite, strong, nonatomic) FLTestCase* testCase;
@end

@implementation FLRunTestCaseOperation

@synthesize testCase = _testCase;

- (id) initWithTestCase:(FLTestCase*) testCase {
	self = [super init];
	if(self) {
		_testCase = FLRetain(testCase);
	}
	return self;
}

#if FL_MRC
- (void)dealloc {
	[_testCase release];
	[superdealloc];
}
#endif

+ (id) runTestCaseOperation:(FLTestCase*) testCase {
   return FLAutorelease([[[self class] alloc] initWithTestCase:testCase]);
}

- (void) didFinishWithResult:(id)result {

    if([result isError]) {
        [self.testCase.result setFailedWithError:result];
    }
    else {
        [self.testCase.result setPassed];
    }

    if(!self.isDisabled && [_willTestSelector willPerformOnTarget:_didTestSelector]) {
        [self performTestCaseSelector:_didTestSelector optional:self];
    }

    [super didFinishWithResult:self.result];
}

- (void) startOperation:(FLFinisher*) finisher {
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


@end
#endif