//
//	FLRectLayout.h
//	FishLamp
//
//	Created by Mike Fullerton on 2/13/10.
//	Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//
#import "FishLampCore.h"
#import "FLEdgeInsets.h"

typedef enum {
	FLRectLayoutVerticalNone		  = 0,
	FLRectLayoutVerticalTop			= 10,
	FLRectLayoutVerticalTopThird,
	FLRectLayoutVerticalBottomThird,
	FLRectLayoutVerticalCentered,
	FLRectLayoutVerticalBottom,
	FLRectLayoutVerticalFill,
    FLRectLayoutVerticalFit
} FLRectLayoutVertical;

typedef enum { 
	FLRectLayoutHorizontalNone		  = 0,
	FLRectLayoutHorizontalLeft,
	FLRectLayoutHorizontalLeftThird,
	FLRectLayoutHorizontalLeftQuarter,
	FLRectLayoutHorizontalCentered,
	FLRectLayoutHorizontalRight,
	FLRectLayoutHorizontalRightThird,
	FLRectLayoutHorizontalRightQuarter,
	FLRectLayoutHorizontalFill,
    FLRectLayoutHorizontalFit
} FLRectLayoutHorizontal;

typedef struct FLRectLayout { 
	FLRectLayoutHorizontal horizontal:16;
	FLRectLayoutVertical vertical:16;
	FLEdgeInsets insets;
} FLRectLayout;

extern const FLRectLayout FLRectLayoutNone;
extern const FLRectLayout FLRectLayoutFill;
extern const FLRectLayout FLRectLayoutAspectFit;
extern const FLRectLayout FLRectLayoutCentered;
extern const FLRectLayout FLRectLayoutCenteredTop;
extern const FLRectLayout FLRectLayoutCenteredBottom;

extern BOOL FLRectLayoutsAreEqual(FLRectLayout lhs,
                                   FLRectLayout rhs);

extern FLRectLayout FLRectLayoutMake(FLRectLayoutHorizontal horizontalLayout,
                                       FLRectLayoutVertical verticalLayout);

extern FLRectLayout FLRectLayoutMakeWithInsets(FLRectLayoutHorizontal horizontalLayout,
                                                 FLRectLayoutVertical verticalLayout,
                                                 FLEdgeInsets insets);

extern FLRectLayout FLRectLayoutSetVertical(FLRectLayout rectLayout,
                                              FLRectLayoutVertical vertical);

extern FLRectLayout FLRectLayoutSetHorizontal(FLRectLayout rectLayout,
                                                FLRectLayoutHorizontal horizontal);

extern BOOL FLRectLayoutIsValid(FLRectLayout loc);

extern BOOL FLRectLayoutNotNone(FLRectLayout loc);

// FLRect


    
