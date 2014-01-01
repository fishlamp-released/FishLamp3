//
//  FLUserDataStorageService.m
//  FLCore
//
//  Created by Mike Fullerton on 11/3/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//
#if REFACTOR

#import "FLUserDataStorageService.h"

#import "FLFolder.h"
#import "FLLowMemoryHandler.h"
#import "FLUpgradeDatabaseLengthyTask.h"
#import "FLApplicationDataVersion.h"
#import "FLApplicationDataModel.h"
#import "FLCacheManager.h"
#import "NSFileManager+FishLamp.h"
#import "NSString+Guid.h"
#import "FLAction.h"
#import "FLBackgroundTaskMgr.h"
#import "FLAction.h"
#import "FLObjectDatabase.h"
#import "NSBundle+FLVersion.h"
#import "FLServiceKeys.h"



@interface FLUserDataStorageService ()
- (BOOL) beginOpeningServiceInContext:(id) context withObserver:(id) observer;
- (void) finishUpgradeTasks;
- (void) registerForEvents;
@property (readonly, retain, nonatomic) FLVersionUpgradeLengthyTaskList* upgradeTaskList;
@end

@implementation FLUserDataStorageService

@synthesize cacheDatabase = _cacheDatabase;
@synthesize documentsDatabase = _documentsDatabase;
@synthesize documentsFolder = _documentsFolder;
@synthesize cacheFolder = _cacheFolder;
@synthesize imageFolder = _imageFolder;
@synthesize imageCacheFolder = _imageCacheFolder;
@synthesize tempFolder = _tempFolder;
@synthesize logFolder = _logFolder;
@synthesize upgradeTaskList = _upgradeTaskList;

- (id) init { 
    self = [super init];
	if(self) {   
        [self registerForEvents];
    }

	return self;
}

+ (id) userDataStorageService {
    return FLAutorelease([[[self class] alloc] init]);
}

- (void) _emptyCache:(id) sender
{
    @synchronized(_cacheDatabase) {
        
        [_cacheDatabase cancelCurrentOperation];
    
        [_cacheDatabase closeDatabase];
        [_cacheDatabase deleteOnDisk];
        [_cacheDatabase openDatabase:FLDatabaseOpenFlagsDefault];


#if IOS        
        [NSFileManager addSkipBackupAttributeToFile:_cacheDatabase.filePath];
#endif        
    }
}

- (void) _appWillResignActive:(id) sender {
	if(_isOpening) {
    	_isOpening = NO;
    }
    if(_upgrading) {
        _upgrading = NO;
    }
    
    FLReleaseWithNil(_upgradeTaskList);
}

- (void) _appWillBecomeActive:(id) sender {
	if(!self.isOpen && _willOpen) {
// REFACTOR
FLAssertFailed(@"refactor this");    
//        [self _beginOpeningService];
    }
}

- (void) dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];

    FLSuperDealloc();
}

//- (void) _appDidEnterBackground:(id) sender {
//}
//
//- (void) _appWillEnterForeground:(id) sender {
//}

- (void) _appWillTerminate:(id) sender {

}

- (void) registerForEvents
{
    [[NSNotificationCenter defaultCenter] addObserver:self
            selector:@selector(_emptyCache:) 
            name: FLCacheManagerEmptyCacheNotification
            object: [FLCacheManager instance]];

#if IOS

    [[NSNotificationCenter defaultCenter] addObserver:self
            selector:@selector(_appWillTerminate:) 
            name: UIApplicationWillTerminateNotification // UIApplicationWillTerminateNotification
            object: [UIApplication sharedApplication]];

    [[NSNotificationCenter defaultCenter] addObserver:self
            selector:@selector(_appWillBecomeActive:) 
            name: UIApplicationDidBecomeActiveNotification // UIApplicationDidBecomeActiveNotification
            object: [UIApplication sharedApplication]];

    [[NSNotificationCenter defaultCenter] addObserver:self
            selector:@selector(_appWillResignActive:) 
            name: UIApplicationWillResignActiveNotification // UIApplicationWillResignActiveNotification
            object: [UIApplication sharedApplication]];

//    [[NSNotificationCenter defaultCenter] addObserver:self
//        selector:@selector(_appDidEnterBackground:) 
//        name: UIApplicationDidEnterBackgroundNotification // UIApplicationDidEnterBackgroundNotification
//        object: [UIApplication sharedApplication]];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//        selector:@selector(_appWillEnterForeground:) 
//        name: UIApplicationWillEnterForegroundNotification // UIApplicationWillEnterForegroundNotification
//        object: [UIApplication sharedApplication]];
#endif
}



