//
//  FLTextViewController.m
//  PackMule
//
//  Created by Mike Fullerton on 6/16/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLTextViewController.h"
#import "FLTextViewLogger.h"

@implementation FLTextViewController

@synthesize textView = _textView;
@synthesize logger = _logger;
FLSynthesizeLazyGetterWithBlock(logger, FLTextViewLogger*, _logger, ^{ return [FLTextViewLogger textViewLogger:self.textView]; } );

- (void) setLinkAttributes {
    NSMutableDictionary* attr = [NSMutableDictionary dictionary];
    [attr setObject:[NSFont boldSystemFontOfSize:[NSFont smallSystemFontSize]] forKey:NSFontAttributeName];
    [attr setObject:[NSNumber numberWithBool:YES] forKey:NSUnderlineStyleAttributeName];
    [attr setObject:[NSColor blueColor] forKey:NSForegroundColorAttributeName];
    [attr setObject:[NSCursor pointingHandCursor] forKey:NSCursorAttributeName];
    [_textView setLinkTextAttributes:attr];
}

- (void) awakeFromNib {
	[super awakeFromNib];
    FLAssertNotNil(_textView);

    [self setLinkAttributes];
}

#if FL_MRC
- (void)dealloc {
	[_logger release];
	[super dealloc];
}
#endif

@end

