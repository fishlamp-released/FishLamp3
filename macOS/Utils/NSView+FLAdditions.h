//
//  NSView+FLAdditions.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 12/5/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton.. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import <Cocoa/Cocoa.h>

@interface NSView (FLAdditions)
- (void) addBackgroundView:(NSView*) view;
- (NSArray*) allSubviews;
@end
