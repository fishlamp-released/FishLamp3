//
//  FLCommandLineArgument.m
//  FishLampCommandLineTool
//
//  Created by Mike Fullerton on 11/14/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLCommandLineArgument.h"

@interface FLCommandLineArgument ()
@property (readwrite, strong, nonatomic) NSString* key;
@property (readwrite, strong, nonatomic) NSArray* values;
@end

@implementation FLCommandLineArgument

@synthesize values = _values;
@synthesize key = _key;

- (id) initWithKey:(NSString*) key {
    self = [super init];
    if(self) {
        self.key = key;
    }
    return self;
}

+ (id) commandLineArgument:(NSString*) key {
    return FLAutorelease([[[self class] alloc] initWithKey:key]);
}


#if FL_MRC
- (void) dealloc {

    [_values release];
    [super dealloc];
}
#endif

- (void) addValue:(NSString*) param {
    if(!_values) {
        _values = [[NSMutableArray alloc] init];
    }
    [_values addObject:param];
}

- (NSString*) description {
    return [NSString stringWithFormat:@"%@ { key=%@, values=%@", [super description], self.key, [self.values description]];
}

- (NSString*) parameterString {
    NSMutableString* string = [NSMutableString stringWithString:self.key];
    
    for(NSString* value in _values) {
        [string appendFormat:@" %@", value];
    }
    
    return string;
}

@end

