//
//  FLAttributedStringController.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 4/30/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLAttributedStringController.h"
#import "FLSelectorPerforming.h"

@interface FLAttributedStringController ()
@property (readwrite, strong, nonatomic) NSDictionary* attributes;

@end


@implementation FLAttributedStringController

@synthesize delegate = _delegate;
@synthesize attributes = _attributes;
@synthesize displayState = _displayState;
@synthesize attributedString = _attributedString;

- (id) init {	
	self = [super init];
	if(self) {
		self.delegate = self;
   }
	return self;
}

#if FL_MRC
- (void) dealloc {
    [_attributedString release];
	[_attributes release];
	[super dealloc];
}
#endif

- (NSAttributedString*) attributedString {
    if(_attributedString && !_attributes) {
        NSRange range = NSMakeRange(0, _attributedString.length);

    // make new attributes, starting with old attributes
        self.attributes = FLMutableCopyWithAutorelease(
            [_attributedString attributesAtIndex:0 effectiveRange:&range]);

    // add attributes to dictionary
        [self addAttributesForState:self.displayState toDictionary:_attributes];

    // now update the string with new attributes
        self.attributedString = 
            FLAutorelease([[NSAttributedString alloc] initWithString:_attributedString.string 
                attributes:_attributes]);

    }
    return _attributedString;
}

- (void) setAttributedString:(NSAttributedString*) string {
    FLSetObjectWithRetain(_attributedString, string);
    self.attributes = nil;
    [self.delegate performOptionalSelector_fl:@selector(attributedStringControllerDidChangeString:) withObject:self];
}

- (void) setDisplayState:(FLStringDisplayState) displayState {
    if(_displayState != displayState) {
        _displayState = displayState;
        self.attributes = nil;
    }
}

- (NSString*) string {
    return _attributedString ? _attributedString.string : nil;
}

- (void) setString:(NSString*) string {
    if(FLStringsAreNotEqual(string, self.string)) {
        self.attributedString = [self attributedStringWithString:string];
    }
}

- (void) setAttributes:(NSDictionary*) attributes {
    FLSetObjectWithRetain(_attributes, attributes);
    [self.delegate performOptionalSelector_fl:@selector(attributedStringControllerDidChangeString:) withObject:self];
}

- (NSDictionary*) attributes {
    if(!_attributes) {
        self.attributes = [self attributesForState:self.displayState];
    }
    
    return _attributes;
}

- (void) attributedStringController:(FLAttributedStringController*) controller 
    setAttributesForDisplayState:(NSMutableDictionary*) attributes {
}

- (NSDictionary*) attributesForState:(FLStringDisplayState) state {
    NSMutableDictionary* attributes = [NSMutableDictionary dictionary];
    [self addAttributesForState:self.displayState toDictionary:attributes];
    return attributes;
}

- (void) addAttributesForState:(FLStringDisplayState) state 
                  toDictionary:(NSMutableDictionary*) dictionary {

    id delegate = self.delegate;
    if([delegate respondsToSelector:@selector(attributedStringController:addAttributesToDictionary:forDisplayState:)]) {
        [delegate attributedStringController:self addAttributesToDictionary:dictionary forDisplayState:self.displayState];
    }
}                  

- (NSAttributedString*) attributedString:(NSAttributedString*) string {
    NSRange range = NSMakeRange(0, string.length);
    NSMutableDictionary* attributes = FLMutableCopyWithAutorelease([string attributesAtIndex:0 effectiveRange:&range]);
    [self addAttributesForState:self.displayState toDictionary:attributes];
    
    return FLAutorelease([[NSAttributedString alloc] initWithString:string.string attributes:attributes]);
}

- (NSAttributedString*) attributedStringWithString:(NSString*) string {
    return FLAutorelease([[NSAttributedString alloc] initWithString:string attributes:self.attributes]);
}

@end
