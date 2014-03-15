//
//  FLTestablesLogViewController.h
//  Pods
//
//  Created by Mike Fullerton on 2/23/14.
//
//

#import "FishLampCore.h"
#import "FLLogSink.h"

@interface FLTestablesLogViewController : NSViewController<FLLogSink, NSTextViewDelegate> {
@private
    IBOutlet NSTextView* _textView;

    NSInteger _indent;
}

@end
