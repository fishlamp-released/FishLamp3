//
//  FLOperationUnitTest.m
//  FishLampFrameworks
//
//  Created by Mike Fullerton on 8/25/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLOperationTests.h"
#import "FLOperation.h"
#import "FLDispatchQueue.h"
#import "FLAsyncTestGroup.h"

@implementation FLOperation (Tests)

//- (void) assertNotRun {
//    FLAssertIsFalseWithComment(self.wasCancelled, nil);
//    FLAssertIsFalseWithComment(self.wasStarted, nil);
//    FLAssertIsFalseWithComment(self.isFinished, nil);
//    FLAssertIsFalseWithComment(self.didSucceed, nil);
//    FLAssertIsNilWithComment(self.error, nil);
//}
//
//- (void) assertRanOk {
//    FLAssertIsFalseWithComment(self.wasCancelled, nil);
//    FLAssertIsTrueWithComment(self.wasStarted, nil);
//    FLAssertIsTrueWithComment(self.isFinished, nil);
//    FLAssertIsTrueWithComment(self.didSucceed, nil);
//    FLAssertIsNilWithComment(self.error, nil);
//}
//
//- (void) assertNotInQueue {
////    FLAssertIsNilWithComment(self.operationQueue, nil);
//}
//
//- (void) assertInQueue {
////    FLAssertIsNotNilWithComment(self.operationQueue, nil);
//}
//
//- (void) assertWasCancelled {
//    FLAssertIsKindOfClassWithComment(self.error, NSError, nil);
//    FLAssertIsTrueWithComment(self.wasCancelled, nil);
//}

@end

@interface FLSimpleTestOperation : FLOperation {
@private
    BOOL _passed;
    id _testable;
}
@property (readonly, assign, nonatomic) BOOL passed;
@property (readwrite, strong, nonatomic) FLTestable* testable;
@end

@implementation FLSimpleTestOperation
@synthesize passed = _passed;
@synthesize testable = _testable;

- (FLPromisedResult) runSynchronously {

//    FLTestLog(self.testable, @"hello world");
    _passed = YES;

    return FLSuccessfulResult;
}

#if FL_MRC
- (void)dealloc {
	[_testable release];
	[super dealloc];
}
#endif

@end
@implementation FLOperationUnitTest

+ (Class) testGroupClass {
    return [FLAsyncTestGroup class];
}

- (void) testSimpleCase {
    FLSimpleTestOperation* op = FLAutorelease([[FLSimpleTestOperation alloc] init]);
    op.testable = self;

    FLThrowIfError([FLBackgroundQueue runSynchronously:op]);
    FLAssert(op.passed);
}

- (void) testInQueue {

//    FLOperationQueueOperation* q = [FLOperationQueueOperation operationQueue];
//    [q assertNotRun];
//    [q assertNotInQueue];
//
//    FLOperation* op = [FLOperation operation];
//    
//    
//    [op assertNotRun];
//    [op assertNotInQueue];
//
//    [q queueOperation:op];
//    [op assertNotRun];
//    [op assertInQueue];
//    
//    [q run];
//    
//    [op assertInQueue];
//    [op assertRanOk];
//    [q assertRanOk];
    
//    [op assertWasCancelled];
}
@end
