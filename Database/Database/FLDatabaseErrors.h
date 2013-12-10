//
//  NSError+(Sqlite).h
//  FishLamp
//
//  Created by Mike Fullerton on 7/6/11.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton.
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampMinimum.h"

typedef enum {
	FLDatabaseErrorDatabaseAlreadyOpen = 1,
	FLDatabaseErrorDatabaseAlreadyClosed
} FLDatabaseErrorCode;

extern NSString* const FLDatabaseErrorDomain;

#define FLDatabaseErrorMessageKey @"FLDatabaseErrorMessageKey" 
#define FLDatabaseErrorFailedSqlKey @"FLDatabaseErrorFailedSqlKey" 

@interface NSError (FLDatabase)

@property (readonly, retain, nonatomic) NSString* failedSql;
@property (readonly, retain, nonatomic) NSString* sqliteErrorMessage;

@property (readonly, assign, nonatomic) BOOL isTableDoesNotExistError;

@end
