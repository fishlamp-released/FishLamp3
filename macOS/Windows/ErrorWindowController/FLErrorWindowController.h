//
//  FLErrorWindowController.h
//  FishLampOSX
//
//  Created by Mike Fullerton on 5/7/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampOSX.h"

@interface FLErrorWindowController : NSWindowController {
@private
    IBOutlet NSTextField* _titleField;
    IBOutlet NSTextView* _explanationField;
    IBOutlet __weak NSButton* _okButton;
    NSString* _title;
    NSString* _explanation;

    IBOutlet NSView* _errorWindowView;
}
@property (readonly, weak, nonatomic) NSButton* okButton;

+ (id) errorWindowController:(NSString*) title explanation:(NSString*) explanation;

@end

@interface NSViewController (FLErrorWindowController)
- (void) showErrorAlert:(NSString*) title caption:(NSString*) caption error:(NSError*) error;
@end

@interface NSWindowController (FLErrorWindowController)
- (void) showErrorAlert:(NSString*) title caption:(NSString*) caption error:(NSError*) error;
@end
