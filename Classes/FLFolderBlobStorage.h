//
//  FLFolderBlobStorage.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 4/21/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLFolder.h"
#import "FLBlobStorage.h"

@interface FLFolderBlobStorage : NSObject<FLBlobStorage> {
@private
    FLFolder* _folder;
}

@property (readonly, strong) FLFolder* folder;

- (id) initWithFolder:(FLFolder*) folder;
+ (id) blobFolderStorage:(FLFolder*) folder;


@end
