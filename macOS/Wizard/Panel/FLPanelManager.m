//
//  FLPanelManager.m
//  FishLampCocoaUI
//
//  Created by Mike Fullerton on 3/3/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLPanelManager.h"
#import "FLWizardStyleViewTransition.h"

#import "FLCompatibility.h"
#import "FLViewTransition.h"
#import "FishLampSimpleLogger.h"
#import "FLGeometry.h"

@interface FLPanelViewController()
@property (readwrite, assign, nonatomic, getter=isSelected) BOOL selected;
@end

@interface FLPanelViewController(FLPanelManager)
- (void) prepareToBeShown;
- (void) prepareToBeHidden;
@end

@implementation FLPanelViewController (FLPanelManager)

- (void) applicationWillTerminate:(id) sender {
    [self panelWillDisappear];
    [self panelDidDisappear];
}

- (void) prepareToBeShown {
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(applicationWillTerminate:)
                                                 name: NSApplicationWillTerminateNotification
                                                 object:[NSApplication sharedApplication]];
}

- (void) prepareToBeHidden {
    @try {
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:NSApplicationWillTerminateNotification
                                                      object:[NSApplication sharedApplication]];
    }
    @catch(NSException* ex) {
        // don't care
    }
}

@end

@interface FLPanelManager ()
@property (readonly, strong, nonatomic) FLOrderedCollection* panels;
@property (readwrite, strong, nonatomic) id selectedPanelIdentifier;

- (void) showPanelAtIndex:(NSUInteger) idx 
                 animated:(BOOL) animated
               completion:(FLPanelViewControllerBlock) completion;

@end

@implementation FLPanelManager

@synthesize panelManagerState = _panelManagerState;

@synthesize selectedPanelIdentifier = _selectedPanelIdentifier;
@synthesize panels = _panels;
@synthesize forwardTransition = _forwardTransition;
@synthesize backwardTransition = _backwardTransition;
@synthesize identifier = _identifier;

- (void) dealloc {
#if __MAC_10_8
    [self.view removeObserver:self forKeyPath:@"frame" context:nil];
#else 
    [self.view removeObserver:self forKeyPath:@"frame"];
#endif

#if FL_MRC
    [_identifier release];
    [_panelManagerState release];
    [_selectedPanelIdentifier release];
    [_panelAreas release];
    [_backwardTransition release];
    [_forwardTransition release];
    [_panelViews release];
    [_panels release];
    [super dealloc];
#endif
}

