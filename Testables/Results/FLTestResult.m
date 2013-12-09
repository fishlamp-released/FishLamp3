//
//  FLTestResult.m
//  FishLamp
//
//  Created by Mike Fullerton on 10/18/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLTestResult.h"
#import "FLStringFormatter.h"
#import "FLPrettyString.h"
#import "FLAssertions.h"
#import "FLTestResultLogEntry.h"

@interface FLTestResult ()
@property (readwrite, copy) NSError* error;
@property (readwrite, copy) NSException* exception;
@end

@implementation FLTestResult
@synthesize error = _error;
@synthesize testName = _testName;
@synthesize passed = _passed;
@synthesize exception = _exception;
@synthesize started = _started;
@synthesize finished = _finished;
@synthesize logEntries = _logEntries;

- (id) initWithTestName:(NSString*) name {

    FLAssertStringIsNotEmpty(name);

	self = [super init];
	if(self) {
        _testName = FLRetain(name);
        _logEntries = [[NSMutableArray alloc] init];
	}
	return self;
}

- (id) init {	
    return [self initWithTestName:nil];
}

+ (id) testResult:(NSString*) name {
    return FLAutorelease([[[self class] alloc] initWithTestName:name]);
}


#if FL_MRC
- (void) dealloc {
    [_logEntries release];
    [_testName release];
    [_error release];
    [_exception release];
    [super dealloc];
}
#endif

- (void) setStarted {
    FLAssert(!_started);
    _started = YES;
}

- (void) setFinished {
    FLAssert(!_finished);
    _finished = YES;
}

- (void) setPassed {
    FLAssert(!_passed);
    _passed = YES;
}

- (void) setFailedWithError:(NSError*) error {
    self.error = error;
    _passed = NO;

    [self appendLogEntry:[FLTestResultLogEntry testResultLogEntry:[error localizedDescription]
                                                       stackTrace:[error stackTrace]]];

}

- (void) setFailedWithException:(NSException*) ex {
    [self setFailedWithError:ex.error];
}

- (void) appendLogEntry:(id<FLStringFormatting>) logEntry {
    if(!_logEntries) {
        _logEntries = [[NSMutableArray alloc] init];
    }

    [_logEntries addObject:logEntry];
}


//- (NSString*) description {
//    return [NSString stringWithFormat:@"%@ { testName: %@, passed: %@, error: %@ }", [super description], self.testName, self.passed ? @"YES" : [NSString stringWithFormat:@"NO (%d of %d)", (int)_count, (int)_expectedCount], 
//            [_error description]];
//}


@end

@interface FLCountedTestResult ()
@property (readwrite, assign) NSUInteger expectedCount;
@property (readwrite, assign) NSUInteger count;
@end

@implementation FLCountedTestResult
@synthesize count =_count;
@synthesize expectedCount = _expectedCount;

- (id) initWithTestName:(NSString*) testName expectedCount:(NSUInteger) count {
    self = [super initWithTestName:testName];
    if(self) {
        _expectedCount = count;
    }
    return self;
}

//- (NSString*) description {
//    return [NSString stringWithFormat:@"%@ { testName: %@, passed: %@, error: %@ }", [super description], self.testName, self.passed ? @"YES" : [NSString stringWithFormat:@"NO (%d of %d)", (int)_count, (int)_expectedCount], 
//            [_error description]];
//}


- (void) increment {
    self.count++;
}

- (BOOL) passed {
    return [super passed] && self.count == self.expectedCount;
}

+ (id) countedTestResult:(NSString*) testName expectedCount:(NSUInteger) expectedCount {
    return FLAutorelease([[[self class] alloc] initWithTestName:testName expectedCount:expectedCount]);
}

@end
