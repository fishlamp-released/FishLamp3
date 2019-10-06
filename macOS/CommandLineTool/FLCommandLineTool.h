//
//  FLCommandLineTool.h
//  FishLampCommandLineTool
//
//  Created by Mike Fullerton on 11/14/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton.. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//
#import "FishLampCore.h"
#import "FLCommandLineProcessor.h"
#import "FLStringFormatter.h"
#import "FLStringParser.h"
#import "FLToolCommand.h"
#import "FLLogger.h"

@protocol FLCommandLineToolImplementation <NSObject>
- (NSString*) toolName;
- (NSString*) toolIdentifier;
- (NSString*) toolVersion;

@optional
- (void) willRunTool:(FLCommandLineTask*) task;
- (void) runTool:(FLCommandLineTask*) task;
- (void) didRunTool;
@end

@interface FLCommandLineTool : FLCommandLineProcessor {
@private
    NSURL* _toolPath;
    NSString* _startDirectory;
    BOOL _running;
    NSError* _error;
    
    __unsafe_unretained id<FLCommandLineToolImplementation> _implementation;
}

+ (id) sharedTool;

@property (readonly, assign, nonatomic) id<FLCommandLineToolImplementation> implementation;

@property (readonly, strong, nonatomic) NSURL* toolPath;
@property (readonly, strong, nonatomic) NSString* startDirectory;
@property (readwrite, strong, nonatomic) NSString* currentDirectory;

- (id) initWithToolImplementation:(id<FLCommandLineToolImplementation>) implementation;

// call this from your main.
- (int) runFromMain:(int) argc argv:(const char*[]) argv;
// or
- (int) runWithArguments:(NSArray*) arguments;

- (NSString*) getInputString:(NSString*) prompt maxLength:(NSUInteger) maxLength;
- (NSString*) getPassword:(NSString*) prompt;

- (void) startRunLoop;
- (void) stopRunLoop;

@end



#define FLToolLog(FORMAT, ...) \
            [[[FLCommandLineTool sharedTool] output] appendLineWithFormat:FORMAT, ##__VA_ARGS__]