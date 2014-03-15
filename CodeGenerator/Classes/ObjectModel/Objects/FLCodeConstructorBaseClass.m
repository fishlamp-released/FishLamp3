// 
// FLCodeConstructorBaseClass.m
// 
// DO NOT MODIFY!! Modifications will be overwritten.
// Generated by: Mike Fullerton @ 6/27/13 5:17 PM with PackMule (3.0.0.31)
// 
// Project: FishLamp Code Generator
// 
// Copyright 2013 (c) GreenTongue Software LLC, Mike Fullerton
// The FishLamp Framework is released under the MIT License: http://fishlamp.com/license
// 

#import "FLCodeConstructorBaseClass.h"
#import "FLModelObject.h"
#import "FLCodeElement.h"
#import "FLObjectDescriber.h"
#import "FLCodeConstructorParameter.h"

@implementation FLCodeConstructorBaseClass

+ (id) codeConstructor {
    return FLAutorelease([[[self class] alloc] init]);
}
#if FL_MRC
- (void) dealloc {
    [_lines release];
    [_parameters release];
    [super dealloc];
}
#endif
+ (void) didRegisterObjectDescriber:(FLObjectDescriber*) describer {
    [describer addContainerType:[FLPropertyDescriber propertyDescriber:@"line" propertyClass:[FLCodeElement class]] forContainerProperty:@"lines"];
    [describer addContainerType:[FLPropertyDescriber propertyDescriber:@"parameter" propertyClass:[FLCodeConstructorParameter class]] forContainerProperty:@"parameters"];
}
FLSynthesizeLazyGetterDeprecated(lines, NSMutableArray, _lines);
@synthesize lines = _lines;
FLSynthesizeLazyGetterDeprecated(parameters, NSMutableArray, _parameters);
@synthesize parameters = _parameters;

@end
