//
//  FLDatabaseTable.m
//  FishLamp
//
//  Created by Mike Fullerton on 5/27/11.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLDatabaseTable.h"
#import "FLDatabase_Internal.h"

#import "FLObjcRuntime.h"
#import "FLPropertyAttributes.h"
#import "FLObjectDescriber.h"
#import "FLObjectDescriber.h"
#import "FLModelObject.h"
#import "FLObjectDescriber.h"

@interface FLDatabaseTable ()
@property (readwrite, strong, nonatomic) NSSet* primaryKeyColumns;
@property (readwrite, strong, nonatomic) NSSet* indexedColumns;
@property (readwrite, strong, nonatomic) NSDictionary* columns;
@property (readwrite, strong, nonatomic) NSDictionary* indexes;
@property (readwrite, strong, nonatomic) NSDictionary* columnConstraints;

- (void) addColumnsWithTypeDesc:(Class) aClass;
@end

@implementation FLDatabaseTable

@synthesize tableName = _tableName;
@synthesize columns = _columns;
@synthesize indexes = _indexes;
@synthesize decodedTableName = _decodedTableName;
@synthesize classRepresentedByTable = _tableClass;
@synthesize primaryKeyColumns = _primaryKeyColumns;
@synthesize indexedColumns = _indexedColumns;
@synthesize columnConstraints = _columnConstraints;

- (void) setTableName:(NSString*) tableName {
    FLAssertStringIsNotEmpty(tableName);
	
    FLSetObjectWithRetain(_tableName, FLDatabaseNameEncode(tableName));
	FLSetObjectWithRetain(_decodedTableName, FLDatabaseNameDecode(_tableName));
    _tableClass = NSClassFromString(_decodedTableName);
}

- (id) initWithTableName:(NSString*) tableName {
	if((self = [super init])) {
		self.tableName = tableName;
		_columns = [[NSMutableDictionary alloc] init];
        _columnConstraints = [[NSMutableDictionary alloc] init];
        _primaryKeyColumns = [[NSMutableSet alloc] init];
        _indexedColumns = [[NSMutableSet alloc] init];
	}
	
	return self;
}

- (id) initWithClass:(Class) aClass {
	if((self = [self initWithTableName:[aClass databaseTableName]])) {
        [aClass databaseTableWillAddColumns:self];
        
        if([aClass isModelObject]) {
            [self addColumnsWithTypeDesc:aClass];
            
//            FLDatabaseColumn* idColumn = [self columnForPropertySelector:@selector(identifier)];
//            [idColumn addColumnConstraint:[FLPrimaryKeyConstraint primaryKeyConstraint]];
        }

        [aClass databaseTableDidAddColumns:self];
        [aClass didCreateDatabaseTable:self];
        
        SEL primaryKeyColumn = [aClass databasePrimaryKeyColumn];
        if(primaryKeyColumn) {
            [self addColumnConstraint:[FLPrimaryKeyConstraint primaryKeyConstraint] forColumnName:NSStringFromSelector(primaryKeyColumn)];
        }
	}
	
	return self;
}

+ (id) databaseTableWithClass:(Class) aClass {
	return FLAutorelease([[FLDatabaseTable alloc] initWithClass:aClass]);
}

+ (FLDatabaseTable*) databaseTableWithTableName:(NSString*) tableName {
	return FLAutorelease([[FLDatabaseTable alloc] initWithTableName:tableName]);
}

//- (NSArray*) primaryKeyColumns {
//    if(!_primaryKeyColumns) {
//        NSMutableArray* cols = [[NSMutableArray alloc] init];
//    
//        for(FLDatabaseColumn* col in _columns.objectEnumerator) {
//            NSSet* set = [_columnConstraints objectForKey:column.columnName];
//            if(set) {
//                for(FLDatabaseColumnConstraint* constraint in set) {
//                    if([constraint ])
//                }
//            }
//            
//            
//            if(col.hasPrimaryKeyConstraint) {
//                [cols addObject:col];
//            }
//        }
//        
//        _primaryKeyColumns = cols;
//    }
//   
//    return _primaryKeyColumns;
//}

#if FL_MRC
- (void) dealloc {
    [_columnConstraints release];
    [_primaryKeyColumns release];
    [_indexedColumns release];
    [_decodedTableName release];
    [_indexes release];
    [_tableName release];
    [_columns release];
    [super dealloc];
}
#endif

- (void) addIndex:(FLDatabaseIndex*) databaseIndex {
	if(!_indexes) {
		_indexes = [[NSMutableDictionary alloc] init];
	}
	
	NSMutableArray* indexes = [_indexes objectForKey:databaseIndex.columnName];
	if(indexes) {
		[indexes addObject:databaseIndex];
	}
	else {
		indexes = [NSMutableArray arrayWithObject:databaseIndex];
		[_indexes setObject:indexes forKey:databaseIndex.columnName];
	}
	
    [_indexedColumns addObject:databaseIndex.columnName];
}

- (NSArray*) indexesForColumn:(NSString*) columnName {	
	return [_indexes objectForKey:FLDatabaseNameEncode(columnName)];
}