- (void) deleteServiceData  {
//    [self removeAppService:self.backgroundTasks];
//    self.backgroundTasks = nil;

    FLReleaseWithNil(_documentsFolder);
	FLReleaseWithNil(_cacheFolder);
	FLReleaseWithNil(_imageFolder);
	FLReleaseWithNil(_imageCacheFolder);
	FLReleaseWithNil(_tempFolder);
	FLReleaseWithNil(_logFolder);

	FLReleaseWithNil(_cacheDatabase);
	FLReleaseWithNil(_documentsDatabase);
} 
 
- (void) closeSelf
{
	FLReleaseWithNil(_upgradeTaskList);
	
//    [self performSelector:@"userServiceWillClose:"];

//    id<FLProgressViewController> progress = nil;
    
//    if([self.backgroundTasks isExecutingBackgroundTask]) {
//        progress = [[self class] createUserLoggingOutProgressViewController];
//        [progress setTitle:NSLocalizedString(@"Logging Out…", nil)];
//    }

//    [self.backgroundTasks beginClosingService:^(FLFinisher* backgroundTaskMgr) {
//        [self closeSelf];
//        [progress hideProgress];
//        [asyncTask setFinished];
//    }];
    
	if(self.isOpen) {
		[[FLLowMemoryHandler defaultHandler] broadcastReleaseMessage];
	}
	 
	@try {
//        [self userLogin].isAuthenticatedValue = NO;
//        [[FLApplicationDataModel instance] saveUserLogin:[self userLogin]];
    
		[_cacheDatabase closeDatabase];
		[_documentsDatabase closeDatabase];

		// wtf to do if db close fails???? 
	}
	@finally {
		[self deleteServiceData];

		FLAssertIsNil(_cacheDatabase, nil);
		FLAssertIsNil(_documentsDatabase, nil);
		
		_open = NO;
		_willOpen = NO;
		_isOpening = NO;
//        [self performSelector:@"userServiceDidClose:"];
    }
}

- (FLAuthenticationCredentials*) userLogin {
    return nil; // [self.context resourceForKey:FLUserLoginKey];
}

- (void) initCache {
    
    NSArray* cachePaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString* userCacheFolder = [cachePaths objectAtIndex: 0];

#if OSX
    userCacheFolder = [userCacheFolder stringByAppendingPathComponent:[NSBundle bundleIdentifier]];
#endif

    FLAuthenticationCredentials* userLogin = self.userLogin;

	if(!_cacheFolder){
		_cacheFolder = [[FLFolder alloc] initWithFolderPath:[userCacheFolder stringByAppendingPathComponent:userLogin.userGuid]];
		[_cacheFolder createIfNeeded];
	}
	if(!_imageCacheFolder) {
		_imageCacheFolder = [[FLImageFolder alloc] initWithFolderPath:[userCacheFolder stringByAppendingPathComponent:@"photos"]];
		[_imageCacheFolder createIfNeeded];
	}
	if(!_tempFolder) {
		_tempFolder = [[FLFolder alloc] initWithFolderPath:[userCacheFolder stringByAppendingPathComponent:@"temp"]];
		[_tempFolder createIfNeeded];
	}
	if(!_logFolder) {
		_logFolder = [[FLFolder alloc] initWithFolderPath:[userCacheFolder stringByAppendingPathComponent:@"logs"]];
		[_logFolder createIfNeeded];
	}

	if(!_cacheDatabase) {
		_cacheDatabase = [[FLObjectDatabase alloc] initWithDefaultName:self.cacheFolder.folderPath];
		[_cacheDatabase openDatabase:FLDatabaseOpenFlagsDefault];
#if IOS        
        [NSFileManager addSkipBackupAttributeToFile:_cacheDatabase.filePath];
#endif        
	}
}

- (void) initDocuments {

    NSArray* documentsPaths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    NSString* userDocumentsFolder = [documentsPaths objectAtIndex: 0];

    FLAuthenticationCredentials* userLogin = self.userLogin;

#if OSX
    userDocumentsFolder = [userDocumentsFolder stringByAppendingPathComponent:[NSBundle bundleIdentifier]];
#endif
    
	if(!_documentsFolder) {
		_documentsFolder = [[FLFolder alloc] initWithFolderPath:[userDocumentsFolder stringByAppendingPathComponent:userLogin.userGuid]];
		[_documentsFolder createIfNeeded];
	}
    
// does photo folder make sense on OS X?    
	if(!_imageFolder) {
		_imageFolder = [[FLImageFolder alloc] initWithFolderPath:[userDocumentsFolder stringByAppendingPathComponent:@"photos"]];
		[_imageFolder createIfNeeded];
	}
    
	if(!_documentsDatabase) {
		_documentsDatabase = [[FLObjectDatabase alloc] initWithDefaultName:self.documentsFolder.folderPath];
		[_documentsDatabase openDatabase:FLDatabaseOpenFlagsDefault];
	}    
}

