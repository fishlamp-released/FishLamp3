//
//  FLFolderBlobStorage.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 4/21/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLFolderBlobStorage.h"

@interface FLFolderBlobStorage ()
@property (readwrite, strong) FLFolder* folder;
@end

@implementation FLFolderBlobStorage

@synthesize folder = _folder;

- (id) initWithFolder:(FLFolder*) folder {
	self = [super init];
	if(self) {
        self.folder = folder;
	}
	return self;
}
+ (id) blobFolderStorage:(FLFolder*) folder {
    return FLAutorelease([[[self class] alloc] initWithFolder:folder]);
}

#if FL_MRC
- (void) dealloc {
	[_folder release];
	[super dealloc];
}
#endif

- (void) writeBlob:(id) identifier {
}
- (id) readBlob:(id) identifier {
return nil;
}
- (void) deleteBlob:(id) identifier {
}

- (BOOL) containsBlob:(id) identifier {
return NO;
}



@end
