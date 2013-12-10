//
//  FLDatabaseTable.h
//  FishLamp
//
//  Created by Mike Fullerton on 5/27/11.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampMinimum.h"

@class FLDatabase;
@class FLDatabaseTable;

#import "FLDatabaseColumn.h"
#import "FLDatabaseIndex.h"
#import "FLSqlBuilder.h"
#import "FLDatabaseStatement.h"

@interface FLDatabaseTable : NSObject<NSCopying> {
@private
	NSString* _tableName;
	NSString* _decodedTableName;
	
	NSMutableDictionary* _columns;
	NSMutableDictionary* _indexes;
    NSMutableDictionary* _columnConstraints;
    NSMutableSet* _primaryKeyColumns;
    NSMutableSet* _indexedColumns;
    
	Class _tableClass;
}

@property (readonly, strong, nonatomic) NSString* tableName;
@property (readonly, strong, nonatomic) NSString* decodedTableName;

@property (readonly, strong, nonatomic) NSDictionary* columns;
@property (readonly, strong, nonatomic) NSSet* primaryKeyColumns;
@property (readonly, strong, nonatomic) NSSet* indexedColumns;
@property (readonly, strong, nonatomic) NSDictionary* indexes;

@property (readonly, assign, nonatomic) Class classRepresentedByTable;

- (id) initWithTableName:(NSString*) tableName;
- (id) initWithClass:(Class) aClass;

+ (id) databaseTableWithTableName:(NSString*) tableName;
+ (id) databaseTableWithClass:(Class) aClass;

- (void) addColumn:(FLDatabaseColumn*) column;

//- (void) setColumn:(FLDatabaseColumn*) column
//     forColumnName:(NSString*) columnName;

- (void) removeColumnWithName:(NSString*) name;

- (FLDatabaseColumn*) columnByName:(NSString*) name;

- (FLDatabaseColumn*) columnForPropertySelector:(SEL) selector; 
//
// indexes
//

- (void) addIndex:(FLDatabaseIndex*) databaseIndex;

- (NSArray*) indexesForColumn:(NSString*) columnName;

//
// sql
//

- (NSString*) createTableSql;

- (NSString*) createTableSqlWithIndexes;

//
// object interaction 
//

- (NSDictionary*) valuesForColumns:(NSSet*) columnNames inObject:(id) object;

- (NSDictionary*) propertyValuesForObject:(id) object
                         withColumnFilter:(void (^)(FLDatabaseColumn* column, BOOL* useIt, BOOL* cancel)) filter;

- (id) objectForRow:(NSDictionary*) row;

// must be added before column is used in database!
- (void) addColumnConstraint:(FLDatabaseColumnConstraint*) constraint forColumn:(FLDatabaseColumn*) column;
- (void) addColumnConstraint:(FLDatabaseColumnConstraint*) constraint forColumnName:(NSString*) columnName;


@end

@protocol FLDatabaseStorable <NSObject>
@optional

+ (NSString*) databaseTableName; // returns NSStringFromClass(self) by default.

+ (FLDatabaseTable*) sharedDatabaseTable;
- (FLDatabaseTable*) databaseTable;

+ (void) databaseTableWillAddColumns:(FLDatabaseTable*) table;
+ (void) databaseTable:(FLDatabaseTable*) table willAddDatabaseColumn:(FLDatabaseColumn*) column;
+ (void) databaseTableDidAddColumns:(FLDatabaseTable*) table;
+ (void) didCreateDatabaseTable:(FLDatabaseTable*) table;
@end


@interface NSObject (FLDatabaseTable) 
+ (NSString*) databaseTableName; // returns NSStringFromClass(self) by default.

+ (FLDatabaseTable*) sharedDatabaseTable;
- (FLDatabaseTable*) databaseTable;

+ (void) databaseTableWillAddColumns:(FLDatabaseTable*) table;
+ (void) databaseTable:(FLDatabaseTable*) table willAddDatabaseColumn:(FLDatabaseColumn*) column;
+ (void) databaseTableDidAddColumns:(FLDatabaseTable*) table;
+ (void) didCreateDatabaseTable:(FLDatabaseTable*) table;

+ (SEL) databasePrimaryKeyColumn;
@end

@interface FLSqlBuilder (FLSqlTable)
- (BOOL) appendWhereClauseForSelectingObject:(id) object;
- (void) appendInsertClauseForObject:(id) object;
@end
