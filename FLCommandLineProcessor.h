//
//  FLCommandLineProcessor.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 3/27/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampMinimum.h"
#import "FLStringFormatter.h"
#import "FLStringParser.h"
#import "FLToolCommand.h"
#import "FLCommandLineTask.h"

@interface FLCommandLineProcessor : NSObject {
@private
    NSMutableDictionary* _commands;
    FLLogger* _output;
}

@property (readonly, strong, nonatomic) NSDictionary* commands;
@property (readwrite, strong) FLLogger* output;

- (void) addToolCommand:(FLToolCommand*) command;

- (FLCommandLineTask*) taskFromInput:(NSString*) input;

- (void) willParseInput;
- (void) didParseInput;

- (void) printUsage;

- (FLToolCommand*) toolCommandForNoInput;

@end

@interface NSFileManager (FLCommandLineProcessor)
- (void) openURL:(NSString *)url inBackground:(BOOL)background;
- (void) openFileInDefaultEditor:(NSString*) path;
@end

