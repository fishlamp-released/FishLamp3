//
//  FLTestToolMain.m
//  FLCore
//
//  Created by Mike Fullerton on 11/20/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLTestToolMain.h"
#import "FLRunAllTestsOperation.h"
#import "FLAsyncQueue.h"
#import "FLOperation.h"
#import "FLTestable.h"
#import "NSBundle+FLVersion.h"
#import "FLDispatchQueue.h"
#import "FLTestLoggingManager.h"

#import "FishLampAsync.h"

int FLTestToolMain(int argc, const char *argv[], NSString* bundleIdentifier, NSString* appName, NSString* version) {
    @autoreleasepool {
        @try {


            [NSBundle setFakeBundleIdentifier:bundleIdentifier bundleName:appName appVersion:FLVersionFromString(version)];
        
            FLLogger* logger = [FLLogger logger];
            [logger addLoggerSink:[FLConsoleLogSink consoleLogSink:FLLogOutputSimple]];
            [[FLTestLoggingManager instance] addLogger:logger];

            FLTestableSetLogger(logger);

            id<FLOperationContext> testContext = [FLOperationContext operationContext];

            FLPromisedResult result = [testContext runSynchronously:[FLRunAllTestsOperation testRunner]];

            if([result isError]) {
                return 1;
            }

            return 0;
        }
        @catch(NSException* ex) {
            NSLog(@"uncaught exception: %@", [ex reason]);
            return 1;
        }
        
        return 0;
    }
}
