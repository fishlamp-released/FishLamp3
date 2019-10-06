//
//  FLFileDropTableViewController.h
//  FishLampOSX
//
//  Created by Mike Fullerton on 4/26/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampOSX.h"

#define BasicTableViewDragAndDropDataType @"BasicTableViewDragAndDropDataType"

@interface FLFileDropTableViewController : NSViewController {
@private
    IBOutlet __weak NSTableView* _tableView;
    
    NSMutableArray* _urls;
}

@property (readonly, weak, nonatomic) NSTableView* tableView;
@property (readonly, strong, nonatomic) NSArray* utis;
@property (readonly, strong, nonatomic) NSArray* urls;

- (void) addURL:(NSURL*) url;
- (NSURL*) urlForRow:(NSUInteger) row;
- (void) receiveDroppedURL:(NSURL*) url;

+ (NSArray*) imageUTIs;

@end
