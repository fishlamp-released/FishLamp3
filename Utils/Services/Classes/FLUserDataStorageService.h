//
//  FLUserDataStorageService.h
//  FLCore
//
//  Created by Mike Fullerton on 11/3/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//
#if REFACTOR

#import "FLService.h"
#import "FLDatabase.h"
#import "FLFolder.h"
#import "FLLengthyTask.h"
#import "FLLengthyTaskList.h"
#import "FLVersionUpgradeLengthyTaskList.h"
#import "FLImageFolder.h"
#import "FLStorageService.h"

@interface FLUserDataStorageService : FLStorageService {
@private

// cache
	FLFolder* _cacheFolder;
	FLImageFolder* _imageCacheFolder;
	FLFolder* _tempFolder;
	FLFolder* _logFolder;
	FLDatabase* _cacheDatabase;

// documents
	FLFolder* _documentsFolder;
	FLDatabase* _documentsDatabase;
	FLImageFolder* _imageFolder;

	FLVersionUpgradeLengthyTaskList* _upgradeTaskList;
    BOOL _willOpen;
    BOOL _isOpening;
    BOOL _upgrading;
    BOOL _open;
}

// cache
@property (readonly, strong) FLFolder* cacheFolder;
@property (readonly, strong) FLDatabase* cacheDatabase;
@property (readonly, strong) FLImageFolder* imageCacheFolder;
@property (readonly, strong) FLFolder* tempFolder;
@property (readonly, strong) FLFolder* logFolder;

// app data
@property (readonly, strong) FLDatabase* documentsDatabase;
@property (readonly, strong) FLFolder* documentsFolder;
@property (readonly, strong) FLImageFolder* imageFolder;

+ (id) userDataStorageService;

@end

@interface FLUserDataStorageService (PlatformSpecific)
+ (id) createVersionUpgradeProgressViewController;
+ (id) createUserLoggingOutProgressViewController;
@end

@protocol FLUserDataServiceObserver <NSObject>

- (void) userDataService:(FLUserDataStorageService*) userDataService
    appVersionWillChange:(FLVersionUpgradeLengthyTaskList*) taskListToAddTo;

@end



#endif