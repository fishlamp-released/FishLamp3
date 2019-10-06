//
//  NSViewController+FLErrorSheet.m
//  FishLampOSX
//
//  Created by Mike Fullerton on 4/18/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "NSViewController+FLErrorSheet.h"
#import "FLLocalNotification.h"

@implementation NSViewController (FLErrorSheet)

- (void) didHideErrorAlertForError:(NSError*) error {
    [self.view.window makeFirstResponder:self];
}

- (void)didPresentErrorWithRecovery:(BOOL)didRecover contextInfo:(void *)contextInfo {
    
    NSError* error = FLAutorelease(FLBridgeTransfer(NSError*, contextInfo));

    [self didHideErrorAlertForError:error];
}

- (void) showErrorAlert:(NSString*) title caption:(NSString*) caption error:(NSError*) error {

    FLAssertNotNil(error);

    if(error.isCancelError) {
        return;
    }

    NSError* theError = error;

    if(!title) {
        title = NSLocalizedString(@"An error occurred.", nil); 
    }
    
    NSMutableString* errorString = [NSMutableString stringWithString:title];
    
    if(FLStringIsNotEmpty(title)) {
        [errorString appendFormat:@"\n\n"];
    }
    
    if(caption) {
        [errorString appendFormat:@"%@\n", caption];
    } 
    else {
        [errorString appendFormat:@"%@\n", [error localizedDescription]];
    }
    
    theError = [NSError errorWithDomain:error.domain code:error.code localizedDescription:errorString];

    NSBeep();
    
    void* context = FLBridgeRetain(void*, error);
    
    [self presentError:theError modalForWindow:self.view.window delegate:self didPresentSelector:@selector(didPresentErrorWithRecovery:contextInfo:) contextInfo:context];
        
    if(![[NSApplication sharedApplication] isActive]) {
#if __MAC_10_8
        FLLocalNotification* notification = [FLLocalNotification localNotificationWithName:title];
//        notification.subtitle = @"Please try again";
        [notification deliverNotification];
#endif
        
        [NSApp requestUserAttention:NSCriticalRequest];
    }
}


@end
