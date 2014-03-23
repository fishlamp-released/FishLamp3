//
//  FLCodeBuilder.m
//  FishLamp
//
//  Created by Mike Fullerton on 10/1/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLCodeBuilder.h"
#import "FLCodeChunk.h"

@implementation FLCodeBuilder

+ (id) codeBuilder {
    return FLAutorelease([[[self class] alloc] init]);
}

//- (void) addCodeChunk:(FLCodeChunk*) codeChunk {
//    [self addSection:codeChunk];
//}
//
//- (void) openCodeChunk:(FLCodeChunk*) codeChunk {
//    [self openSection:codeChunk];
//}
//
//- (void) closeCodeChunk {
//    [self closeSection];
//}
//
//- (void) appendCodeBuilder:(FLCodeBuilder*) codeBuilder {
//
//}

@end