- (NSString*) createTableSqlWithIndexes {
	NSMutableString* sql = [NSMutableString stringWithString:[self createTableSql]];
	
	for(NSArray* indexes in self.indexes.objectEnumerator) {
		for(FLDatabaseIndex* idx in indexes) {
			NSString* createIndex = [idx createIndexSqlForTableName:self.tableName];
			[sql appendFormat:@"; %@", createIndex];
		}
	}
	
	return sql;
}

- (NSString*) createTableSql {
	NSMutableString* sql = [NSMutableString stringWithFormat:@"CREATE TABLE %@ (", self.tableName]; //  IF NOT EXISTS
	int i = 0;
	for(FLDatabaseColumn* col in self.columns.objectEnumerator) {			
        NSSet* constraints = [_columnConstraints objectForKey:col.columnName];

        if(constraints) {
            [sql appendFormat:@"%@%@ %@ %@", (i++ > 0 ? @", " : @""), col.columnName, 
                FLDatabaseTypeToString(col.columnType), 
                [FLDatabaseColumnConstraint columnConstraintsAsString:constraints]];
        }
        else {
            [sql appendFormat:@"%@%@ %@", (i++ > 0 ? @", " : @""), 
                col.columnName, 
                FLDatabaseTypeToString(col.columnType)];
        }
	}

	[sql appendString:@")"];
	
	return sql;
}

- (void) addColumn:(FLDatabaseColumn*) column {
	[_columns setObject:column forKey:column.columnName];
    
    NSArray* constraints = [column columnConstraints];
    if(constraints) {
        for(FLDatabaseColumnConstraint* constraint in constraints) {
            [self addColumnConstraint:constraint forColumn:column];
        }
    }
}

//- (void) setColumn:(FLDatabaseColumn*) column forColumnName:(NSString*) columnName {
//	[_columns setObject:column forKey:FLDatabaseNameEncode(columnName)];
//}

- (void) removeColumnWithName:(NSString*) name {
	[_columns removeObjectForKey:FLDatabaseNameEncode(name)];
}

- (FLDatabaseColumn*) columnByName:(NSString*) name {
	return [_columns objectForKey:FLDatabaseNameEncode(name)];
}

- (FLDatabaseColumn*) columnForPropertySelector:(SEL) selector {
	return [_columns objectForKey:FLDatabaseNameEncode(NSStringFromSelector(selector))];
}

- (void) copyPropertiesFromTable:(FLDatabaseTable*) table {
	self.columns = FLMutableCopyWithAutorelease(table.columns);
	self.indexes = FLMutableCopyWithAutorelease(table.indexes);
    self.primaryKeyColumns = FLMutableCopyWithAutorelease(table.primaryKeyColumns);
    self.indexedColumns = FLMutableCopyWithAutorelease(table.indexedColumns);
    self.columnConstraints = FLMutableCopyWithAutorelease(table.columnConstraints);
}

- (id) copyWithZone:(NSZone *)zone {
	FLDatabaseTable* table = [[FLDatabaseTable alloc] initWithTableName:self.tableName];
    [table copyPropertiesFromTable:self];
	return table;
}

- (void) addSuperclassProperties:(Class) aClass {
    if([aClass isModelObject]) {
        FLDatabaseTable* table = [aClass sharedDatabaseTable];
        [self copyPropertiesFromTable:table];
    }
}

- (void) addColumnsWithTypeDesc:(Class) aClass {

    if([aClass isModelObject]) {
        [self addSuperclassProperties:[aClass superclass]];
    
        FLObjectDescriber* describer = [aClass objectDescriber];

        for(FLPropertyDescriber* property in [[describer properties] objectEnumerator]) {

            NSString* propName = FLDatabaseNameEncode(property.propertyName);

    // skip over properties add by superclass
            if(![_columns objectForKey:propName]) {
            
                
            
            
                FLDatabaseColumn* col = [FLDatabaseColumn databaseColumnWithName:propName columnType:property.databaseColumnType]; 

                [aClass databaseTable:self willAddDatabaseColumn:col];            

                [self addColumn:col];
            }
        }
    }
}

- (NSDictionary*) valuesForColumns:(NSSet*) columnNames 
                          inObject:(id) object {
                                
    NSMutableDictionary* outDictionary = nil;
    for(NSString* name in columnNames) {
        
        id data = [object valueForKey:FLDatabaseNameDecode(name)];
        if(data) {
            if(!outDictionary) {
                outDictionary = [NSMutableDictionary dictionary];
            }
            
            [outDictionary setObject:data forKey:name];
        }
    }

    return outDictionary;
                        
}

