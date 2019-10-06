//
//  NSViewController+FLErrorSheet.h
//  FishLampOSX
//
//  Created by Mike Fullerton on 4/18/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import <Cocoa/Cocoa.h>
#import "FishLampOSX.h"

@interface NSViewController (FLErrorSheet)
- (void) showErrorAlert:(NSString*) title caption:(NSString*) caption error:(NSError*) error;
- (void) didHideErrorAlertForError:(NSError*) error;
@end
