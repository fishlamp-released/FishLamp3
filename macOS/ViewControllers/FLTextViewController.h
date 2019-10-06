//
//  FLTextViewController.h
//  PackMule
//
//  Created by Mike Fullerton on 6/16/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FishLampOSX.h"

@class FLTextViewLogger;

@interface FLTextViewController : NSViewController<NSTextViewDelegate> {
@private
    IBOutlet NSTextView* _textView;

    FLTextViewLogger* _logger;
}

@property (readonly, strong, nonatomic) NSTextView* textView;

@property (readwrite, strong, nonatomic) FLTextViewLogger* logger;

// optional overrides
- (void) setLinkAttributes;

@end
