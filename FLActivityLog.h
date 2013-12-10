//
//  FLActivityLog.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 3/2/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampMinimum.h"
#import "FLStringFormatter.h"
#import "FLCompatibility.h"
#import "FLPrettyAttributedString.h"

extern NSString* const FLActivityLogUpdated;
extern NSString* const FLActivityLogStringKey;

@interface FLActivityLog : FLPrettyAttributedString {
@private 
    SDKFont* _textFont;
    NSColor* _textColor;
}
@property (readwrite, strong, nonatomic) SDKFont* activityLogTextFont;
@property (readwrite, strong, nonatomic) NSColor* activityLogTextColor;

+ (id) activityLog;

- (void) appendURL:(NSURL*) url string:(NSString*) text;
- (void) appendLineWithURL:(NSURL*) url string:(NSString*) text;
- (void) appendErrorLine:(NSString*) errorLine;
- (void) appendBoldTitle:(NSString*) title;
- (void) appendBoldTitleLine:(NSString*) title;

- (NSError*) exportToPath:(NSURL*) url;

- (void) clear;
@end