- (void) awakeFromNib {
    [super awakeFromNib];
     
    if(!_panelAreas) {
        _panelAreas = [[NSMutableArray alloc] init];
        _panels = [[FLOrderedCollection alloc] init];
        _started = NO;

        self.forwardTransition = [FLWizardStyleForwardTransition wizardStyleForwardTransition];
        self.backwardTransition = [FLWizardStyleBackwardTransition wizardStyleBackwardTransition];
        
        _contentEnclosure.autoresizesSubviews = YES;
        _contentView.autoresizesSubviews = NO;
        
        [self.view addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
        self.view.autoresizesSubviews = YES;
        
        _panelManagerState = [[FLPanelManagerState alloc] init];
    }
}

- (NSUInteger) panelCount {
    return _panels.count;
}

- (NSUInteger) currentPanelIndex {
    return _selectedPanelIdentifier ? [_panels indexForKey:_selectedPanelIdentifier] : NSNotFound;
}

- (void) setPanelFrame:(FLPanelViewController*) panel {

    NSRect bounds = _contentView.bounds;
    if(panel.panelFillsView) {
        panel.view.frame = _contentView.bounds;
    }
    else {
        NSRect frame = NSRectCenterRectInRectHorizontally(_contentView.bounds, panel.view.frame);
        frame.origin.y = NSRectGetBottom(bounds) - frame.size.height - 60.0f; // = FLRectCenterRectInRectVertically(bounds, frame);
        panel.view.frame = NSRectOptimizedForViewLocation(frame);
    }
    
//    FLDebugLog(@"panel frame view %@", NSStringFromRect(panel.view.frame));

}

- (void) panelDidChangeCanOpenValue:(FLPanelViewController*) panel {
    [self panelStateDidChange:panel];
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if(FLStringsAreEqual(keyPath, @"frame")) {
        [self setPanelFrame:self.selectedPanel];
        
//        FLDebugLog(@"wizard view %@, encl view: %@, content view: %@", NSStringFromRect(self.view.frame), NSStringFromRect(_contentEnclosure.frame), NSStringFromRect(_contentView.frame));
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void) addPanel:(FLPanelViewController*) panel {
    FLAssertNotNil(panel);

    [self addPanel:panel forIdentifier:[[panel class] panelIdentifier] withDelegate:self];
}

- (void) addPanel:(FLPanelViewController*) panel withDelegate:(id) delegate {
    FLAssertNotNil(panel);
    FLAssertNotNil(delegate);

    [self addPanel:panel forIdentifier:[[panel class] panelIdentifier] withDelegate:delegate];
}

- (void) addPanel:(FLPanelViewController*) panel forIdentifier:(id) identifier withDelegate:(id) delegate {

    FLAssertNotNil(identifier);
    FLAssertNotNil(panel);
    FLAssertNotNil(delegate);

    panel.identifier = identifier;
    [panel setDelegate:delegate];

    [panel view]; // make sure it's loaded from nib

    FLTrace(@"Added Panel: %@ for identifier: %@", [panel description], [identifier description]);
    
//    panel.view.wantsLayer = YES;
    [panel didMoveToPanelManager:self];
    [_panels setObject:panel forKey:identifier];
    [self didAddPanel:panel];
    [self panelStateDidChange:panel];
    
}

- (void) setPanelHidden:(BOOL) hidden 
         withIdentifier:(id) identifier {

    FLPanelViewController* panel = [self panelForIdentifier:identifier];
    panel.hidden = hidden;
    [self panelStateDidChange:panel];
}

- (void) addPanel:(FLPanelViewController*) panel forIdentifier:(id) identifier {
    [self addPanel:panel forIdentifier:identifier withDelegate:nil];
}

- (void) removePanelForIdentifier:(id) identifier {
    FLPanelViewController* panel = [self panelForIdentifier:identifier];
    [_panels removeObject:panel];
    [panel didMoveToPanelManager:nil];
    [self didRemovePanel:panel];
    [self panelStateDidChange:panel];
}

- (FLPanelViewController*) selectedPanel {
    return _started ? [_panels objectForKey:_selectedPanelIdentifier] : nil;
}

- (BOOL) canSelectPanelForIdentifier:(id) identifier {
    if(!_started) {
        return NO;
    }
    
    NSUInteger idx = [_panels indexForKey:identifier];
    if(idx == NSNotFound) {
        return NO;
    }
    
    FLPanelViewController* currentPanel = [_panels objectForKey:identifier];
    if([currentPanel isHidden]) {
        return NO;
    }
    
    if([currentPanel isIndependent]) {
        return [currentPanel isEnabled];
    }
    
    NSUInteger currentIdx = [self currentPanelIndex];
    if(idx <= currentIdx) {
        return [currentPanel isEnabled];
    }
       
    for(NSUInteger i = currentIdx; i < idx; i++) {
        FLPanelViewController* panel = [_panels objectAtIndex:i];
        if(panel.isHidden) {
            continue;
        }
        if(panel.canOpenNextPanel == NO) {
            return NO;
        }
    }

    return [currentPanel isEnabled];
}

- (id) panelForIdentifier:(id) identifier {
    return [_panels objectForKey:identifier];
}

- (void) selectNextPanelAnimated:(BOOL) animated
                    completion:(void (^)(FLPanelViewController*)) completion {
                    
    NSUInteger nextIndex = [self currentPanelIndex] + 1;
    while(nextIndex < _panels.count) {
        
        if(![[_panels objectAtIndex:nextIndex] isHidden]) {
            [self showPanelAtIndex:nextIndex
                      animated:animated 
                    completion:completion];
            break;
        }

        ++nextIndex;
    }

}

- (void) selectPreviousPanelAnimated:(BOOL) animated
                        completion:(void (^)(FLPanelViewController*)) completion {

    NSInteger prevIndex = [self currentPanelIndex] - 1;
    
    while(prevIndex >= 0) {
    
        if(![[_panels objectAtIndex:prevIndex] isHidden]) {
            [self showPanelAtIndex:prevIndex 
                          animated:animated 
                        completion:completion];
        
            break;
        }
    
        --prevIndex;
    }
}       

- (void) didShowPanel:(FLPanelViewController*) toShow 
         didHidePanel:(FLPanelViewController*) toHide {

    if(toHide) {
        [toHide.view removeFromSuperview];
        [self didHidePanel:toHide];
        [toHide panelDidDisappear];
    }

    for(id panelArea in _panelAreas) {
        if(toHide) { 
            FLPerformSelector1(panelArea, @selector(panelDidDisappear:), toHide);
        }
        FLPerformSelector1(panelArea, @selector(panelDidAppear:), toShow);
    }
    [toShow setNextResponder:self];
    [self.view.window makeFirstResponder:toShow];

    [self.panelManagerState setSelectedPanelIdentifier:toShow.identifier];
    [self.panelManagerState setSelectedPanelSavedState:nil];
    
    [toShow panelDidAppear];
    [self didShowPanel:toShow];
}                                          

#define ANIMATED 1

- (void) showPanelAtIndex:(NSUInteger) idx 
                 animated:(BOOL) animated
               completion:(FLPanelViewControllerBlock) completion {
    
#if __MAC_10_8
    NSUInteger currentIdx = [self currentPanelIndex];
#endif
    
    FLPanelViewController* toShow = [_panels objectAtIndex:idx];
    FLAssertNotNil(toShow);
    
    FLPanelViewController* toHide = [self selectedPanel];

    // make sure they're loaded from nib.
    [toShow view];
    [toHide view];

    if(toShow == toHide) {
        if(toShow.view.superview != nil) {
            // already showing. just return.
            if(completion) {
                completion(toShow);
            }
            return;
        }
        else {
            toHide = nil;
        }
    }
    
    _started = YES;

    toHide.selected = NO;
    toShow.selected = YES;
    if([toHide alertViewController]) {
        [[toHide.alertViewController view] removeFromSuperview];
        toHide.alertViewController = nil;
    }
    

#if BROKEN
    FLViewTransition* transition = nil;
    NSUInteger currentIdx = [self currentPanelIndex]

    CGFloat animationDuration = 0.0f;
    if(animated) {
        if(idx > currentIdx) {
            transition = self.forwardTransition;
        }
        else {
            transition = self.backwardTransition;
        }
    }
        
    if(transition) {
        animationDuration = [transition duration];
    }
#endif

    [self removePanelViews:animated];

    [self setPanelFrame:toShow];

    if(toHide) {
        [toHide prepareToBeHidden];
        [toHide panelWillDisappear];
        [self willHidePanel:toHide];

        for(id panelArea in _panelAreas) {
            FLPerformSelector1(panelArea, @selector(panelWillDisappear:), toHide);
        }
    }

    [self willShowPanel:toShow];

    self.selectedPanelIdentifier = [_panels keyAtIndex:idx];
    
    [_contentView addSubview:[toShow view]];
    [toShow prepareToBeShown];
    [toShow panelWillAppear];
    for(id panelArea in _panelAreas) {
        FLPerformSelector1(panelArea, @selector(panelWillAppear:), toShow);
    }
    
    [self.view.window makeFirstResponder:self];

    [self panelStateDidChange:toHide];
    [self panelStateDidChange:toShow];

#if __MAC_10_8
    if(animated && toHide != nil && OSXVersionIsAtLeast10_8()) {
        completion = FLCopyWithAutorelease(completion);

        NSRect toShowFromFrame = toShow.view.frame;
        NSRect toShowToFrame = toShowFromFrame;
        
        NSRect toHideToFrame = toHide.view.frame;
        NSRect toHideFromFrame = toHideToFrame;
        
        NSRect bounds = _contentView.bounds;
        
        CGFloat offLeft = bounds.origin.x - bounds.size.width;
        CGFloat offRight = NSRectGetRight(bounds);
        
        if(idx > currentIdx) {
            toShowFromFrame.origin.x = offRight;
            toHideToFrame.origin.x = offLeft;
        }
        else {
            toShowFromFrame.origin.x = offLeft;
            toHideToFrame.origin.x = offRight;
        }

        toShow.view.frame = toShowFromFrame;
        
        [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context){
            [context setDuration: 0.25];
            [context setTimingFunction: [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseIn]];
            [[toShow.view animator] setFrame:toShowToFrame];
            [[toHide.view animator] setFrame:toHideToFrame];
        } completionHandler:^{
            [self didShowPanel:toShow didHidePanel:toHide];
            toHide.view.frame = toHideFromFrame;
            
            if(completion) {
              completion(toShow);
            }

            [self.view setNeedsDisplay:YES];
        }];
    }
    else {
    
#else
    {
#endif
        [self didShowPanel:toShow didHidePanel:toHide];
            
        if(completion) {
            completion(toShow);
        }
    }
}      

- (void) showFirstPanel {
    [self showPanelAtIndex:0 animated:NO completion:nil];
}

- (void) selectPanelForIdentifier:(id) identifier 
                       animated:(BOOL) animated
                     completion:(FLPanelViewControllerBlock) completion {

    NSInteger idx = [_panels indexForKey:identifier];
    FLAssert(idx != NSNotFound);
    
    if(idx != NSNotFound) {
        [self showPanelAtIndex:idx
                      animated:YES 
                    completion:completion];
    }
}    

- (BOOL) isFirstPanelSelected {
    return _started && self.currentPanelIndex == 0;
}

- (BOOL) isLastPanelSelected {
    return _started && self.currentPanelIndex == (_panels.count - 1);
}
          
- (void) addPanelView:(NSView*) panelView toView:(NSView*) superview animated:(BOOL) animated {

// TODO: animate
//    panelView.wantsLayer = YES;
    if(!_panelViews) {
        _panelViews = [[NSMutableArray alloc] init];
    }
    [_panelViews addObject:panelView];
    [superview addSubview:panelView];
}

- (void) removePanelViews:(BOOL) animated {

// TODO: animate

    for(NSView* view in _panelViews) {
        [view removeFromSuperview];
    }

    [_panelViews removeAllObjects];
}

- (void) addPanelArea:(id<FLPanelArea>) area {
    [_panelAreas addObject:area];
}

- (void) willShowPanel:(FLPanelViewController*) panel {
}

- (void) willHidePanel:(FLPanelViewController*) panel {
}

- (void) didShowPanel:(FLPanelViewController*) panel {
}

- (void) didHidePanel:(FLPanelViewController*) panel {
}

- (void) panelStateDidChange:(FLPanelViewController*) panel {
}

- (void) didAddPanel:(FLPanelViewController*) panel {
}

- (void) didRemovePanel:(FLPanelViewController*) panel {
}

- (BOOL) isPanelSelected:(id) identifier {
    return [[self panelForIdentifier:identifier] isSelected];
}
//
//- (BOOL) setFirstResponder {
//    [self.view.window makeFirstResponder:[self selectedPanel]];
//    return YES;
//}
//
//- (BOOL) acceptsFirstResponder {
//    return YES;
//}

- (void) startPanelManager {
    [self setNextResponder:self.view.window];
    [self panelManagerWillStart];
    [self showFirstPanel];  
    [self panelManagerDidStart];
}

- (void) showPanelsInWindow:(NSWindow*) window {
    [window setContentView:self.view];
//    [window setInitialFirstResponder:self.view];
    [self startPanelManager];
}

- (void) showPanelsInView:(NSView*) view {
    self.view.frame = view.bounds;
    [view addSubview:self.view];
    [self startPanelManager];
}
- (void) panelManagerWillStart {
}
- (void) panelManagerDidStart {
}

- (void) showAlertView:(NSViewController*) toShow
    overViewController:(NSViewController*) toHide
        withTransition:(FLViewTransition*) transition 
            completion:(dispatch_block_t) completion {
    
    [_contentView addSubview:[toShow view]];

    FLPrepareBlockForFutureUse(completion);

    if(transition) {

        [transition startShowingView:toShow.view 
                          viewToHide:toHide.view 
                          completion:^{

            
            [toHide.view removeFromSuperview];
              
            dispatch_async(dispatch_get_main_queue(), ^{
                if(completion) {
                    completion();
                }
            });
        }];
    }
    else {
            
        [toHide.view removeFromSuperview];

        dispatch_async(dispatch_get_main_queue(), ^{
            if(completion) {
                completion();
            }
        });

    }

    
}               

- (void) hideAlertView {

}



@end


//        FLSlideInAndDropTransition* transition = 
//            [FLSlideInAndDropTransition transitionWithViewToShow:[toShow view] 
//                                                      viewToHide:toHide ? [toHide view] : nil];

                             
//- (void) hidePanelAnimated:(BOOL) animated 
//                            hide:(FLPanelViewController*) toHide
//                            show:(FLPanelViewController*) toShow
//                      completion:(FLPanelViewControllerBlock) completion {                            
//
//    FLAssertNotNil(toShow);
//
//    [self setFirstResponder];
//    [self setPanelFrame:toShow];
//    [self willHidePanel:toHide willShowPanel:toShow];
//            
//    completion = FLCopyWithAutorelease(completion);
//    [self.view addSubview:[toShow view]];
//        
//    dispatch_block_t finished = ^{
//        [self didHidePanel:toHide didShowPanel:toShow];
//         
//        if(completion) {
//            completion(toShow);
//        }        
//        [self.view.window display];
//    };
//      
//    if(0 && animated) {
//
//        FLSlideInAndDropTransition* transition = 
//            [FLSlideInAndDropTransition transitionWithViewToShow:[toShow view] 
//                                                      viewToHide:toHide ? [toHide view] : nil];
//
//        
////        FLWizardStyleViewTransition* transition = 
////            [FLWizardStyleViewTransition transitionWithViewToShow:[toShow view] 
////                                                              viewToHide:toHide != nil ? [toHide view] : nil];
//
//        [transition startAnimating:^{
//            finished();
//        }];
//    }
//    else {
//        [toHide.view removeFromSuperview];
//        finished();
//    }
//}
