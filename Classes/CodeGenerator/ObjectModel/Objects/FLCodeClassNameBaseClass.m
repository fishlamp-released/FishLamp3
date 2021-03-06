// 
// FLCodeClassNameBaseClass.m
// 
// DO NOT MODIFY!! Modifications will be overwritten.
// Generated by: Mike Fullerton @ 6/27/13 5:46 PM with PackMule (3.0.0.31)
// 
// Project: FishLamp Code Generator
// 
// Copyright 2013 (c) GreenTongue Software LLC, Mike Fullerton
// The FishLamp Framework is released under the MIT License: http://fishlamp.com/license
// 

#import "FLCodeClassNameBaseClass.h"
#import "FLCodeElement.h"

@implementation FLCodeClassNameBaseClass

@synthesize className = _className;
+ (id) codeClassName {
    return FLAutorelease([[[self class] alloc] init]);
}
+ (id) codeClassName:(id) className {
    return FLAutorelease([[[self class] alloc] initWithClassName:className]);
}
#if FL_MRC
- (void) dealloc {
    [_className release];
    [super dealloc];
}
#endif
- (id) initWithClassName:(id) className {
    self = [super init];
    if(self) {
        self.className = className;
    }
    return self;
}

@end
