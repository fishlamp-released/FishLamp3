//
//	FLObjectDatabase.m
//	FishLamp
//
//	Created by Mike Fullerton on 6/22/09.
//	Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLObjectDatabase.h"
#import "NSFileManager+FLExtras.h"
#import "FLDatabaseTable.h"
#import "NSArray+FLExtras.h"
#import "NSString+Lists.h"
#import "FLSqlBuilder.h"
#import "FLDatabase_Internal.h"
#import "NSBundle+FLVersion.h"
#import "FLObjectDescriber.h"
#import "FLPropertyDescriber.h"

@implementation FLObjectDatabase

- (void) deleteObject:(id) inputObject {
    FLAssertIsNotNilWithComment(inputObject, nil);
        
    FLDatabaseTable* table = [[inputObject class] sharedDatabaseTable];
    
    FLDatabaseStatement* statement = [FLDatabaseStatement databaseStatement:table];
    [statement appendString:SQL_DELETE];
    [statement appendString:SQL_FROM andString:table.tableName];

    if(![statement appendWhereClauseForSelectingObject:inputObject]) {
        FLThrowErrorCodeWithComment(FLObjectDatabaseErrorDomain, FLDatabaseErrorNoParametersSpecified, @"No parameters specified");
    }

    [self executeStatement:statement];
    
    FLPerformSelector1(inputObject, @selector(wasRemovedFromDatabase:), self);
}

- (NSArray*) readObjectsMatchingInputObject:(id) inputObject 
                              columnsFilter:(NSArray*) columnsFilter {
        
    FLAssertNotNil(inputObject);

    if(!inputObject) {
        return nil;
    }   

    __block NSMutableArray* outObjects = nil;
    
	FLDatabaseTable* table = [[inputObject class] sharedDatabaseTable];

    FLDatabaseStatement* statement = [FLDatabaseStatement databaseStatement:table];

    NSString* resultColumns = [FLSqlBuilder sqlListFromArray:columnsFilter 
                                                   delimiter:@"," 
                                                withinParens:NO 
                                    prefixDelimiterWithSpace:NO 
                                                 emptyString:SQL_ALL];
                                                 

    [statement appendString:SQL_SELECT andString:resultColumns];
    [statement appendString:SQL_FROM andString:table.tableName];
    
    if(![statement appendWhereClauseForSelectingObject:inputObject]) {
        FLAssertFailed();
    }
   
    statement.objectResultBlock = ^(id object, BOOL* stop) {
        
        if(!outObjects) {
            outObjects = [NSMutableArray arrayWithObject:object];
        }
        else {
            [outObjects addObject:object];
        }
    };
    
    statement.finished = ^{
        
    };
    
    [self executeStatement:statement];
    
    return outObjects;
}

- (NSArray*) readAllObjectsInTable:(FLDatabaseTable*) table {

    FLAssertNotNil(table);

    __block NSMutableArray* outObjects = nil;
	
    FLDatabaseStatement* statement = [FLDatabaseStatement databaseStatement:table];
    [statement appendString:SQL_SELECT andString:SQL_ALL];
    [statement appendString:SQL_FROM andString:table.tableName];
    
    statement.objectResultBlock = ^(id object, BOOL* stop) {
    
        if(!outObjects) {
            outObjects = [NSMutableArray arrayWithObject:object];
        }
        else {
            [outObjects addObject:object];
        }
    };
        
    [self executeStatement:statement];
    
    return outObjects;
}

- (NSArray*) readAllObjectsForClass:(Class) aClass {
	return [self readAllObjectsInTable:[aClass sharedDatabaseTable]];
}

- (NSUInteger) objectCountForClass:(Class) aClass {
    return [self rowCountForTable:[aClass sharedDatabaseTable]];
}

- (void) deleteAllObjectsForClass:(Class) aClass {
    [self dropTable:[aClass sharedDatabaseTable]];
}

- (id) readObject:(id) inputObject {
    FLAssertNotNil(inputObject);

    if(!inputObject) {
        return nil;
	}

    NSArray* array = [self readObjectsMatchingInputObject:inputObject];
	if(array) {
		if(array.count == 1) {
			return FLRetainWithAutorelease(([array objectAtIndex:0]));
		}
		else if(array.count > 1) {
			FLThrowErrorCodeWithComment(FLObjectDatabaseErrorDomain, FLDatabaseErrorTooManyObjectsReturned,
                             ([NSString stringWithFormat:@"Too many objects returned for input object of type: %@", NSStringFromClass([inputObject class])]));
		}
	}

	return nil;
}

- (NSArray*) readObjectsMatchingInputObject:(id) inputObject {
	return [self readObjectsMatchingInputObject:inputObject columnsFilter:nil];
}

- (BOOL) containsObject:(id) inputObject
{
	if(!inputObject) {
		FLThrowErrorCodeWithComment(FLObjectDatabaseErrorDomain, FLDatabaseErrorInvalidInputObject, @"null input object");
	}

    __block BOOL foundIt = NO;

	FLDatabaseTable* table = [[inputObject class] sharedDatabaseTable];
    FLDatabaseStatement* statement = [FLDatabaseStatement databaseStatement:table];
    
    // TODO: it'd be faster to just load only primary key columns instead of all columns

    [statement appendString:SQL_SELECT andString:SQL_ALL];
    [statement appendString:SQL_FROM andString:table.tableName];
    
    if(![statement appendWhereClauseForSelectingObject:inputObject]) {

        FLAssertFailedWithComment(@"No.");
    }
    
    statement.rowResultBlock = ^(NSDictionary* row, BOOL* stop) {
        foundIt = YES;
        *stop = YES;
    };
    
    [self executeStatement:statement];
    
    return foundIt;
}


- (void) writeObject:(id) object {
    FLDatabaseTable* table = [[object class] sharedDatabaseTable];
    FLDatabaseStatement* statement = [FLDatabaseStatement databaseStatement:table];
    [statement appendString:SQL_INSERT];
    [statement appendString:SQL_OR];
    [statement appendString:SQL_REPLACE];
    [statement appendString:SQL_INTO andString:table.tableName];
    [statement appendInsertClauseForObject:object];
    [self executeStatement:statement];
    
    FLPerformSelector1(object, @selector(wasSavedToDatabase:), self);

}

- (void) writeObjectsInArray:(NSArray*) array {
	if(array && array.count) {
        [self executeTransaction:^{
            for(id object in array) {
                [self writeObject:object];
            }
        }];
    }
}

//- (id) sqlStatement:(FLSqlStatement*) statement 
//   willDecodeObject:(NSData*) data 
//          forTable:(FLDatabaseTable*) table
//          forColumn:(FLDatabaseColumn*) column {
//
//    FLObjectDescriber* objectDescriber = [[table classRepresentedByTable] objectDescriber];
//
//    FLPropertyDescriber* property = [objectDescriber propertyForName:column.decodedColumnName];
//
//    if(property) {
//        return [property representedObjectFromSqliteColumnData:data];
//    }
//
//    return nil;
//}



@end






