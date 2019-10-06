//
//  NSView+FLAdditions.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 12/5/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton.. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "NSView+FLAdditions.h"

@implementation NSView (FLAdditions)

- (void) addBackgroundView:(NSView*) view {
    view.frame = self.bounds;
    [self addSubview:view positioned:NSWindowBelow relativeTo:nil];
}

//- (NSString*) description {
//    return [NSString stringWithFormat:@"%@ { frame: %@ }", [super description], NSStringFromRect(self.frame)];
//}

- (void) addSubviews:(NSMutableArray*) array {
    [array addObjectsFromArray:self.subviews];
    for(NSView* view in self.subviews) {
        [view addSubviews:array];
    }
}

- (NSArray*) allSubviews {
    NSMutableArray* subviews = [NSMutableArray array];
    [self addSubviews:subviews];
    return subviews;
}

@end
