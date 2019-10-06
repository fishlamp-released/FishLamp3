//
//  FLErrorWindowController.m
//  FishLampOSX
//
//  Created by Mike Fullerton on 5/7/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "NSWindowController+FLModalAdditions.h"
#import "FLErrorWindowController.h"
#import "NSError+FLTimeout.h"

@interface FLErrorWindowController ()

@end

@interface FLErrorWindowView : NSView {
@private
    IBOutlet NSButton* _button;
}

@end

@implementation FLErrorWindowView

- (BOOL) acceptsFirstResponder {
    return YES;
}

- (BOOL) becomeFirstResponder {
    return YES;
}

- (void)keyDown:(NSEvent *)theEvent {
    NSString* chars = [theEvent charactersIgnoringModifiers];
    if([chars length] == 1) {
        unichar c = [chars characterAtIndex:0];
        if(c == NSCarriageReturnCharacter || c == NSEnterCharacter) {
            __block id button = FLRetain(_button);
            _button = nil;
            if(button) {
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    [button performClick:nil];
                    FLReleaseWithNil(button);
                });
            }
        }
    }
}

@end

@implementation FLErrorWindowController
@synthesize okButton = _okButton;

- (id) initWithTitle:(NSString*) title explanation:(NSString*) explanation {	
	self = [super initWithWindowNibName:@"FLErrorWindowController"];
	if(self) {
		_title = FLRetain(title);
        _explanation = FLRetain(explanation);
	}
	return self;
}

#if FL_MRC
- (void) dealloc {
	[_title release];
    [_explanation release];
    [super dealloc];
}
#endif

+ (id) errorWindowController:(NSString*) title explanation:(NSString*) explanation {
    return FLAutorelease([[[self class] alloc] initWithTitle:title explanation:explanation]);
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    [_explanationField.textStorage deleteCharactersInRange:NSMakeRange(0, _explanationField.textStorage.length)];

    _titleField.stringValue = _title;
    if(FLStringIsNotEmpty(_explanation)) {
        [_explanationField.textStorage appendAttributedString:FLAutorelease([[NSAttributedString alloc] initWithString:_explanation]) ];
    }

    [self.window setContentView:_errorWindowView];
    [self.window setDefaultButtonCell:[_okButton cell]];
}

@end

@implementation NSViewController (FLErrorWindowController)

- (void) showErrorAlert:(NSString*) title caption:(NSString*) caption error:(NSError*) error {
    if(![error isCancelError]) {
   
// TODO (MWF): double dispatch this back into the error?
     
        if([error isTimeoutError]) {
            title = NSLocalizedString(@"An operation on the server timed out.", nil);
            caption = NSLocalizedString(@"Please check your connection and try again.", nil);
        }
        
        if(!title) {
            title = NSLocalizedString(@"An error occurred", nil);
        }
        if(!caption) {
            caption = error.localizedDescription;
        }
        
        FLErrorWindowController* controller = [FLErrorWindowController errorWindowController:title explanation:caption];
                       
        [self showModalWindow:controller withDefaultButton:controller.okButton finishedBlock:nil];
    }

}

@end


@implementation NSWindowController (FLErrorWindowController)

- (void) showErrorAlert:(NSString*) title caption:(NSString*) caption error:(NSError*) error {
    if(![error isCancelError]) {
   
// TODO (MWF): double dispatch this back into the error?
     
        if([error isTimeoutError]) {
            title = NSLocalizedString(@"An operation on the server timed out.", nil);
            caption = NSLocalizedString(@"Please check your connection and try again.", nil);
        }
        
        if(!title) {
            title = NSLocalizedString(@"An error occurred", nil);
        }
        if(!caption) {
            caption = error.localizedDescription;
        }
        
        FLErrorWindowController* controller = [FLErrorWindowController errorWindowController:title explanation:caption];
        FLAssertNotNil(controller);
                       
        [self.window showModalWindow:controller withDefaultButton:controller.okButton finishedBlock:nil];
    }

}

@end