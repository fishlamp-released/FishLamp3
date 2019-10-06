//
//  FLPanelViewController.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 12/7/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton.. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//
#import "FLPanelViewController.h"
#import "FLWizardViewController.h"

@interface FLPanelViewController ()
@property (readwrite, assign, nonatomic, getter=isSelected) BOOL selected;
@end

@implementation FLPanelViewController

@synthesize panelManager = _panelManager;
@synthesize prompt = _prompt;
@synthesize canOpenNextPanel = _canOpenNextPanel;
@synthesize buttons = _buttons;
@synthesize header = _header;
@synthesize panelFillsView = _panelFillsView;
@synthesize authenticated = _authenticated;
@synthesize delegate = _delegate;
@synthesize independent = _independent;
@synthesize hidden = _hidden;
@synthesize enabled = _enabled;
@synthesize identifier = _identifier;
@synthesize alertViewController = _alertViewController;
@synthesize selected = _selected;


- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
#if FL_MRC
    [_alertViewController release];
    [_identifier release];
    [_header release];
    [_buttons release];
    [_prompt release];
    [super dealloc];
#endif
}

//- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if(self) {
//        [self view]; // force it to load
//    }
//
//    return self;
//}

- (void) awakeFromNib {
    [super awakeFromNib];
    self.canOpenNextPanel = NO;
    self.panelFillsView = YES;
    self.independent = NO;
    self.enabled = YES;
    self.hidden = NO;
    
    self.identifier = [[self class] panelIdentifier];
}

- (BOOL) isSelectable {
    return [[self panelManager] canSelectPanelForIdentifier:self.identifier];
}

- (void) updateState:(id) state {
    [[self.panelManager panelManagerState] setSelectedPanelSavedState:state];
}

- (BOOL)acceptsFirstResponder {
    return YES;
}

- (BOOL)becomeFirstResponder {
    return YES;
}

- (BOOL)resignFirstResponder {
    return YES;
}

- (void) panelWillAppear {
}

- (void) applicationWillTerminate {
}

- (void) appWillTerminate:(id) note {
    [self applicationWillTerminate];
}

- (void) panelDidAppear {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillTerminate:) name:NSApplicationWillTerminateNotification object:nil];
}

- (void) panelWillDisappear {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSApplicationWillTerminateNotification object:nil];
}

- (void) panelDidDisappear {
}

- (void) respondToOtherButton:(BOOL*) handledIt {
}

- (void) respondToNextButton:(BOOL*) handledIt {
}

- (void) respondToBackButton:(BOOL*) handledIt {
}

- (void) addPanelView:(NSView*) panelView toPanelArea:(id<FLPanelArea>) panelArea animated:(BOOL) animated {
    [_panelManager addPanelView:panelView toView:panelArea.contentView animated:animated];
}

- (void) didMoveToPanelManager:(FLPanelManager*) manager {
    _panelManager = manager;
    
    if(!_panelManager) {
        self.buttons = nil;
        self.header = nil;
    }
}

- (void) showErrorAlert:(NSString*) title caption:(NSString*) caption error:(NSError*) error {
    [self.panelManager showErrorAlert:title caption:caption error:error];
}

//- (void) showAlertWithError:(NSError*) error {
//    [self showAlertWithError:error withTitle:nil withCaption:nil];
//}
//
//- (void) showAlertWithError:(NSError*) error withTitle:(NSString*) title {
//    [self showAlertWithError:error withTitle:title withCaption:nil];
//}
//
//- (void) showAlertWithError:(NSError*) error withTitle:(NSString*) title withCaption:(NSString*) caption {
//    [self showErrorAlert:title caption:caption error:error];
//}
//
//
//- (void) showErrorAlert:(NSString*) title caption:(NSString*) caption error:(NSError*) error {
//    [self showErrorAlert:title caption:caption error:error];
//}
//
//- (void) didHideAlertWithError:(NSError*) error {
//}

- (void) setCanOpenNextPanel:(BOOL)canOpenNextPanel {
    if(canOpenNextPanel != _canOpenNextPanel) {
        _canOpenNextPanel = canOpenNextPanel;
        [_panelManager panelDidChangeCanOpenValue:self];
    }
}

+ (id) panelIdentifier {
    return NSStringFromClass([self class]);
}

@end
