//
//  FLAttributedStringController.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 4/30/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampCore.h"

typedef enum {
    FLStringDisplayStateDisabled,
    FLStringDisplayStateEnabled,
    FLStringDisplayStateHighlighted,
    FLStringDisplayStateSelected,
    FLStringDisplayStateHovering,
    FLStringDisplayStateMouseDownIn,
    FLStringDisplayStateMouseDownOut
} FLStringDisplayState;

@class FLAttributedStringController;

@protocol FLAttributedStringControllerDelegate <NSObject, FLPerformer>
@optional

- (void) attributedStringController:(FLAttributedStringController*) controller 
          addAttributesToDictionary:(NSMutableDictionary*) attr 
                    forDisplayState:(FLStringDisplayState) displayState;
    
- (void) attributedStringControllerDidChangeString:(FLAttributedStringController*) controller;

                                              
@end

@interface FLAttributedStringController : NSObject<FLAttributedStringControllerDelegate> {
@private
    FLStringDisplayState _displayState;
    NSMutableDictionary* _attributes;
    __unsafe_unretained id<FLAttributedStringControllerDelegate> _delegate;
    NSAttributedString* _attributedString;
}
@property (readwrite, assign, nonatomic) id<FLAttributedStringControllerDelegate> delegate;

@property (readwrite, strong, nonatomic) NSAttributedString* attributedString;
@property (readwrite, strong, nonatomic) NSString* string;

@property (readwrite, assign, nonatomic) FLStringDisplayState displayState;
@property (readonly, strong, nonatomic) NSDictionary* attributes;

- (NSAttributedString*) attributedString:(NSAttributedString*) string;
- (NSAttributedString*) attributedStringWithString:(NSString*) string;

- (NSDictionary*) attributesForState:(FLStringDisplayState) state;
- (void) addAttributesForState:(FLStringDisplayState) state 
                  toDictionary:(NSMutableDictionary*) dictionary;

@end


