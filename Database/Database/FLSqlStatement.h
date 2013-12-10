//
//  FLSqlStatement.h
//  FishLamp
//
//  Created by Mike Fullerton on 11/29/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampMinimum.h"
#import "FLDatabaseDefines.h"

#import "FLSqlBuilder.h"

@class FLDatabase;
@class FLDatabaseTable;
@class FLDatabaseColumn;

@protocol FLSqlStatementDelegate;

@interface FLSqlStatement : NSObject {
@private
    FLDatabase* _database;
	sqlite3_stmt* _sqlite3_stmt;
    int _stepValue;
    __unsafe_unretained id<FLSqlStatementDelegate> _delegate;
    FLDatabaseTable* _table;
}
@property (readwrite, assign, nonatomic) id<FLSqlStatementDelegate> delegate;
@property (readwrite, strong, nonatomic) FLDatabaseTable* table;

- (id) initWithDatabase:(FLDatabase*) database;
- (id) initWithDatabase:(FLDatabase*) database table:(FLDatabaseTable*) table;

+ (id) sqlStatement:(FLDatabase*) database;
+ (id) sqlStatement:(FLDatabase*) database table:(FLDatabaseTable*) table;

// iterating
@property (readonly, assign, nonatomic) int stepValue;
@property (readonly, assign, nonatomic) BOOL isDone;

- (void) prepareWithSql:(FLSqlBuilder*) sql;
- (NSDictionary*) step;
- (void) finalizeStatement;
- (void) resetStatement;
@end

@interface NSObject (FLSqlStatement)
- (void) bindToStatement:(FLSqlStatement*) statement parameterIndex:(int) parameterIndex;
@end

@protocol FLSqlStatementDelegate <NSObject>
//- (NSDate*) sqlStatement:(FLSqlStatement*) statement willDecodeDate:(NSNumber*) number forTable:(FLDatabaseTable*) table forColumn:(FLDatabaseColumn*) column;

- (NSString*) sqlStatement:(FLSqlStatement*) statement willDecodeString:(NSString*) string forTable:(FLDatabaseTable*) table forColumn:(FLDatabaseColumn*) column;

- (NSNumber*) sqlStatement:(FLSqlStatement*) statement willDecodeNumber:(NSNumber*) number forTable:(FLDatabaseTable*) table forColumn:(FLDatabaseColumn*) column;

- (NSData*) sqlStatement:(FLSqlStatement*) statement willDecodeBlob:(NSData*) data forTable:(FLDatabaseTable*) table forColumn:(FLDatabaseColumn*) column;

- (id) sqlStatement:(FLSqlStatement*) statment willDecodeObject:(NSData*) data forTable:(FLDatabaseTable*) table forColumn:(FLDatabaseColumn*) column;
@end