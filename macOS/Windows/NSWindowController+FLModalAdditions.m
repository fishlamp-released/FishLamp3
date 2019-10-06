//
//  NSWindowController+FLModalAdditions.m
//  FishLampOSX
//
//  Created by Mike Fullerton on 4/17/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "NSWindowController+FLModalAdditions.h"

@implementation NSViewController (FLModalAdditions)

- (FLSheetHandler*) showModalWindow:(NSWindowController*) windowController 
                  withDefaultButton:(NSButton*) button
                   finishedBlock:(FLSheetHandlerBlock) finishedBlock {
    
    return [self.view.window showModalWindow:windowController withDefaultButton:button finishedBlock:finishedBlock];
}

- (FLSheetHandler*) showModalWindow:(NSWindowController*) windowController
            finishedBlock:(FLSheetHandlerBlock) finishedBlock {
    
    return [self.view.window showModalWindow:windowController withDefaultButton:nil finishedBlock:finishedBlock];
}

@end

@implementation NSWindowController (NSModalAdditions)

- (NSButton*) closeModalWindowButton {
    return nil;
}
@end

@implementation NSWindow (NSModalAdditions)

- (IBAction) closeModalWindow:(id) sender {
    [[NSApplication sharedApplication] endSheet:self];
}

- (FLSheetHandler*) showModalWindow:(NSWindowController*) modalWindow 
                  withDefaultButton:(NSButton*) button
                      finishedBlock:(FLSheetHandlerBlock) finishedBlock {


    FLAssertNotNil(modalWindow);

    FLSheetHandler* handler = [FLSheetHandler sheetHandler];
    handler.modalWindowController = modalWindow;
    handler.defaultButton = button;
    handler.hostWindow = self;
    handler.appModal = YES;
    handler.finishedBlock = finishedBlock;
    [handler beginSheet];
    return handler;
}

- (FLSheetHandler*) showModalWindow:(NSWindowController*) modalWindow
                      finishedBlock:(FLSheetHandlerBlock) finishedBlock {
    return [self showModalWindow:modalWindow withDefaultButton:nil finishedBlock:finishedBlock];
}

@end

@interface FLSheetHandler ()
@property (readwrite, assign, nonatomic) NSModalSession modalSession;
@end

@implementation FLSheetHandler 
@synthesize modalSession = _modalSession;
@synthesize modalWindow = _modalWindow;
@synthesize modalWindowController = _modalWindowController;
@synthesize hostWindow = _hostWindow;
@synthesize appModal = _appModal;
@synthesize defaultButton = _defaultButton;
@synthesize finishedBlock = _finishedBlock;

+ (id) sheetHandler {
    return FLAutorelease([[[self class] alloc] init]);
}

#if FL_MRC
- (void) dealloc {
    [_finishedBlock release];
    [_modalWindow release];
    [_modalWindowController release];
    [_hostWindow release];
    [_defaultButton release];
    [super dealloc];
}
#endif

- (void) finish {
    if(_modalSession) {
        [NSApp endModalSession:_modalSession];
        _modalSession = nil;
    }
    [_modalWindow orderOut:self];


    [_hostWindow makeFirstResponder:nil];

    self.hostWindow = nil;
    self.modalWindow = nil;
    self.modalWindowController = nil;
    self.modalSession = nil;

    if(self.finishedBlock) {
        self.finishedBlock();
        self.finishedBlock = nil;
    }
}

- (void) sheetDidEnd:(NSWindow*) sheet 
         returnCode:(NSInteger)returnCode 
        contextInfo:(void*)contextInfo {

    FLSheetHandler* handler = FLAutorelease(FLBridgeTransfer(FLSheetHandler*, contextInfo));
    [handler finish];
}

- (void) beginSheet {

    if(!self.modalWindow && self.modalWindowController) {
        self.modalWindow = self.modalWindowController.window;
    }

    FLAssertNotNil(self.hostWindow, @"host window not set");
    FLAssertNotNil(self.modalWindow, @"modal window or modal window controller not set");

    [[NSApplication sharedApplication] beginSheet:self.modalWindow
                                   modalForWindow:self.hostWindow
                                    modalDelegate:self 
                                   didEndSelector:@selector(sheetDidEnd:returnCode:contextInfo:) 
                                      contextInfo:FLBridgeRetain(void*, self)];

    self.modalWindow.nextResponder = self.hostWindow;
    [self.hostWindow makeFirstResponder:[self.modalWindow initialFirstResponder]];

    if(self.appModal) {
        self.modalSession = [NSApp beginModalSessionForWindow:_hostWindow];
        [NSApp runModalSession:self.modalSession];
    }

    if(!self.defaultButton) {
        self.defaultButton = [self.modalWindowController closeModalWindowButton];
    }
    
    if(self.defaultButton) {
        [self.defaultButton setTarget:self.modalWindow];
        [self.defaultButton setAction:@selector(closeModalWindow:)];
    }
}


@end

