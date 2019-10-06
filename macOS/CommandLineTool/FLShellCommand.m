//
//  FLShellCommand.m
//  FishLampOSXTool
//
//  Created by Mike Fullerton on 5/27/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLShellCommand.h"
#import "FishLampAsync.h"

@implementation FLShellCommand
@synthesize environment = _environment;

- (id) initWithLaunchPath:(NSString*) path {
    self = [super init];
    if(self) {
        _launchPath = [path copy];
        _args = [[NSMutableArray alloc] init];
    }
    return self;
}

+ (id) shellCommand:(NSString*) launchPath {
    return FLAutorelease([[[self class] alloc] initWithLaunchPath:launchPath]);
}

#if FL_MRC
- (void) dealloc {
    [_environment release];
    [_args release];
    [_launchPath release];
    [super dealloc];
}
#endif

- (void) addArgument:(FLCommandLineArgument*) arg {
    [_args addObject:arg];
}

//- (void)launch {
//    NSTask *task = [[[NSTask alloc] init] autorelease];
//    [task setLaunchPath:@"/path/to/command"];
//    [task setArguments:[NSArray arrayWithObjects:..., nil]];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(readCompleted:) name:NSFileHandleReadToEndOfFileCompletionNotification object:[outputPipe fileHandleForReading]];
//    [[outputPipe fileHandleForReading] readToEndOfFileInBackgroundAndNotify];
//    [task launch];
//}
//
//- (void)readCompleted:(NSNotification *)notification {
//    NSLog(@"Read data: %@", [[notification userInfo] objectForKey:NSFileHandleNotificationDataItem]);
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSFileHandleReadToEndOfFileCompletionNotification object:[notification object]];
//}
//

+ (NSDictionary*) sshEnvironmentVariables {
//    NSDictionary *environmentDict = [[NSProcessInfo processInfo] environment];

    //[task setEnvironment:[NSDictionary dictionaryWithObjectsAndKeys:NSHomeDirectory(), @"HOME", NSUserName(), @"USER", nil]];

    // Environment variables needed for password based authentication 
//    NSMutableDictionary *env = [NSMutableDictionary dictionaryWithObjectsAndKeys:
//                         @"NONE", @"DISPLAY",                           
//                         askPassPath, @"SSH_ASKPASS",
//                         userName,@"AUTH_USERNAME",
//                         hostName,@"AUTH_HOSTNAME",
//                         nil];
//
//    // Environment variable needed for key based authentication
//    [env setObject:[environmentDict objectForKey:@"SSH_AUTH_SOCK"] forKey:@"SSH_AUTH_SOCK"];
//
//    return env;

    return nil;
}

- (NSString*) didFinishTask:(NSTask*) task {

    NSString* outputStr = nil;
    NSFileHandle* file = nil;
    
    id output = [task standardOutput];
    if ( [output isKindOfClass:[NSPipe class]]) {
        file = [output fileHandleForReading];
    }
    else if( [output isKindOfClass:[NSFileHandle class]]){
        file = output;
    }

    if(file) {
        NSData* data = [file availableData];
        outputStr = FLAutorelease([[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding]);
    }
    
    return outputStr;
}

- (void) finishTask:(NSTask*) task {

#if __MAC_10_8

//    @try {
//        [self.finisher setFinishedWithResult:[self didFinishTask:task]];
//    }
//    @catch(NSException* ex) {
//
//// TODO: convert to an error?    
//    
//        [self.finisher setFinishedWithResult:ex];
//    }
//    @finally {
//        task.terminationHandler = nil;
//    }

#endif
}

- (void) willStartTask:(NSTask*) task {

}

- (void) startOperation:(FLFinisher*) finisher {

#if __MAC_10_8
    NSTask* task = FLAutorelease([[NSTask alloc] init]);
    
    NSMutableArray* args = [NSMutableArray array];
    
    for(FLCommandLineArgument* arg in _args) {
        [args addObject:[arg parameterString]];
    }

    [task setLaunchPath:_launchPath];
    
    if(args && args.count) {
        [task setArguments:args];
    }
    
    if(self.environment) {
        [task setEnvironment:self.environment];
    }

    task.terminationHandler = ^(NSTask* aTask) {
        [self finishTask:aTask];
    };

    NSPipe *outputPipe = [NSPipe pipe];
    [task setStandardOutput:outputPipe];
    
    [self willStartTask:task];

    [task launch];
#endif    
}
@end

            
//        while(task.isRunning && !taskTerminated) {
//
//// TODO: cancel support?? do we need an error?
//
////            if(self.error) {
////                [task terminate];
////            }
//        }
//        
//        NSString* outputStr = nil;
//        NSFileHandle* file = nil;
//        
//        id output = [task standardOutput];
//        if ( [output isKindOfClass:[NSPipe class]]) {
//            file = [output fileHandleForReading];
//        }
//        else if( [output isKindOfClass:[NSFileHandle class]]){
//            file = output;
//        }
//
//        if(file) {
//            NSData* data = [file availableData];
//            outputStr = FLAutorelease([[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding]);
//        }
        
//        return outputStr;
//    }
//    @catch (NSException* ex) {
//        FLLog(@"Exception: %@", [ex description]);
//        FLAssert(!task.isRunning, @"task is still running but we got an exception: %@", [ex description]);
//        @throw;
//    }
//    @finally {
//        task.terminationHandler = nil;
//        FLRelease(task);
//    }
