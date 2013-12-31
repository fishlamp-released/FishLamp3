//
//  FLToolCommand.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 1/9/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLToolCommand.h"
@interface FLToolCommand ()
@property (readwrite, assign, nonatomic) id parent;
@end

@implementation FLToolCommand

@synthesize options = _options;
@synthesize commandName = _commandName;
@synthesize subcommands = _subcommands;
@synthesize help = _help;
@synthesize parent = _parent;

- (id) initWithCommandName:(NSString*) commandName {
    self = [super init];
    if(self) {
        _commandName = FLRetain(commandName);
    }
    return self;
}

+ (id) toolCommand {
    return FLAutorelease([[[self class] alloc] init]);
}

#if FL_MRC
- (void) dealloc {
    [_subcommands release];
    [_help release];
    [_commandName release];
    [_options release];
    [super dealloc];
}
#endif

- (FLLogger*) output {
    return (id) [self.parent output];
}

- (FLToolCommandOption*) optionForKey:(NSString*) key {
    return [_options objectForKey:key];
}

- (void) addOption:(FLToolCommandOption*) option {
    for(NSString* key in option.optionKeys) {
        if(FLStringIsNotEmpty(key)) {
            id existing = [_options objectForKey:[key lowercaseString]];
            FLConfirmIsNilWithComment(existing, @"option already installed for key: %@", key);
            [_options setObject:option forKey:key];
        }
    }
}

- (NSDictionary*) parseOptions:(FLStringParser*) input {

    NSMutableDictionary* options = [NSMutableDictionary dictionary];

    NSString* key = [input lastToken];
    while(key) {
        FLToolCommandOption* option = [_options objectForKey:[key lowercaseString]];
        FLConfirmNotNilWithComment(option, @"Unknown option: %@", key);
        
        id data = [option parseOptionData:input siblings:self.options];
        if(!data) {
            data = [NSNull null];
        }
        
        [options setObject:data forKey:key];

        key = [input parseNextToken];
    }
    
    return options;
}

- (void) addOperationToTask:(FLCommandLineTask*) task withOptions:(NSDictionary*) options {
    [task queueOperation:self];
}

- (void) addSubcommand:(FLToolCommand *)command {
    if(!_subcommands) {
        _subcommands = [[NSMutableDictionary alloc] init];
    }
    command.parent = self;
    [_subcommands setObject:command forKey:[command.commandName lowercaseString]];
}

- (void) parseInput:(FLStringParser*) input 
    commandLineTask:(FLCommandLineTask*) commandLineTask {

    NSString* key = [input parseNextToken];
    NSDictionary* options = nil;
    
    if(key) {
        FLToolCommand* command = [_subcommands objectForKey:[key lowercaseString]];
        if(command) {
            // if we have subcommand - we don't get executed - only the leaf most command does.
            [command parseInput:input commandLineTask:commandLineTask];
            return;
        }

        options = [self parseOptions:input];
    }

//    FLConfirmWithComment(input.last == nil, @"input still remains: %@", input.unparsed);

    [self addOperationToTask:commandLineTask withOptions:options];
}


- (void) printUsage:(FLStringFormatter*) output {
    [output openLineWithString:_commandName];
    for(FLToolCommandOption* option in _options) {
        [output appendString:@" "];
        [option printUsage:output];
    }
    [output closeLine];
    
    [output indentLinesInBlock:^{
        for(FLToolCommand* subcommand in _subcommands) {
            [subcommand printUsage:output];
        }
    }];
}

- (void) printHelpToStringFormatter:(FLStringFormatter*) output {
//    [output appendLineWithFormat:@"@: %@", [[NSString concatStringArray:self.argumentKeys.allObjects] stringWithPadding_fl:20], [self help]];
}


@end
