//
//  NSError+(Sqlite).m
//  FishLamp
//
//  Created by Mike Fullerton on 7/6/11.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton.
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLDatabaseErrors.h"
#import "FLDatabase_Internal.h"

NSString* const FLDatabaseErrorDomain = @"FLDatabaseErrorDomain";

@implementation NSError (FLDatabase)

- (NSString*) failedSql
{
	return [self.userInfo objectForKey:FLDatabaseErrorFailedSqlKey];
}

- (NSString*) sqliteErrorMessage
{
	return [self.userInfo objectForKey:FLDatabaseErrorMessageKey];
}

- (BOOL) isTableDoesNotExistError
{
	NSString* sqliteErrorMsg = self.sqliteErrorMessage;
	return [sqliteErrorMsg rangeOfString:@"no such table"].length > 0;
}


@end

NSString* FLDatabaseErrorToString(int error)
{
	switch(error)
	{
		case SQLITE_OK: return @"SQLITE_OK";
		case SQLITE_ERROR: return @"SQLITE_ERROR";
		case SQLITE_INTERNAL: return @"SQLITE_INTERNAL";
		case SQLITE_PERM: return @"SQLITE_PERM";
		case SQLITE_ABORT: return @"SQLITE_ABORT";
		case SQLITE_BUSY: return @"SQLITE_BUSY";
		case SQLITE_LOCKED: return @"SQLITE_LOCKED";
		case SQLITE_NOMEM: return @"SQLITE_NOMEM";
		case SQLITE_READONLY: return @"SQLITE_READONLY";
		case SQLITE_INTERRUPT: return @"SQLITE_INTERRUPT";
		case SQLITE_IOERR: return @"SQLITE_IOERR";
		case SQLITE_CORRUPT: return @"SQLITE_CORRUPT";
		case SQLITE_NOTFOUND: return @"SQLITE_NOTFOUND";
		case SQLITE_FULL: return @"SQLITE_FULL";
		case SQLITE_CANTOPEN: return @"SQLITE_CANTOPEN";
		case SQLITE_PROTOCOL: return @"SQLITE_PROTOCOL";
		case SQLITE_EMPTY: return @"SQLITE_EMPTY";
		case SQLITE_SCHEMA: return @"SQLITE_SCHEMA";
		case SQLITE_TOOBIG: return @"SQLITE_TOOBIG";
		case SQLITE_CONSTRAINT: return @"SQLITE_CONSTRAINT";
		case SQLITE_MISMATCH: return @"SQLITE_MISMATCH";
		case SQLITE_MISUSE: return @"SQLITE_MISUSE";
		case SQLITE_NOLFS: return @"SQLITE_NOLFS";
		case SQLITE_AUTH: return @"SQLITE_AUTH";
		case SQLITE_FORMAT: return @"SQLITE_FORMAT";
		case SQLITE_RANGE: return @"SQLITE_RANGE";
		case SQLITE_NOTADB: return @"SQLITE_NOTADB";
		case SQLITE_ROW: return @"SQLITE_ROW";
		case SQLITE_DONE: return @"SQLITE_DONE";
		
		break;
	}
	
	return @"SQLITE_UNKNOWN_ERROR";
}

