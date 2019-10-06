//
//  FLPanelManager.h
//  FishLampCocoaUI
//
//  Created by Mike Fullerton on 3/3/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampOSX.h"
#import "FLFramedView.h"
#import "FLPanelViewController.h"
#import "FLViewTransition.h"
#import "FLOrderedCollection.h"
#import "FLPanelManagerState.h"

#import "NSViewController+FLErrorSheet.h"

@protocol FLPanelManagerDelegate;

typedef void (^FLPanelViewControllerBlock)(FLPanelViewController* panel);

@interface FLPanelManager : NSViewController {
@private
    FLOrderedCollection* _panels;
    id _selectedPanelIdentifier;
    
    FLViewTransition* _forwardTransition;
    FLViewTransition* _backwardTransition;
    
    IBOutlet NSView* _contentEnclosure;
    IBOutlet NSView* _contentView;
    
    BOOL _started;

    NSMutableArray* _panelViews;
    NSMutableArray* _panelAreas;
    
    id _panelManagerState;
    id _identifier;
}
@property (readwrite, strong, nonatomic) id identifier;
@property (readwrite, strong, nonatomic) id panelManagerState;

@property (readonly, assign, nonatomic) NSUInteger panelCount;
@property (readonly, strong, nonatomic) FLPanelViewController* selectedPanel;
@property (readonly, strong, nonatomic) id selectedPanelIdentifier;

@property (readwrite, strong, nonatomic) FLViewTransition* forwardTransition;
@property (readwrite, strong, nonatomic) FLViewTransition* backwardTransition;

- (void) showPanelsInWindow:(NSWindow*) window;

- (void) showPanelsInView:(NSView*) window;

- (void) addPanel:(FLPanelViewController*) panel;
- (void) addPanel:(FLPanelViewController*) panel forIdentifier:(id) identifier;
- (void) addPanel:(FLPanelViewController*) panel withDelegate:(id) delegate;
- (void) addPanel:(FLPanelViewController*) panel forIdentifier:(id) identifier withDelegate:(id) delegate;

- (id) panelForIdentifier:(id) identifier;

- (void) removePanelForIdentifier:(id) identifier;

- (BOOL) canSelectPanelForIdentifier:(id) identifier;

- (void) setPanelHidden:(BOOL) hidden withIdentifier:(id) identifier;

//
// panel switching
//
- (void) selectNextPanelAnimated:(BOOL) animated
                    completion:(void (^)(FLPanelViewController*)) completion;

- (void) selectPreviousPanelAnimated:(BOOL) animated
                        completion:(void (^)(FLPanelViewController*)) completion;

- (void) selectPanelForIdentifier:(id) identifier 
                       animated:(BOOL) animated
                     completion:(FLPanelViewControllerBlock) completion;

- (BOOL) isPanelSelected:(id) identifier;

- (BOOL) isFirstPanelSelected;

- (BOOL) isLastPanelSelected;

// panel views

- (void) addPanelView:(NSView*) panelView 
               toView:(NSView*) superview 
             animated:(BOOL) animated;

- (void) removePanelViews:(BOOL) animated;

// panel areas

- (void) addPanelArea:(id<FLPanelArea>) area;

// optional overrides
- (void) showFirstPanel;

- (void) willShowPanel:(FLPanelViewController*) panel;
- (void) willHidePanel:(FLPanelViewController*) panel;
- (void) didShowPanel:(FLPanelViewController*) panel;
- (void) didHidePanel:(FLPanelViewController*) panel;
- (void) panelStateDidChange:(FLPanelViewController*) panel;
- (void) didAddPanel:(FLPanelViewController*) panel;
- (void) didRemovePanel:(FLPanelViewController*) panel;
- (void) panelManagerWillStart;
- (void) panelManagerDidStart;

- (void) showAlertView:(NSViewController*) toShow
    overViewController:(NSViewController*) toHide
        withTransition:(FLViewTransition*) transition 
            completion:(dispatch_block_t) completion;



@end

@interface FLPanelManager ()
- (void) panelDidChangeCanOpenValue:(FLPanelViewController*) panel;
@end