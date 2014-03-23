//
//  FLTestablesLogWindowController.h
//  Pods
//
//  Created by Mike Fullerton on 2/23/14.
//
//

#import "FishLampCore.h"
#import <Cocoa/Cocoa.h>

@class FLTestablesLogViewController;

@interface FLTestablesLogWindowController : NSWindowController {
@private
    IBOutlet FLTestablesLogViewController* _logViewController;
}

+ (id) testablesLogViewController;

- (void) runTests:(id) sender;

@end
