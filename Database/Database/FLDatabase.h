//
//  FLDatabase.h
//  FishLamp
//
//  Created by Mike Fullerton on 5/25/11.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton.
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

/** 
	Abstraction for SqlDatabase that doesn't take a dependency on the rest of FishLamp.
*/

#import "FishLampMinimum.h"
#import <sqlite3.h>

#import "FLDatabaseDefines.h"
#import "FLDatabaseTable.h"
#import "FLDatabaseErrors.h"
#import "FLDatabaseColumnDecoder.h"
#import "FLDatabaseStatement.h"
#import "FLSqlStatement.h"

@protocol FLDatabaseDelegate;

@interface FLDatabase : NSObject<FLSqlStatementDelegate> {
@private
	sqlite3* _sqlite;
	NSString* _filePath;
	NSMutableDictionary* _tables;
    BOOL _isOpen;
    __unsafe_unretained id<FLDatabaseDelegate> _delegate;
}
@property (readwrite, assign, nonatomic) id<FLDatabaseDelegate> delegate;

/// returns path to db file
@property (readonly, retain, nonatomic) NSString* filePath;
@property (readonly, retain, nonatomic) NSString* fileName;

/// returns point to sqlite3 reference
@property (readonly, assign) sqlite3* sqlite3;

/// returns YES is db is open
@property (readonly, assign) BOOL isOpen;

/// Initialize database object. This doesn't open the db.
- (id) initWithFilePath:(NSString*) filePath;

/// Deletes the .sqlite file on disk.
- (void) deleteOnDisk;

/// Returns true if file exists on disk 
- (BOOL) databaseFileExistsOnDisk;

///	Size of file on disk 
- (unsigned long long) databaseFileSize;

/// Open the database. Use the flags to specify the behavior, for example: @see FLDatabaseOpenFlagsDefault
- (BOOL) openDatabase:(FLDatabaseOpenFlags) flags;
- (BOOL) openDatabase;

/// Close the database
- (void) closeDatabase;

/// Will cancel the current operation
- (void) cancelCurrentOperation; 

/// Exec a command. Threadsafe.
//- (void) exec:(NSString*) sql;

- (void) executeTransaction:(dispatch_block_t) block;

- (NSArray*) execute:(NSString*) sqlString;

- (void) execute:(NSString*) sqlString
  rowResultBlock:(FLDatabaseStatementDidSelectRowBlock) rowResultBlock;

- (void) executeStatement:(FLDatabaseStatement*) statement;

- (void) executeSql:(FLSqlBuilder*) sql 
     rowResultBlock:(FLDatabaseStatementDidSelectRowBlock) rowResultBlock;

// misc
- (void) purgeMemoryIfPossible;

// tables
/// does the table exist in the db?
- (BOOL) tableExists:(FLDatabaseTable*) table;

- (FLDatabaseTable*) tableForName:(NSString*) name;

/// if the table doesn't exist in the db, create it.
- (void) createTableIfNeeded:(FLDatabaseTable*) table;

/// remove table from db
- (void) dropTable:(FLDatabaseTable*) table;

/// returns row count for this table
- (NSUInteger) rowCountForTable:(FLDatabaseTable*) table;

// runs the queury and dumps the resulting rows into the array
// just here for convienience.
- (void) runQueryOnTable:(FLDatabaseTable*) table
              withString:(NSString*) statementString
                 outRows:(NSArray**) outRows;

- (NSUInteger) rowCountForTableByName:(NSString*) tableName;

- (BOOL) tableExistsByName:(NSString*) tableName;

- (void) dropTableByName:(NSString*) tableName;

- (void) insertOrReplaceRowInTable:(NSString*) tableName 
                               row:(NSDictionary*) row;

- (void) insertRowInTable:(NSString*) tableName
			          row:(NSDictionary*) row;

- (void) replaceRowInTable:(NSString*) tableName
			          row:(NSDictionary*) row;

@end

typedef void (^FLDatabaseUpgradeProgressBlock)(   NSUInteger checkedCount, NSUInteger total);

typedef void (^FLDatabaseTableUpgradedBlock)(     FLDatabaseTable* table, NSString* toVersion);

@interface FLDatabase (Versioning)

/// Reads version saved in database
- (NSString*) readDatabaseVersion;

/// returns YES if version saved in database is not the same version as the current version
- (BOOL) databaseNeedsUpgrade;

/// upgrades to runtime version
- (void) upgradeDatabase:(FLDatabaseUpgradeProgressBlock) progress
           tableUpgraded:(FLDatabaseTableUpgradedBlock) tableUpgraded;

// this is the app version by default. This means the database will want an upgraded each time
// the app version changes.
+ (NSString*) currentRuntimeVersion;

+ (void) setCurrentRuntimeVersion:(NSString*) version;

@end


@protocol FLDatabaseDelegate <NSObject> 
- (void) databaseVersionDidChange:(FLDatabase*) database;
@end

//#import "FLDatabase+Introspection.h"

#if FL_DATABASE_DEBUG
#define FLDbLog(__FORMAT__, ...)   \
        FLLogWithType(FLLogTypeDatabase, __FORMAT__, ##__VA_ARGS__)

#define FLDbLogIf(__CONDITION__, __FORMAT__, ...)   \
        if(__CONDITION__) FLLogWithType(FLLogTypeDatabase, __FORMAT__, ##__VA_ARGS__)

#else 
#define FLDbLog(__FORMAT__, ...)
#define FLDbLogIf(__CONDITION__, __FORMAT__, ...)
#endif

#define FLDatabaseIsInternalNameEncoded_(__NAME__) [__NAME__ hasPrefix:FL_DATABASE_PREFIX]

NS_INLINE 
NSString* FLDatabaseNameEncode(NSString* name) {
	return FLDatabaseIsInternalNameEncoded_(name) ? name : [NSString stringWithFormat:@"%@%@", FL_DATABASE_PREFIX, name];
}

NS_INLINE 
NSString* FLDatabaseNameDecode(NSString* internalName) {
	return FLDatabaseIsInternalNameEncoded_(internalName) ? [internalName substringFromIndex:FL_DATABASE_PREFIX.length] : internalName;
}

@interface NSObject (FLDatabase)
- (id<NSCoding>) databaseRepresentation; // returns self by default if implements nscoding or nil
+ (id) objectWithDatabaseRepresentation:(id) representation; // returns representation by default
+ (FLDatabaseType) databaseColumnType;
@end



