//
//  FLTestResultCollection.m
//  FishLampFrameworks
//
//  Created by Mike Fullerton on 9/1/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLTestResultCollection.h"
#import "FLTestable.h"
#import "FLAssertions.h"

@implementation FLTestResultCollection

@synthesize testResults = _results;

- (id) init {
    self = [super init];
    if(self) {
        _results = [[NSMutableDictionary alloc] init];
    }
    return self;
}

+ (id) testResultCollection {
    return FLAutorelease([[[self class] alloc] init]);
}

#if FL_MRC
- (void) dealloc {
    [_results release];
    [super dealloc];
}
#endif

//- (id) setTestResultForSelector:(SEL) selector {
//    return [self setTestResultForKey:NSStringFromSelector(selector)];
//}
//
//- (id) setTestResultForNumber:(int) number {
//    return [self setTestResultForKey:[NSNumber numberWithInt:number]];
//}
//
//- (id) setTestResultForKey:(id) key {
//    id test = [FLTestResult testResult];
//    [self setTestResult:test forKey:key];
//    return test;
//}

- (void) setTestResult:(FLTestResult*) result forKey:(id) key {

    FLConfirmIsNotNil(result);
    FLConfirmIsNotNil(key);

    @synchronized(self) {
    
        FLConfirmWithComment([_results objectForKey:key] == nil,
                        @"test results '%@' already in expected list",
                        key);

        [_results setObject:result forKey:key];
    }
}

- (BOOL) hasTestResultForKey:(id) key {
    return [_results objectForKey:key] != nil;
}

- (BOOL) hasTestResultForNumber:(int) number {
    return [_results objectForKey:[NSNumber numberWithInt:number]] != nil;
}

- (BOOL) hasTestResultForSelector:(SEL) selector {
    return [_results objectForKey:NSStringFromSelector(selector)] != nil;
}

- (id) testResultForSelector:(SEL) selector {
    return [self testResultForKey:NSStringFromSelector(selector)];
}

- (id) testResultForNumber:(int) number {
    return [self testResultForKey:[NSNumber numberWithInt:number]];
}

- (id) testResultForKey:(id) key {
    id result = [_results objectForKey:key];
    FLConfirmIsNotNilWithComment(result, @"can't find result for %@", [key description]);
    return result;
}

- (NSArray*) failedResults {
    NSMutableArray* failedCases = nil;

    for(id result in _results.objectEnumerator) {
        if(![result passed]) {
            if(!failedCases) {
                failedCases = [NSMutableArray array];
            }
            [failedCases addObject:result];
        }
    }

    return failedCases;
}

- (NSString*) description {
    return [NSString stringWithFormat:@"%@ %@", [super description], [_results description]];
}

//- (void) addTestResult:(FLTestResult*) result {
//    [_results addObject:result];
//}

//- (void) willThrowException:(NSException*) ex {
//    [self addTestResult:[FLTestResult testResult:FLTestException what:ex comment:[ex reason]]];
//    [[self class] willThrowException:ex fromObject:self];
//}


@end


@implementation FLExpectedTestResult
+ (id) expectedTestResult {
    return FLAutorelease([[[self class] alloc] init]);
}
@end
