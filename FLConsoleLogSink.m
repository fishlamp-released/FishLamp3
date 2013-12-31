//
//  FLConsoleLogSink.m
//  FLCore
//
//  Created by Mike Fullerton on 11/1/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton.. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLConsoleLogSink.h"
#import "FLPrintf.h"
#import "NSString+FishLamp.h"
#import "FLLogEntry.h"
#import "FLStackTrace.h"
#import "FLWhitespace.h"
#import "NSError+FishLamp.h"

@implementation FLConsoleLogSink

- (id) init {	
	self = [super init];
	if(self) {
	}
	return self;
}

+ (id) consoleLogSink {
    return FLAutorelease([[[self class] alloc] init]);
}

+ (FLLogSink*) consoleLogSink:(FLLogSinkOutputFlags) outputFlags {
    return FLAutorelease([[[self class] alloc] initWithOutputFlags:outputFlags]);
}


- (void) indent:(FLIndentIntegrity*) integrity {
    [[FLPrintfStringFormatter instance] indent:integrity];
}

- (void) outdent:(FLIndentIntegrity*) integrity {
    [[FLPrintfStringFormatter instance] outdent:integrity];
}

- (void) logEntry:(FLLogEntry*) entry stopPropagating:(BOOL*) stop {

    FLPrintf(entry.logString);

    if(FLTestAnyBit(self.outputFlags, FLLogOutputWithLocation | FLLogOutputWithStackTrace)) { 
        [[FLPrintfStringFormatter instance] indentLinesInBlock:^{
            NSString* moreInfo = [entry.object moreDescriptionForLogging];
            if(moreInfo) {
                FLPrintf(moreInfo);
            }
            
            FLPrintf(@"%s:%d:",
                         entry.stackTrace.fileName,
                         entry.stackTrace.lineNumber);
        }];
    }

    if(FLTestBits(self.outputFlags, FLLogOutputWithStackTrace)) {

        [[FLPrintfStringFormatter instance] indentLinesInBlock:^{
            if(entry.stackTrace.callStack.depth) {
                for(int i = 0; i < entry.stackTrace.callStack.depth; i++) {
                    FLPrintf(@"%s", [entry.stackTrace stackEntryAtIndex:i]);
                }
            }
        }];
    }
}

@end
