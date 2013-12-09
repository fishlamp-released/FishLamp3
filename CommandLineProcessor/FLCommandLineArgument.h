//
//  FLCommandLineArgument.h
//  FishLampCommandLineTool
//
//  Created by Mike Fullerton on 11/14/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampMinimum.h"
#import "FLCommandLineParser.h"

@interface FLCommandLineArgument : NSObject {
@private
    NSString* _key;
    NSMutableArray* _values;
}

@property (readonly, strong, nonatomic) NSString* key;
@property (readonly, strong, nonatomic) NSArray* values;

- (id) initWithKey:(NSString*) key;
+ (id) commandLineArgument:(NSString*) key;

- (void) addValue:(NSString*) param;

- (NSString*) parameterString;

@end


