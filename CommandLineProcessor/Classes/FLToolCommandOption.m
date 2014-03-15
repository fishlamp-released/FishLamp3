//
//  FLToolCommandOption.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 1/9/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLToolCommandOption.h"
#import "NSString+FishLamp.h"
#import "NSString+Lists.h"
#import "NSString+FishLamp.h"

@implementation FLToolCommandOption

@synthesize optionKeys = _optionKeys;
@synthesize help = _help;

- (id) initWithKeys:(NSString*) keys {
    self = [super init];
    if(self) {
        _optionKeys = [[NSMutableSet alloc] init];
    
        if(keys) {
            [self addKeys:keys];
        }
    }
    
    return self;
}

- (id) init {
    return [self initWithKeys:nil];
}

#if FL_MRC
- (void) dealloc {
    [_help release];
    [_optionKeys release];
    [super dealloc];
}
#endif

+ (id) toolCommandOption {
    return FLAutorelease([[[self class] alloc] init]);
}

+ (id) toolCommandOption:(NSString*) keys {
    return FLAutorelease([[[self class] alloc] initWithKeys:keys]);
}

- (void) addKeys:(NSString*) keys {
    NSArray* list = [keys componentsSeparatedByCharactersInSet_fl:[NSCharacterSet characterSetWithCharactersInString:@", "] allowEmptyStrings:NO];
    for(NSString* key in list) {
        [_optionKeys addObject:[key lowercaseString]];
    }
}

- (id) parseOptionData:(FLStringParser*) input siblings:(NSDictionary*) siblings {
    return nil;
}

- (void) printUsage:(FLStringFormatter*) output {
    [output appendString:[NSString concatStringArray:self.optionKeys.allObjects]];
}

- (void) printHelpToStringFormatter:(FLStringFormatter*) output {
    [output appendLineWithFormat:@"%@: %@",
        [NSString concatStringArray:self.optionKeys.allObjects],
//        [[NSString concatStringArray:self.optionKeys.allObjects] stringWithPadding_fl:20],
        [self help]];
}


@end
