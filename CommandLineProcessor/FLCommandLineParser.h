//
//  FLCommandLineParser.h
//  FishLampCommandLineTool
//
//  Created by Mike Fullerton on 11/14/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampMinimum.h"

@class FLCommandLineArgument;

@protocol FLCommandLineParser <NSObject>
- (NSArray*) parseArguments:(NSArray*) arrayOfStrings;
@end

@interface FLCommandLineParser : NSObject<FLCommandLineParser>
+ (id) commandLineParser;
@end

//extern NSArray* FLCommandLineArguments(int argc, const char * argv[]);
