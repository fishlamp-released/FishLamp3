//
//  FLDatabaseObjectStorage.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 4/1/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLStorageService.h"

#import "FLObjectDatabaseController.h"

@protocol FLPathProvider;

@interface FLDatabaseStorageService : FLStorageService {
@private
    FLObjectDatabaseController* _databaseController;
    NSString* _databaseFilePath;
}

@property (readonly, strong, nonatomic) FLObjectDatabaseController* databaseController;

+ (id) databaseStorageService;

@property (readwrite, strong) NSString* databaseFilePath;

@end

@protocol FLDatabaseObjectStorageServiceMessages <NSObject>
@optional

- (void) databaseStorageServiceWillOpen:(FLDatabaseStorageService*) service;
- (void) databaseStorageServiceDidOpen:(FLDatabaseStorageService*) service;

- (void) databaseStorageServiceWillClose:(FLDatabaseStorageService*) service;
- (void) databaseStorageServiceDidClose:(FLDatabaseStorageService*) service;
@end


