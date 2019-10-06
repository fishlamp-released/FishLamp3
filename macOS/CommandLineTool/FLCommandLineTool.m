//
//  FLToolApplication.m
//  FishLampTools
//
//  Created by Fullerton Mike on 5/5/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLCommandLineTool.h"
#import "NSString+FishLamp.h"
#import "NSString+Lists.h"
#import "NSBundle+FLAdditions.h"
#import "FishLampAsync.h"
#import "FLLog.h"
#import "FLConsoleLogSink.h"

@interface FLCommandLineTool ()
@property (readwrite, strong, nonatomic) NSURL* toolPath;
@property (readwrite, strong, nonatomic) NSString* startDirectory;
@property (readwrite, strong, nonatomic) NSError* error;
@property (readwrite, assign) BOOL running;
@end

@implementation FLCommandLineTool

static id s_instance;

@synthesize toolPath = _toolPath;
@synthesize startDirectory = _startDirectory;
@synthesize running = _running;
@synthesize error = _error;
@synthesize implementation = _implementation;

+ (id) sharedTool {
    return s_instance;
}

//+ (id) commandLineTool {
//    return FLAutorelease([[[self class] alloc] initWithToolName:nil]);
//}
//
//+ (id) commandLineTool:(NSString*) toolName {
//    return FLAutorelease([[[self class] alloc] initWithToolName:toolName]);
//}


- (NSString*) toolIdentifier {
    return nil;
}

- (NSString*) toolVersion {
    return nil;
}

- (NSString*) toolName {
    return nil;
}

- (id) initWithToolImplementation:(id<FLCommandLineToolImplementation>) imp {
    self = [super init];
    if(self) {
        FLAssertNotNil(imp);
    
        _implementation = imp;
   //     [FLAppInfo setAppInfo:self.toolIdentifier appName:self.toolName version:self.toolVersion];


        FLLogSinkBehavior* behavior = [FLLogSinkBehavior logSinkBehavior];


        self.output = [FLLogger logger];
        [self.output addLoggerSink:[FLConsoleLogSink consoleLogSink:behavior]];
    }
    
    return self;
}

- (id) init {
    return [self initWithToolImplementation:nil];
}

#if FL_MRC
- (void) dealloc {
    [_error release];
    [_startDirectory release];
    [_toolPath release];
    [super dealloc];
}
#endif

- (void) setCurrentDirectory:(NSString*) newDirectory {

// TODO: this returns a BOOL? Check it?
    [[NSFileManager defaultManager] changeCurrentDirectoryPath:newDirectory];
}

- (NSString*) currentDirectory {
    return [[NSFileManager defaultManager] currentDirectoryPath];
}

- (int) runFromMain:(int) argc argv:(const char**) argv {

    NSMutableArray* array = [NSMutableArray array];
    for(int i = 0; i < argc; i++) {
        [array addObject:[NSString stringWithCString:argv[i] encoding:NSASCIIStringEncoding]];
    }
    return [self runWithArguments:array];
}

- (NSString*) getPassword:(NSString*) prompt {

//    [self.output appendString:prompt];
    char *pass = getpass(prompt.UTF8String);
    return [NSString stringWithCString:pass encoding:NSUTF8StringEncoding];
}

- (NSString*) getInputString:(NSString*) prompt maxLength:(NSUInteger) maxLength {
    
    [self.output appendLine:prompt];

    fflush(stdout);

    char* buffer = malloc(maxLength + 1);
    
    NSInteger idx = 0;
    
    char c = getc(stdin);
    while(c != '\n' && idx < maxLength) {
        buffer[idx++] = c;
        c = getc(stdin);
    }
    buffer[idx] = 0;
    
    NSString* outString = [NSString stringWithCString:buffer encoding:NSUTF8StringEncoding];
    
    free(buffer);
    
    return outString;
}

- (void) willRunTool:(FLCommandLineTask*) task {
    if(!task) {
        [self printUsage];
    }
}

- (void) didRunTool {
}

- (void) runTool:(FLCommandLineTask*) task {
    FLThrowIfError([[FLOperationContext operationContext] runSynchronously:task]);
}

- (int) runWithArguments:(NSArray*) arguments {

#if FL_MRC    
    @autoreleasepool {
#endif    
        @try {
            s_instance = self;
            NSArray* args = [[NSProcessInfo processInfo] arguments];

            self.toolPath = [NSURL fileURLWithPath:[args objectAtIndex:0]];
            self.startDirectory = [[NSFileManager defaultManager] currentDirectoryPath];

            NSArray* argsWithoutPath = [args subarrayWithRange:NSMakeRange(1, args.count -1)];

            NSString* string = [NSString concatStringArray:argsWithoutPath delimiter:@" "];

            FLCommandLineTask* task = [self taskFromInput:string];
            [self willRunTool:task];
            if(task) {
                [self runTool:task];
            }
        }
        @catch(NSException* ex) {
            self.error = ex.error;
        
            [[self output] appendLineWithFormat:@"uncaught exception: %@", [ex reason]];

            return 1;
        }
        @finally {
            [self didRunTool];
            s_instance = nil;
        }
        
        return 0;
#if FL_MRC
    }
#endif
}

- (void) startRunLoop {
    self.running = YES;
    while(self.running) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate date]];
    }
}

- (void) stopRunLoop {
    self.running = NO;
}


@end



