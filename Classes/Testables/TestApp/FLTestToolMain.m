//
//  FLTestToolMain.m
//  FLCore
//
//  Created by Mike Fullerton on 11/20/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLTestToolMain.h"
#import "NSBundle+FLVersion.h"


#import "FLConsoleLogSink.h"

#import "FLTestOrganizer.h"

int FLTestToolMain(int argc, const char *argv[], NSString* bundleIdentifier, NSString* appName, NSString* version) {
    @autoreleasepool {
        @try {


            [NSBundle setFakeBundleIdentifier:bundleIdentifier bundleName:appName appVersion:FLVersionFromString(version)];

            FLLogSinkBehavior* behavior = [FLLogSinkBehavior logSinkBehavior];

            FLLogger* logger = [FLLogger logger];
            [logger addLoggerSink:[FLConsoleLogSink consoleLogSink:behavior]];


            FLTestOrganizer* organizer = [FLTestOrganizer testOrganizer];
            [organizer.logger addLogger:logger];

            FLSortedTestGroupList* tests = [organizer organizeTests];
            [organizer runTests:tests];

//            if([result isError]) {
//                return 1;
//            }

            return 0;
        }
        @catch(NSException* ex) {
            NSLog(@"uncaught exception: %@", [ex reason]);
            return 1;
        }
        
        return 0;
    }
}
