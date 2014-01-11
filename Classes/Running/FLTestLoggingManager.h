//
//  FLTestLoggingManager.h
//  FishLampCore
//
//  Created by Mike Fullerton on 8/28/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FishLampCore.h"
#import "FLStringFormatter.h"
#import "FLLogger.h"

@class FLTestCase;

/**
 *  Manages the loggers. A logger is just a destinations for strings.
 */
@interface FLTestLoggingManager: FLStringFormatter<FLStringFormatterDelegate> {
@private
    NSMutableArray* _loggers;
}

FLSingletonProperty(FLTestLoggingManager);

/**
 *  Add A logger a the end of the logger list. The first logger in the list gets the input.
 *  
 *  @param formatter a string formmater
 */
- (void) addLogger:(id<FLStringFormatter>) formatter;

/**
 *  Add a logger at the beginning of the logger list. The first logger in the list gets input.
 *  
 *  @param formatter a string formatter
 */
- (void) pushLogger:(id<FLStringFormatter>) formatter;

/**
 *  remove the first logger
 */
- (void) popLogger;


- (id<FLStringFormatter>) logger;

- (void) logger:(id<FLStringFormatter>) logger logInBlock:(dispatch_block_t) block;

- (void) appendTestCaseOutput:(FLTestCase*) testCase;

@end


