//
//  FLStorageService.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 2/19/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLService.h"
#import "FLObjectStorage.h"
#import "FLBlobStorage.h"

@protocol FLStorageService <FLService, FLObjectStorage>

@end

@interface FLStorageService : FLService<FLStorageService> {
@private
}

// required override.
- (id<FLObjectStorage>) objectStorage;
- (id<FLBlobStorage>) blobStorage;

@end

@interface FLNoStorageService : FLService<FLStorageService>
+ (id) noStorageService;
@end

@interface FLStorageServiceAware <NSObject>
- (void) setStorageService:(id<FLStorageService>) service;
- (id<FLStorageService>) storageService;
@end