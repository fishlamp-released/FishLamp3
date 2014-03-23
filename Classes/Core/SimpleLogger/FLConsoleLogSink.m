//
//  FLConsoleLogSink.m
//  FLCore
//
//  Created by Mike Fullerton on 11/1/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton.. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLConsoleLogSink.h"
#import "printf_fl.h"
#import "NSString+FishLamp.h"
#import "FLLogEntry.h"
#import "FLStackTrace.h"
#import "FLWhitespace.h"

@implementation FLConsoleLogSink

+ (id) consoleLogSink {
    return FLAutorelease([[[self class] alloc] init]);
}

+ (FLLogSink*) consoleLogSink:(FLLogSinkBehavior*) outputFlags {
    return FLAutorelease([[[self class] alloc] initWithBehavior:outputFlags]);
}

- (void) indent:(FLIndentIntegrity*) integrity {
    [[FLPrintfStringFormatter instance] indent:integrity];
}

- (void) outdent:(FLIndentIntegrity*) integrity {
    [[FLPrintfStringFormatter instance] outdent:integrity];
}

- (void) logEntry:(FLLogEntry*) entry stopPropagating:(BOOL*) stop {

    printf_fl(@"%@", entry.logString);

    if(self.behavior.outputLocation || self.behavior.outputStackTrace) {

        [[FLPrintfStringFormatter instance] indentLinesInBlock:^{
            NSString* moreInfo = [entry.object moreDescriptionForLogging];
            if(moreInfo) {
                printf_fl(@"%@", moreInfo);
            }
            
            printf_fl(@"%@:%d: %@",
                         entry.stackTrace.fileName,
                         entry.stackTrace.lineNumber,
                         entry.stackTrace.function);
        }];
    }

    if(self.behavior.outputStackTrace) {

        [[FLPrintfStringFormatter instance] indentLinesInBlock:^{
            if(entry.stackTrace.callStack.depth) {
                for(int i = 0; i < entry.stackTrace.callStack.depth; i++) {
                    printf_fl(@"%s", [entry.stackTrace stackEntryAtIndex:i]);
                }
            }
        }];
    }
}

@end
