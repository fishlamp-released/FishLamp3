//
//  FLStaticTestMethodRunner.m
//  FishLamp
//
//  Created by Mike Fullerton on 10/24/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLStaticTestMethodRunner.h"
#import "FLObjcRuntime.h"
#import "FLFinisher.h"

@interface FLStaticTestMethodRunner ()
@property (readwrite, strong) NSArray* list;
@end

@implementation FLStaticTestMethodRunner
@synthesize list = _list;

- (id) initWithSelectorInfoList:(NSArray*) list {
    self = [super init];
    if(self) {
        self.list = list;
    }
    return self;
}

+ (id) staticTestMethodRunner:(NSArray*) selectorInfoList {
    return FLAutorelease([[FLStaticTestMethodRunner alloc] init]);
}

- (BOOL) runTestWithFinisher:(FLSelectorInfo*) info {
    __block BOOL wasRun = NO;
    
    FLFinisher* listeners = [FLFinisher finisherWithBlock:^(FLPromisedResult result){
        wasRun = YES;
    }];
    
    FLPerformSelector1(info.target, info.selector, listeners);

    if(!wasRun) {
        NSLog(@"Test not run ([asyncTask setFinished] not called)");
    }

    return wasRun;
}

- (BOOL) runOneSelector:(FLSelectorInfo*) info {
    
    FLConfirmIsNotNil(info.target);
    FLConfirmIsNotNil(info.selector);
    
    int selectorArgCount = info.argumentCount;
    NSLog([info prettyString]);
    BOOL passed = NO;

    @try {
    
        switch(selectorArgCount) {
            
            case 2:
                FLPerformSelector0(info.target, info.selector);
                passed = YES;
                break;
            
            case 3:
                passed = [self runTestWithFinisher:info];
                break;
        
            default:
                NSLog(@"SKIPPING (expecting 0 or 1 arguments, got %d", selectorArgCount);
                passed = YES;
            break;
        }
            
    }
    @catch(NSException* ex) {
        NSLog(@"FAIL: %@", [ex description]);
        passed = NO;
    }

    if(passed) {
        NSLog(@"PASS!");
    }

    return passed;
}

- (BOOL) runBatchOfMethods:(NSArray*) methods
                haltOnFail:(BOOL) haltOnFail {
    
    BOOL passed = YES;
    for(FLSelectorInfo* info in methods) {
        if(![self runOneSelector:info]) {
            passed = NO;
            if(haltOnFail) {
                return NO;
            }
        }
    }
    
    return passed;
}

- (void) runAsynchronously:(id) asyncTask {
//    FLAssert([self runBatchOfMethods:_sanityChecks haltOnFail:YES]);
//    FLAssert([self runBatchOfMethods:_finishSanityChecks haltOnFail:YES]);
//    FLAssert([self runBatchOfMethods:_selfTests haltOnFail:NO]);
    [asyncTask setFinished];

}

#if FL_NO_ALLOC
- (void) dealloc {
    [_list release];
    [super dealloc];
}
#endif

@end
