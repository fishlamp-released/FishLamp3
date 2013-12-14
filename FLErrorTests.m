//
//  FLErrorTests.m
//  FishLamp
//
//  Created by Mike Fullerton on 9/3/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLErrorTests.h"
#import "NSError+FLExtras.h"
#import "FishLampMinimum.h"

@class FLDeleteNotifier;

@implementation NSObject (FLDeleteNotifier)
FLSynthesizeAssociatedProperty(FLAssociationPolicyRetainNonatomic, deleteNotifier_fl, setDeleteNotifier_fl, FLDeleteNotifier*);
@end

@interface FLDeleteNotifier : NSObject {
@private
    dispatch_block_t _block;
}

+ (id) deleteNotifier:(dispatch_block_t) notifier;

@end

@implementation FLDeleteNotifier

- (id) initWithNotifierBlock:(dispatch_block_t) notifier {
	self = [super init];
	if(self) {
		_block = [notifier copy];
	}
	return self;
}

+ (id) deleteNotifier:(dispatch_block_t) notifier {
    return FLAutorelease([[[self class] alloc] initWithNotifierBlock:notifier]);
}

- (void)dealloc {

    if(_block) {
        _block();

#if FL_MRC
        [_block release];
#endif
    }

#if FL_MRC
	[super dealloc];
#endif
}

@end



@implementation FLErrorTests

- (void) testCancelError {
    NSError* error  = [NSError cancelError];
    FLAssert(error.isCancelError);
}

- (void) testThrowError:(FLTestCase*) testCase {

    [testCase startAsyncTest];

    @autoreleasepool {
        NSError* error  = [NSError cancelError];
        NSError* caughtError = nil;

        @try {
            FLThrowIfError(error);
        }
        @catch(NSException* ex) {
            caughtError = FLRetainWithAutorelease(ex.error);
            caughtError.deleteNotifier_fl = [FLDeleteNotifier deleteNotifier:^{

                [testCase finishAsyncTest];
            }];
        }

        FLConfirmNotNil(caughtError);
        FLConfirm([error.domain isEqualToString:caughtError.domain]);
        FLConfirm(error.code == caughtError.code);
        FLConfirm(caughtError.stackTrace != nil);
    }
}

- (void) testErrorException {

    NSError* error  = [NSError cancelError];

    NSException* ex = [NSException exceptionWithError:error];

    FLConfirm([ex.error isEqualToError:error]);

}


@end
