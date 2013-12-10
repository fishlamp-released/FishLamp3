//
//  FLInputSink.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 3/31/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampMinimum.h"

@protocol FLInputSink <NSObject>

// results, once the stream is closed.
@property (readonly, strong, nonatomic) NSData* data;
@property (readonly, strong, nonatomic) NSString* filePath;
@property (readonly, assign, nonatomic, getter=isOpen) BOOL open;

- (void) openSink;
- (void) closeSinkWithCommit:(BOOL) commit;

- (void) appendBytes:(const void *)bytes 
              length:(NSUInteger)length;

@end

