// 
// FLCodeArrayTypeBaseClass.m
// 
// DO NOT MODIFY!! Modifications will be overwritten.
// Generated by: Mike Fullerton @ 6/27/13 5:17 PM with PackMule (3.0.0.31)
// 
// Project: FishLamp Code Generator
// 
// Copyright 2013 (c) GreenTongue Software LLC, Mike Fullerton
// The FishLamp Framework is released under the MIT License: http://fishlamp.com/license
// 

#import "FLCodeProperty.h"
#import "FLCodeVariable.h"
#import "FLCodeArrayTypeBaseClass.h"

@implementation FLCodeArrayTypeBaseClass

+ (id) codeArrayType {
    return FLAutorelease([[[self class] alloc] init]);
}
#if FL_MRC
- (void) dealloc {
    [_wildcardProperty release];
    [super dealloc];
}
#endif
FLSynthesizeLazyGetterDeprecated(wildcardProperty, FLCodeProperty, _wildcardProperty);
@synthesize wildcardProperty = _wildcardProperty;

@end