- (NSDictionary*) propertyValuesForObject:(id) object
                         withColumnFilter:(void (^)(FLDatabaseColumn* column, BOOL* useIt, BOOL* cancel)) filter {
                         
    NSMutableDictionary* values = nil;
    
    BOOL cancel = NO;

	for(FLDatabaseColumn* col in self.columns.objectEnumerator) {
        BOOL useIt = NO;
        filter(col, &useIt, &cancel);
        if(cancel) {
            return nil;
        }
        if(useIt) {
        
            id data = [object valueForKey:col.decodedColumnName];
			
			if(data) {
                if(!values) {
                    values = [NSMutableDictionary dictionaryWithCapacity:self.columns.count];
                }
            
                [values setObject:data forKey:col.columnName];
			}
		}
	}

    return values;
}

- (id) objectForRow:(NSDictionary*) row {

    id newObject = FLAutorelease([[self.classRepresentedByTable alloc] init]);
    FLAssertIsNotNil(newObject);
    
    for(NSString* columnName in row) {
        id data = [row objectForKey:columnName];
        if(data && ![data isEqual:[NSNull null]]) {
            [newObject setValue:data forKey:FLDatabaseNameDecode(columnName)];
        }
    }
    
    return newObject;        
}

- (void) addColumnConstraint:(FLDatabaseColumnConstraint*) constraint forColumn:(FLDatabaseColumn*) column {
    NSMutableSet* constraints = [_columnConstraints objectForKey:column.columnName];
    if(!constraints) {
        constraints = [NSMutableSet setWithObject:constraint];
        [_columnConstraints setObject:constraints forKey:column.columnName];
    }
    else {
        [constraints addObject:constraint];
    }
    
    if([constraint isKindOfClass:[FLPrimaryKeyConstraint class]]) {
        [_primaryKeyColumns addObject:column.columnName]; 
        [_indexedColumns addObject:column.columnName];
    }
}

- (void) addColumnConstraint:(FLDatabaseColumnConstraint*) constraint forColumnName:(NSString*) columnName {
    FLDatabaseColumn* column = [self columnByName:columnName];
    FLConfirmNotNilWithComment(column, @"column %@ not found", column);
    [self addColumnConstraint:constraint forColumn:column];
}

@end

@implementation NSObject (FLDatabaseTable) 

+ (FLDatabaseTable*) sharedDatabaseTable { 
    return [[self objectDescriber] storageRepresentation];
}

+ (NSString*) databaseTableName {
	return NSStringFromClass(self);
}

- (FLDatabaseTable*) databaseTable {
    return [[self class] sharedDatabaseTable];
}

+ (void) databaseTableWillAddColumns:(FLDatabaseTable*) table {
}

+ (void) databaseTable:(FLDatabaseTable*) table willAddDatabaseColumn:(FLDatabaseColumn*) column {
}

+ (void) databaseTableDidAddColumns:(FLDatabaseTable*) table {
}

+ (void) didCreateDatabaseTable:(FLDatabaseTable*) table {

}

+ (SEL) databasePrimaryKeyColumn {
    return nil;
}


//+ (FLDatabaseTable*) createEmptySqliteTable
//{
//	FLDatabaseTable* table = [[super sharedDatabaseTable] copy];
//	if(!table)
//	{
//		table = [[FLDatabaseTable alloc] initWithTableName:[self databaseTableName]];
//	}
//	
//	return table;
//}


//- (FLDatabaseTable*) databaseTable
//{
//	return [[self class] sharedDatabaseTable];
//}

@end

@implementation FLSqlBuilder (FLSqlTable)

- (BOOL) appendWhereClauseForSelectingObject:(id) object {

    FLDatabaseTable* table = [[object class] sharedDatabaseTable];

    NSDictionary* searchValues = [table valuesForColumns:table.primaryKeyColumns inObject:object];
    
    if(!searchValues) {
        searchValues = [table valuesForColumns:table.indexedColumns inObject:object];
    }
    
    
    if(!searchValues) {
        return NO;
        // ??? 
    }

//    [self openListWithDelimiter:@", " withinParens:YES prefixDelimiterWithSpace:NO];
//
//    for(NSString* columnName in searchValue) {
//        [self appendString:columnName];
//    }
//
//    [self closeList];

    [self appendString:SQL_WHERE];
    
    [self openListWithDelimiter:SQL_AND withinParens:NO prefixDelimiterWithSpace:YES];
    for(NSString* colName in searchValues) {
        [self appendObject:[searchValues objectForKey:colName] comparedToString:colName withComparer:SQL_EQUAL];
    }
    [self closeList];

    return YES;
}

- (void) appendInsertClauseForObject:(id) object {

    FLDatabaseTable* table = [[object class] sharedDatabaseTable];
    
    [self openListWithDelimiter:@", " withinParens:YES prefixDelimiterWithSpace:NO];

    for(NSString* columnName in table.columns) {
        [self appendString:columnName];
    }

    [self closeList];

    [self appendString:SQL_VALUES];

    [self openListWithDelimiter:@", " withinParens:YES prefixDelimiterWithSpace:NO];

    for(FLDatabaseColumn* column in table.columns.objectEnumerator)
    {
        id obj = [object valueForKey:column.decodedColumnName];
        if(obj) {
            [self appendObject:obj];
        }
        else {
            [self appendObject:[NSNull null]]; // this binds to nil 
        }
    }

    [self closeList];
}


@end



