//
//  FLActivityLog.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 3/2/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampCore.h"
#import "FLStringFormatter.h"
#import "FLCompatibility.h"
#import "FLPrettyAttributedString.h"
#import "FLBroadcaster.h"

@interface FLActivityLog : FLPrettyAttributedString {
@private 
    SDKFont* _textFont;
    SDKColor* _textColor;
    FLEventBroadcaster* _events;
}

@property (readonly, strong) FLEventBroadcaster* events;

@property (readwrite, strong, nonatomic) SDKFont* activityLogTextFont;
@property (readwrite, strong, nonatomic) SDKColor* activityLogTextColor;

+ (id) activityLog;

- (void) appendURL:(NSURL*) url string:(NSString*) text;
- (void) appendLineWithURL:(NSURL*) url string:(NSString*) text;
- (void) appendErrorLine:(NSString*) errorLine;
- (void) appendBoldTitle:(NSString*) title;
- (void) appendBoldTitleLine:(NSString*) title;

- (NSError*) exportToPath:(NSURL*) url;

- (void) clear;
@end

@protocol FLActivityLogEvents <NSObject>
- (void) activityLog:(FLActivityLog*) activityLog didAppendString:(NSAttributedString*) string;
- (void) activityLogDidClearActivity:(FLActivityLog*) activityLog;
@end