//
//  FLToolCommand.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 1/9/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLStringParser.h"
#import "FLStringFormatter.h"
#import "FLToolCommandOption.h"
#import "FLCommandLineTask.h"

@interface FLToolCommand : FLOperation {
@private
    NSString* _commandName;
    NSMutableDictionary* _subcommands;
    NSMutableDictionary* _options;
    NSString* _help;
    __unsafe_unretained id _parent; 
}
@property (readonly, assign, nonatomic) id parent;
@property (readonly, strong, nonatomic) FLLogger* output;
@property (readonly, strong, nonatomic) NSString* commandName;
@property (readonly, strong, nonatomic) NSDictionary* options;
@property (readonly, strong, nonatomic) NSDictionary* subcommands;

@property (readwrite, strong, nonatomic) NSString* help;

+ (id) toolCommand;

- (id) initWithCommandName:(NSString*) command;

// subcommands
- (void) addSubcommand:(FLToolCommand*) command;

// options
- (void) addOption:(FLToolCommandOption*) option;
- (FLToolCommandOption*) optionForKey:(NSString*) key;

// optional overrides
- (void) parseInput:(FLStringParser*) input commandLineTask:(FLCommandLineTask*) commandLineTask;
- (void) addOperationToTask:(FLCommandLineTask*) task withOptions:(NSDictionary*) options;

// optional overrides
- (void) printHelpToStringFormatter:(FLStringFormatter*) output;

- (void) printUsage:(FLStringFormatter*) output;

@end