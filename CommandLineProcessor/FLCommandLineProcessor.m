//
//  FLCommandLineProcessor.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 3/27/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLCommandLineProcessor.h"
#import "FLStringUtils.h"
#import "FLErrorDomainInfo.h"
#import "NSString+Lists.h"
#import "FLUsageToolTask.h"
#import "FLHelpToolTask.h"

@interface FLToolCommand ()
- (void) setParent:(id) parent;
@end


@interface FLCommandLineProcessor ()
@end

@implementation FLCommandLineProcessor

@synthesize commands = _commands;
@synthesize output = _output;

- (id) init {
    self = [super init];
    if(self) {
        _commands = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

#if FL_MRC
- (void) dealloc {
    [_output release];
    [_commands release];
    [super dealloc];
}
#endif

- (void) addToolCommand:(FLToolCommand*) command {
    command.parent = self;
    [_commands setObject:command forKey:[command.commandName lowercaseString]];
}

- (void) willParseInput {
}

- (void) didParseInput {
}

- (FLCommandLineTask*) taskFromInput:(NSString*) input {

    input = [input trimmedString_fl];

    @try {
        [self willParseInput];
    
        FLCommandLineTask* task = [FLCommandLineTask commandLineTask];
        
        if(FLStringIsEmpty(input)) {
            FLToolCommand* command = [self toolCommandForNoInput];
            if(command) {
                [command addOperationToTask:task withOptions:nil];
            }
        }
        else {
            FLStringParser* parser = [FLStringParser stringParser:input];
            while(parser.hasMore) {
                NSString* key = [parser parseNextToken];
                if(key) {
                    FLToolCommand* command = [_commands objectForKey:[key lowercaseString]];
                    FLConfirmNotNilWithComment(command, @"Unknown command: %@", key);
                    [command parseInput:parser commandLineTask:task];
                }
            }
        }

        if(task.operations.count > 0) {
            return task;
        }
    }
    @finally {
        [self didParseInput];
    }
    
    return nil;
}

- (void) printUsage {
    for(FLToolCommand* command in [_commands objectEnumerator]) {
        [command printUsage:self.output];
    }
}

- (FLToolCommand*) toolCommandForNoInput {
    return nil;
}

@end

#if OSX

#import <AppKit/AppKit.h>

@implementation NSFileManager (FLCommandLineProcessor)

- (void) openURL:(NSString *)url inBackground:(BOOL)background {
    if (background) {
        NSArray* urls = [NSArray arrayWithObject:[NSURL URLWithString:url]];
        [[NSWorkspace sharedWorkspace] openURLs:urls withAppBundleIdentifier:nil options:NSWorkspaceLaunchWithoutActivation additionalEventParamDescriptor:nil launchIdentifiers:nil];    
    }
    else {
        [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:url]];
    }
}

- (void) openFileInDefaultEditor:(NSString*) path {
    [[NSWorkspace sharedWorkspace] openFile:path];
}

@end

#endif




//- (void) _wait:(FLArgumentHandler*) handler {
//
//    NSTimeInterval pause = [handler.inputData floatValue];
//    FLLog(@"Pausing for %f seconds", pause);
//    NSTimeInterval start = [NSDate timeIntervalSinceReferenceDate];
//    
//    while([NSDate timeIntervalSinceReferenceDate] < (start + pause)) {
//        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate date]];
//    }
//}

//- (void) addInputHandlers {
//    [self addInputHandler:[FLArgumentHandler argumentHandler:@"-?,--help,-h,?"
//                                            inputFlags:0
//                                           description:@"prints this help"
//                                              selector:@selector(willPrintHelp:)]];
//
//    [self addInputHandler:[FLArgumentHandler argumentHandler:@"-u,--usage"
//                                            inputFlags:0
//                                           description:@"prints usage"
//                                              selector:@selector(willPrintUsage:)]];
//    
//    [self addInputHandler:[FLArgumentHandler argumentHandler:@"--debug"
//                                            inputFlags:0
//                                           description:@"Prints debugging info during run"
//                                         callbackBlock: ^(id sender) { self.toolMode = FLToolModeSet(self.toolMode, FLToolModeDebug); }]];
//
//    [self addInputHandler:[FLArgumentHandler argumentHandler:@"--wait"
//                                            inputFlags:FLArgumentIsExpectingData
//                                           description:@"Wait for x seconds"
//                                         selector:@selector(_wait:)]];
//
//
//}

//- (void) addWthParameter {
//    
//    [self addInputHandler:[FLArgumentHandler argumentHandler:@"--wth"
//                                            inputFlags:0
//                                           description:@"Don't invoke this option. You've been warned."
//                                         callbackBlock:^(id sender) {
//                                            [self openURL:@"http://r33b.net/" inBackground:NO];
//                                            } ]];
//}



//- (void) willPrintHelp:(id) sender {
//    FLLog(@"%@ Help:", self.toolName);
//    FLLog(self.helpBlurb);
//    FLLog(@"");
//    [self willPrintUsage:sender];
//}

//- (void) willPrintUsage:(id) sender {
//    FLLog(@"%@ Usage:", self.toolName);
//    for(FLArgumentHandler* handler in _argumentHandlers) {
//        NSString* inputParms = [[NSString stringWithFormat:@"%@:", handler.inputParametersAsString] stringWithPadding_fl:40];
//        FLLog(@"%@%@", inputParms, handler.helpDescription);
//    }
//}

//- (id<FLParseable>) taskForArgument:(FLCommandLineArgument*) argument {
//
//    for(id<FLParseable> task in _listeners) {
//        if([task hasInputParameter:argument.key]) {
//            return task;
//        }
//    }
//    
//    return nil;
//}

//- (NSString*) inputParametersAsString {
//    NSMutableString* string = [NSMutableString string];
//    for(NSString* str in self.inputKeys) {
//    
//        if(string.length) {
//            [string appendFormat:@", %@", str];
//        } else {
//            [string appendString:str];
//        }
//    }
//    return [NSString stringWithFormat:@"[%@]", string];
//}

//- (void) _parseParameters:(NSArray*) input {
//    
//    NSMutableDictionary* handlers = [NSMutableDictionary dictionaryWithCapacity:self.argumentHandlers.count];
//
//    self.toolDirectory = input.firstObject;
//    
//    for(int i = 1; i < input.count; i++) {
//        NSString* parm = [input objectAtIndex:i];
//        FLArgumentHandler* handler = [self argumentHandlerForParameter:parm];
//
//        if(!handler) {
//            FLThrowErrorCodeWithComment([FLToolApplicationErrorDomain instance], FLToolApplicationErrorCodeUnknownParameter, @"Unknown parameter: %@. Try -? for help. Or -u for usage.", parm);
//        }
//        
//        id data = nil;
//
//        if(handler.flags.isExpectingData) {
//            if(i + 1 >= input.count) {
//                FLThrowErrorCodeWithComment([FLToolApplicationErrorDomain instance], FLToolApplicationErrorCodeMissingDataForParameter, @"Expecting data following %@ parameter. Try -? for help. Or -u for usage.", parm);
//            }
//        
//            NSString* nextParm = [input objectAtIndex:++i];
//            if([self argumentHandlerForParameter:nextParm] != nil) {
//                FLThrowErrorCodeWithComment([FLToolApplicationErrorDomain instance], FLToolApplicationErrorCodeMissingDataForParameter, @"Expecting data following %@ parameter, got parameter %@ instead. Try -? for help. Or -u for usage.", parm, nextParm);
//            }
//            
//            data = nextParm;
//        }
//   
//        //check for duplicates
//        for(NSString* aParm in handler.inputKeys) {
//            FLArgumentHandler* unwantedHandler = [handlers objectForKey:aParm];
//            if(unwantedHandler != nil) {
//                FLThrowErrorCodeWithComment( [FLToolApplicationErrorDomain instance],
//                        FLToolApplicationErrorCodeDuplicateParameter, 
//                        @"Duplicate parameter %@ (already got %@). Try -? for help. Or -u for usage.", 
//                        aParm, 
//                        unwantedHandler.inputParametersAsString);
//            }
//        }
//
//        if(data) {
//            [handler prepare:data];
//        }
//        
//        for(NSString* key in handler.inputKeys) {
//            [handlers setObject:handler forKey:key];
//            [handlers setObject:handler forKey:[key stringByReplacingOccurrencesOfString:@"-" withString:@""]];
//        }
//        
//        handler.didFire = YES;
//    }
//
//    // check for incompatible parameters
//    FLArgumentHandler* last = nil;
//    for(FLArgumentHandler* handler in handlers.objectEnumerator) {
//        if(handler && last) {
//            if(![handler isCompatibleWithInputHandler:last]) {
//                FLThrowErrorCodeWithComment([FLToolApplicationErrorDomain instance], FLToolApplicationErrorIncompatibleParameters,
//                @"Parameters %@ and %@ can't be used together. Try -? for help. Or -u for usage.", last.inputParametersAsString, handler.inputParametersAsString);
//            }
//        }
//        last = handler;
//    }        
//
//    for(FLArgumentHandler* handler in _argumentHandlers) {
//        if(handler.flags.isRequired && !handler.didFire) {
//            FLThrowErrorCodeWithComment(
//                [FLToolApplicationErrorDomain instance],
//                FLToolApplicationErrorCodeMissingRequiredParameter,
//                @"Missing required parameter: %@. Try -? for help. Or -u for usage.", handler.inputParametersAsString);
//        }
//    }
//
//    
//    self.arguments = handlers;
//}

//- (BOOL) didInvokeArgument:(NSString*) argumentKey {
//    return [self.arguments objectForKey:argumentKey] != nil;
//}
//
//- (id) parameterFromArgument:(NSString*) argumentKey {
//    return [[self.arguments objectForKey:argumentKey] inputData];
//}



//- (void) willInvokeHandlers:(NSDictionary*) handlers {
//    if(handlers) {
//        for(FLArgumentHandler* handler in handlers.objectEnumerator) {
//            if(handler.prepareCallback) {
//                [handler.prepareCallback invoke:handler];
//            }
//        }
//    }
//}
//
//- (void) willFinishWithHandlers:(NSDictionary*) handlers {
//    if(handlers) {
//        for(FLArgumentHandler* handler in handlers.objectEnumerator) {
//            if(handler.finishedCallback) {
//                [handler.finishedCallback invoke:handler];
//            }
//        }
//    }
//}

//- (void) didLaunchWithParameters:(NSArray*) input {
//    
//    [self _parseParameters:input];
//    
//    if(self.toolMode.debug) {
//        FLLog([input description]);
//    }
//
//    for(FLArgumentHandler* handler in self.arguments.objectEnumerator) {
//        [handler execute];
//    }
//    
//    for(FLArgumentHandler* handler in self.arguments.objectEnumerator) {
//        [handler finish];
//    }
//
//}

//- (void) onHandleError:(NSError*) error {
//    if(FLStringIsNotEmpty(error.localizedDescription)) {
//        FLLog(@"EPIC FAIL: %@", error.localizedDescription);
//    } 
//    else { 
//        FLLog(@"EPIC FAIL: %@", [error description]);
//    }
//}
