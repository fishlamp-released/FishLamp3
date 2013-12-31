//
//  FLCommandLineParser.m
//  FishLampCommandLineTool
//
//  Created by Mike Fullerton on 11/14/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLCommandLineParser.h"
#import "FLCommandLineArgument.h"

@implementation FLCommandLineParser

+ (id) commandLineParser {
    return FLAutorelease([[[self class] alloc] init]);
}

- (NSArray*) parseArguments:(NSArray*) arrayOfStrings {
    NSMutableArray* arguments = [NSMutableArray array];
    for(NSString* string in arrayOfStrings) {
        if([string hasPrefix:@"-"] || arguments.count == 0) {
            FLCommandLineArgument* arg = [FLCommandLineArgument commandLineArgument:string];
            [arguments addObject:arg];
        }
        else {
            [[arguments lastObject] addValue:string];
        }
    }
    
    return arguments;
}

@end

