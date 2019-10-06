//
//  FLBreadcrumbBarView.h
//  FishLampCocoaUI
//
//  Created by Mike Fullerton on 1/15/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampOSX.h"

#import "FLAttributedString.h"
#import "FLOrderedCollection.h"
#import "FLMouseTrackingView.h"
#import "FLNavigationTitle.h"
#import "FLBarHighlightBackgoundLayer.h"

@class FLNavigationTitle;
@protocol FLBreadcrumbBarViewDelegate;

@interface FLBreadcrumbBarView : FLMouseTrackingView  {
@private
    NSMutableArray* _titles;
    FLBarHighlightBackgoundLayer* _highlightLayer;
    CGFloat _titleTop;
    __weak id<FLBreadcrumbBarViewDelegate> _delegate;
}
@property (readonly, strong, nonatomic) NSArray* titles;
@property (readonly, strong, nonatomic) FLBarHighlightBackgoundLayer* highlightLayer;
@property (readwrite, assign, nonatomic) CGFloat titleTop;

@property (readwrite, weak, nonatomic) id<FLBreadcrumbBarViewDelegate> delegate;

- (void) addTitle:(FLNavigationTitle*) title;
- (void) updateLayout:(BOOL) animated;

@end

@protocol FLBreadcrumbBarViewDelegate <NSObject>
- (void) titleNavigationController:(FLBreadcrumbBarView*) view handleMouseDownInTitle:(FLNavigationTitle*) title;
- (void) titleNavigationController:(FLBreadcrumbBarView*) view handleMouseMovedInTitle:(FLNavigationTitle*) title mouseIn:(BOOL) mouseIn;
@end
