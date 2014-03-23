//
//  FLCStyleCodeBuilder.m
//  FLCore
//
//  Created by Mike Fullerton on 5/26/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLCStyleCodeBuilder.h"

@implementation FLCStyleCodeBuilder

- (id) init {
    self = [super init];
    if(self) {
        self.openScopeString = @"{";
        self.closeScopeString = @"}";
    }
    
    return self;
}

//- (id) initWithOpenBracketStyle:(FLOpenBracketStyle) openBracketStyle
//              closeBracketStyle:(FLCloseBracketStyle) closeBracketStyle {
//    
//    return = [super initWithOpenBracket:@"{" closeBracket:@"}" openBracketStyle:FLOpenBracketStyleDefault closeBracketStyle:FLCloseBracketStyleDefault];
//}
//
//+ (FLCStyleCodeBuilder*) cStyleCodeBuilder:(FLOpenBracketStyle) openBracketStyle
//                         closeBracketStyle:(FLCloseBracketStyle) closeBracketStyle {
// 
//    return [[[self class] alloc] initWithOpenBracketStyle:openBracketStyle closeBracketStyle:closeBracketStyle];
//}

@end