- (void) initServiceObjectsIfNeeded {
    [self initCache];
    [self initDocuments];
}

- (void) finishOpeningService {
	_open = YES;
	_willOpen = NO;
	_isOpening = NO;

//    self.backgroundTasks = [FLBackgroundTaskMgr create];
//    [self addAppService:_backgroundTasks];

//    [self.backgroundTasks startOpeningService:^(id result) {
//        [self performSelector:@"userServiceDidOpen:"];
//    }];
}

- (BOOL) runUpgradeTasksIfNeededInContext:(id) context {
    
    FLApplicationDataVersion* input = [FLApplicationDataVersion applicationDataVersion];
		input.userGuid = [self userLogin].userGuid;
		
    FLApplicationDataVersion* dataVersion = [[FLApplicationDataModel instance].database readObject:input];
		
    if( (dataVersion == nil) || 
        FLStringIsEmpty(dataVersion.versionString) ||
        !FLStringsAreEqual(dataVersion.versionString, [NSBundle appVersion]))
    {
        _upgrading = YES;
    
        _upgradeTaskList = [[FLVersionUpgradeLengthyTaskList alloc] initWithFromVersion:dataVersion.versionString toVersion:[NSBundle appVersion]];
        
        if([_cacheDatabase databaseNeedsUpgrade]) {
            [_upgradeTaskList.operations queueOperation:[FLUpgradeDatabaseLengthyTask upgradeDatabaseLengthyTask:_cacheDatabase]];
        }

        if([_documentsDatabase databaseNeedsUpgrade]) {
            [_upgradeTaskList.operations queueOperation:[FLUpgradeDatabaseLengthyTask upgradeDatabaseLengthyTask:_documentsDatabase]];
        }
        
 //       [self performSelector:@"userDataService:appVersionWillChange:" withObject:_upgradeTaskList];

/*        
        _upgradeTaskList.progressController = [[self class] createVersionUpgradeProgressViewController];
        [_upgradeTaskList.progressController setTitle:[NSString stringWithFormat:(NSLocalizedString(@"Updating to Version: %@", nil)), [NSBundle appVersion]]];
*/        

//        [self.context addObject:_upgradeTaskList];

    
        FLPromisedResult* result = [_upgradeTaskList runChildSynchronously:context];
                
        if(result.error) {
            // TODO: Ok, now what?
        }
        else {
            [self finishUpgradeTasks];
        }
        
        return YES;

    }
    
    return NO;

}

- (BOOL) beginOpeningServiceInContext:(id) context {
	if([self userLogin] && _open == NO && !_isOpening && _willOpen)
	{
		_isOpening = YES;

		[self initServiceObjectsIfNeeded];
		
        if(![self runUpgradeTasksIfNeededInContext:context ]) {
            [self finishOpeningService];
		}
	}
	
	return NO;
}

- (id) operationContext {
FLAssertFailed(@"TODO refactor this");
    return nil;
}

- (void) openSelf {

    [super openSelf];
    FLAssert(FLStringIsNotEmpty([self userLogin].userName), @"invalid userLogin");
    _willOpen = YES;
    _isOpening = NO;
    _open = NO;
    _upgrading = NO;
    [self beginOpeningServiceInContext:[self operationContext] withObserver:nil];
}

- (void) finishUpgradeTasks {	
	if(_upgrading) {
		FLAssertIsNotNil([self userLogin], nil);
		FLAssert(_upgradeTaskList != nil, @"not upgrading");
		
		FLApplicationDataVersion* version = [FLApplicationDataVersion applicationDataVersion];
		version.userGuid = [self userLogin].userGuid;
		version.versionString = [NSBundle appVersion];
		[[FLApplicationDataModel instance].database writeObject:version];

		FLReleaseWithNil(_upgradeTaskList);
		_upgrading = NO;

        [self finishOpeningService];
	}
}

- (BOOL) isServiceAuthenticated {
	return [self userLogin].isAuthenticatedValue;
}

+ (FLAuthenticationCredentials*) loadLastUserLogin {
	return [[FLApplicationDataModel instance] loadLastUserLogin];
}

+ (FLAuthenticationCredentials*) loadDefaultUser {
	FLAuthenticationCredentials* login = [[FLApplicationDataModel instance] loadUserLoginWithGuid:[NSString zeroGuidString]];
    if(!login)
    {
        login = [FLAuthenticationCredentials userLogin];
        login.userName = NSLocalizedString(@"Guest", nil);
        login.isAuthenticatedValue = YES;
        login.userGuid = [NSString zeroGuidString];
        [[FLApplicationDataModel instance] saveUserLogin:login];
        [[FLApplicationDataModel instance] setCurrentUser:login];
    }
	return login;
}

@end

#endif
