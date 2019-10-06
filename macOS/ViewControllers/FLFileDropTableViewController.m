//
//  FLFileDropTableViewController.m
//  FishLampOSX
//
//  Created by Mike Fullerton on 4/26/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLFileDropTableViewController.h"
#import "FishLampSimpleLogger.h"

@interface FLFileDropTableViewController ()

@end



@implementation FLFileDropTableViewController

@synthesize tableView = _tableView;
@synthesize urls = _urls;

+ (NSArray*) imageUTIs {
    FLReturnStaticObject([NSArray arrayWithObjects:
            (id)kUTTypeImage, 
            (id)kUTTypeJPEG,
            (id)kUTTypeJPEG2000,
            (id)kUTTypeTIFF,
            (id)kUTTypePICT,
            (id)kUTTypeGIF,
            (id)kUTTypePNG,
            (id)kUTTypeMovie,
            (id)kUTTypeVideo,
            (id)kUTTypeMPEG,
            (id)kUTTypeMPEG4,
            (id)kUTTypeFolder,
            nil];);

}

- (NSArray*) utis {
    return [[self class] imageUTIs];
}

- (void) awakeFromNib {
    [super awakeFromNib];
    if(!_urls) {
        _urls = [[NSMutableArray alloc] init];
    }
                
    [_tableView setDropRow:-1 dropOperation:NSTableViewDropOn];
    [_tableView registerForDraggedTypes:[NSArray arrayWithObjects:(id) kUTTypeFileURL, (id) kUTTypeFolder, (id) kUTTypeDirectory, nil]];
}

- (BOOL) isAcceptableFile:(NSURL*) url utiTypes:(NSArray*) utiTypes {

    BOOL isAcceptable = NO;
    
    CFStringRef fileExtension = FLBridge(CFStringRef, [url pathExtension]);
    CFStringRef fileUTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, fileExtension, NULL);

    for(NSString* uti in utiTypes) {
        if(UTTypeConformsTo(fileUTI, FLBridge(CFStringRef, uti))) {
            isAcceptable = YES;
            break;
        }
    }

#if DEBUG
    if(!isAcceptable) {
        FLDebugLog(@"rejected %@", [url description]);
    }
#endif    

    CFRelease(fileUTI);
    
    return isAcceptable;
}

#if __MAC_10_8
-(void)draggingSession:(NSDraggingSession *)session endedAtPoint:(NSPoint)screenPoint operation:(NSDragOperation)operation {
    if (operation == NSDragOperationNone) {
        //delete object, remove from view, etc.
    }
}

- (void)tableView:(NSTableView *)tableView 
  draggingSession:(NSDraggingSession *)session 
 willBeginAtPoint:(NSPoint)screenPoint 
    forRowIndexes:(NSIndexSet *)rowIndexes {
   
   [session setAnimatesToStartingPositionsOnCancelOrFail:NO];
}
#endif

- (NSURL*) urlForRow:(NSUInteger) row {
    return [_urls objectAtIndex:row];
}

- (BOOL)tableView:(NSTableView *)tv 
writeRowsWithIndexes:(NSIndexSet *)rowIndexes 
     toPasteboard:(NSPasteboard*)pboard {
     
    // Drag and drop support
//    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:rowIndexes];
  
    NSURL* url = [self urlForRow:[rowIndexes firstIndex]];
  
    [pboard declareTypes:[NSArray arrayWithObject:NSPasteboardTypeString] owner:self];
    [pboard setString:[url absoluteString] forType:NSPasteboardTypeString];
    return YES;
}

- (void) addURL:(NSURL*) url {
    [_urls addObject:url];
}

- (void) receiveDroppedURL:(NSURL*) url {
    [_urls addObject:url];
}

- (void) addURLs:(NSArray*) urls utiTypes:(NSArray*) utiTypes {
    for(NSURL* url in urls) {
        BOOL isDir = NO;
        if([[NSFileManager defaultManager] fileExistsAtPath:[url path] isDirectory:&isDir] && isDir) {
            NSArray* items = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:url includingPropertiesForKeys:nil options:0 error:nil];
            [self addURLs:items utiTypes:utiTypes];
        }
        else if([self isAcceptableFile:url utiTypes:utiTypes]) {
            [self receiveDroppedURL:url];
//            [_paths addObject:[url path]];
        }
    }
}

- (BOOL)tableView:(NSTableView *)tableView 
       acceptDrop:(id <NSDraggingInfo>)info 
              row:(NSInteger)row 
    dropOperation:(NSTableViewDropOperation)dropOperation {

    NSPasteboard* pb = info.draggingPasteboard;

    NSDictionary* options = [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSNumber numberWithBool:YES],NSPasteboardURLReadingFileURLsOnlyKey,
                            self.utis, NSPasteboardURLReadingContentsConformToTypesKey,
                            nil];

    NSArray* urls = [pb readObjectsForClasses:[NSArray arrayWithObject:[NSURL class]]
                                      options:options];

    [self addURLs:urls utiTypes:self.utis];
    [_tableView reloadData];
//    [self updateNextButton];
    return YES;
}

 - (NSDragOperation)tableView:(NSTableView *)aTableView 
                 validateDrop:(id<NSDraggingInfo>)info 
                  proposedRow:(NSInteger)row 
        proposedDropOperation:(NSTableViewDropOperation)operation {

    NSPasteboard* pb = info.draggingPasteboard;

    NSDictionary* options = [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSNumber numberWithBool:YES],NSPasteboardURLReadingFileURLsOnlyKey,
                            self.utis, NSPasteboardURLReadingContentsConformToTypesKey,
                            nil];

    NSArray* urls = [pb readObjectsForClasses:[NSArray arrayWithObject:[NSURL class]]
                                      options:options];

    //only allow drag if there is exactly one file
    if(urls.count != 1)
        return NSDragOperationNone;

    return NSDragOperationCopy;
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return _urls.count;
}


@end
