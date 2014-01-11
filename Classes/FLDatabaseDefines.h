//
//  FLDatabaseDefines.h
//  FishLampFrameworks
//
//  Created by Mike Fullerton on 8/21/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import <sqlite3.h>

#ifndef FL_LEGACY_DB_ENCODING
#define FL_LEGACY_DB_ENCODING 0
#endif

#ifndef FL_DATABASE_PREFIX
#define FL_DATABASE_PREFIX @"_db_"
#endif

#ifndef FL_DATABASE_DEBUG
#define FL_DATABASE_DEBUG 0
#endif

/**
	This file contains various defines, enums, and utils used commonly by the FLDatabase code.
*/

// helpful enums that are the same as the SQL defines
typedef enum {
    FLDatabaseTypeInvalid = 0, 
    
	FLDatabaseTypeInteger	= SQLITE_INTEGER,
	FLDatabaseTypeBlob	= SQLITE_BLOB,
	FLDatabaseTypeFloat	= SQLITE_FLOAT,
	FLDatabaseTypeText	= SQLITE_TEXT,
	FLDatabaseTypeNull	= SQLITE_NULL,
	FLDatabaseTypeDate,
	FLDatabaseTypeObject,
    FLDatabaseTypeNone  
} FLDatabaseType;

// flag descriptions are here: http://www.sqlite.org/c3ref/open.html
typedef enum {
	FLDatabaseOpenFlagReadOnly = SQLITE_OPEN_READONLY,
	FLDatabaseOpenFlagReadWrite = SQLITE_OPEN_READWRITE,
	FLDatabaseOpenFlagCreate = SQLITE_OPEN_CREATE,
	FLDatabaseOpenFlagDeleteOnClose = SQLITE_OPEN_DELETEONCLOSE,
	FLDatabaseOpenFlagExclusive = SQLITE_OPEN_EXCLUSIVE,
	FLDatabaseOpenFlagAutoProxy = SQLITE_OPEN_AUTOPROXY,
	FLDatabaseOpenFlagMainDB = SQLITE_OPEN_MAIN_DB,
	FLDatabaseOpenFlagTempDB = SQLITE_OPEN_TEMP_DB,
	FLDatabaseOpenFlagTransientDB = SQLITE_OPEN_TRANSIENT_DB,
	FLDatabaseOpenFlagMainJournal = SQLITE_OPEN_MAIN_JOURNAL,
	FLDatabaseOpenFlagTempJournal = SQLITE_OPEN_TEMP_JOURNAL,
	FLDatabaseOpenFlagSubJournal = SQLITE_OPEN_SUBJOURNAL,
	FLDatabaseOpenFlagMasterJournal = SQLITE_OPEN_MASTER_JOURNAL,
	FLDatabaseOpenFlagNoMutex = SQLITE_OPEN_NOMUTEX,
	FLDatabaseOpenFlagFullMutex = SQLITE_OPEN_FULLMUTEX,

	FLDatabaseOpenFlagsDefault = FLDatabaseOpenFlagCreate | FLDatabaseOpenFlagReadWrite | FLDatabaseOpenFlagNoMutex /// Default 

} FLDatabaseOpenFlags;