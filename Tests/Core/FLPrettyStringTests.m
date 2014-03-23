//
//  FLFancyStringTests.m
//  FishLampCore
//
//  Created by Mike Fullerton on 5/26/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLPrettyStringTests.h"

@implementation FLPrettyStringTests

- (id<FLStringFormatter>) createStringFormatter:(FLWhitespace*) whiteSpace {
    return [FLPrettyString prettyString:whiteSpace];
}

- (id<FLStringFormatter>) createStringFormatter {
    return [FLPrettyString prettyString];
}

@end

@implementation FLPrettyAttributedStringTests

- (id<FLStringFormatter>) createStringFormatter:(FLWhitespace*) whiteSpace {
    return [FLPrettyAttributedString prettyAttributedString:whiteSpace];
}

- (id<FLStringFormatter>) createStringFormatter {
    return [FLPrettyAttributedString prettyAttributedString];
}

@end

