//
//  ZFActivityLogView.h
//  FishLamp
//
//  Created by Mike Fullerton on 3/11/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import <Cocoa/Cocoa.h>

#import "FLActivityLog.h"
#import "FLTextViewController.h"

@interface FLActivityLogViewController : FLTextViewController {
@private
    NSMutableAttributedString* _queue;
    NSTimeInterval _lastUpdate;
    FLActivityLog* _activityLog;
}

@property (readwrite, strong, nonatomic) FLActivityLog* activityLog;

@end
