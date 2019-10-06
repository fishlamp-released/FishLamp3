//
//  FLWizardHeaderViewController.m
//  FishLampCocoaUI
//
//  Created by Mike Fullerton on 3/3/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLWizardHeaderViewController.h"

#import <QuartzCore/QuartzCore.h>

#define kAnimationDuration 0.2

@interface FLWizardHeaderViewController ()

@end

@implementation FLWizardHeaderViewController

@synthesize promptTextField = _titleView;

- (void)awakeFromNib {
    [super awakeFromNib];
    [_titleView removeFromSuperview];
    if(_logoView && _titleView) {
        [self.view addSubview:_titleView positioned:NSWindowAbove relativeTo:_logoView];
    }
}

- (void) setPrompt:(NSString*) title animated:(BOOL) animated {
    
    title = FLEmptyStringOrString(title);
    
    NSShadow* shadw = FLAutorelease([[NSShadow alloc] init]);
    [shadw setShadowColor:[NSColor whiteColor]];
    [shadw setShadowOffset:NSMakeSize( 1.0, -1.0 )];
    [shadw setShadowBlurRadius:1.0];        

    NSDictionary* attr = [NSDictionary dictionaryWithObjectsAndKeys:
        _titleView.textColor, NSForegroundColorAttributeName,
        (id) shadw, NSShadowAttributeName,
        _titleView.font, NSFontAttributeName,
        nil];
            
    NSAttributedString* attributedString = FLAutorelease([[NSAttributedString alloc] initWithString:title attributes:attr]);

#if __MAC_10_8    
    if(animated && OSXVersionIsAtLeast10_8()) {

        NSTextField* old = FLAutorelease([[[_titleView class] alloc] initWithFrame:_titleView.frame]);
        old.textColor = _titleView.textColor;
        old.drawsBackground = _titleView.drawsBackground;
        old.font = _titleView.font;
        old.attributedStringValue = _titleView.attributedStringValue;
        old.bordered = _titleView.isBordered;
        old.bezeled = _titleView.isBezeled;
        old.backgroundColor = _titleView.backgroundColor;
        old.bezelStyle = _titleView.bezelStyle;
        
        [_titleView.superview addSubview:old];
        _titleView.alphaValue = 0.0;
        _titleView.attributedStringValue = attributedString;
    
        [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
            [context setDuration: kAnimationDuration];
            [context setTimingFunction: [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseIn]];
            
            [old.animator setAlphaValue:0.0];
            [_titleView.animator setAlphaValue: 1.0];
        } completionHandler: ^{
            [old removeFromSuperview];
        }];

    }
    else
#endif
    {
        _titleView.attributedStringValue = attributedString;
    }
}

- (NSView*) contentView {
    return self.view;
}

- (void) panelWillAppear:(FLPanelViewController*) panel {

#if __MAC_10_8    
    if(OSXVersionIsAtLeast10_8()) {
        if(panel.isAuthenticated && _logoutButton.isHidden) {
            _logoutButton.hidden = NO;
            _welcomeText.hidden = NO;
            _logoutButton.alphaValue = 0.0;
            _welcomeText.alphaValue = 0.0;

            [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
                [context setDuration: kAnimationDuration];
                [context setTimingFunction: [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseIn]];
                
                [_welcomeText.animator setAlphaValue:1.0];
                [_logoutButton.animator setAlphaValue: 1.0];
            } completionHandler: ^{
            }];    
        }
        else if(!panel.isAuthenticated && !_logoutButton.isHidden) {
            [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
                [context setDuration: kAnimationDuration];
                [context setTimingFunction: [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseIn]];
                
                [_logoutButton.animator setAlphaValue:0.0];
                [_welcomeText.animator setAlphaValue: 0.0];
            } completionHandler: ^{
                _logoutButton.hidden = YES;
                _welcomeText.hidden = YES;
                _logoutButton.alphaValue = 1.0;
                _welcomeText.alphaValue = 1.0;
            }];
        }
    }
    else
#endif
    if(panel.isAuthenticated && _logoutButton.isHidden) {
        _logoutButton.hidden = NO;
        _welcomeText.hidden = NO;
    }
    else {
        _logoutButton.hidden = YES;
        _welcomeText.hidden = YES;
    }

}

- (void) setTextNextToLogoutButton:(NSString*) welcomeText {
    _welcomeText.stringValue = welcomeText;
}


@end
