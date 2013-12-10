//
//	FLObjectDatabase.h
//	FishLamp
//
//	Created by Mike Fullerton on 6/22/09.
//	Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//
#import "FishLampMinimum.h"
#import "FLDatabase.h"
#import "FLObjectStorage.h"
#import "FLService.h"

typedef enum {
    FLObjectDatabaseEventHintNone,
    FLObjectDatabaseEventHintLoaded,
    FLObjectDatabaseEventHintSaved
} FLObjectDatabaseEventHint;

#define FLObjectDatabaseErrorDomain @"FLObjectDatabaseErrorDomain"

typedef enum {
    FLDatabaseErrorNoError = 0,
	FLDatabaseErrorTooManyObjectsReturned,
	FLDatabaseErrorAlreadyOpen,
	FLDatabaseErrorInvalidInputObject,
	FLDatabaseErrorInvalidOutputObject,
	FLDatabaseErrorNoParametersSpecified,
	FLDatabaseErrorRequiredColumnIsNull,
    FLDatabaseErrorObjectNotFound
} FLDatabaseError;


@interface FLObjectDatabase : FLDatabase<FLObjectStorageExtended> {
@private
}

- (void) writeObject:(id) object;

- (void) writeObjectsInArray:(NSArray*) array; 

- (id) readObject:(id) inputObject;

- (void) deleteObject:(id) object;

- (BOOL) containsObject:(id) object;

- (NSArray*) readObjectsMatchingInputObject:(id) inputObject;

- (NSArray*) readObjectsMatchingInputObject:(id) inputObject
                              columnsFilter:(NSArray*) onlyTheseColumnsWillBeReturned;


- (void) deleteAllObjectsForClass:(Class) aClass;

// no params, loads everything. Careful now.
- (NSArray*) readAllObjectsForClass:(Class) aClass;

- (NSArray*) readAllObjectsInTable:(FLDatabaseTable*) table;

- (NSUInteger) objectCountForClass:(Class) aClass;

@end

@protocol FLOptionalDatabaseEvents <NSObject>
@optional
- (void) wasRemovedFromDatabase:(FLObjectDatabase*) database;
- (void) wasSavedToDatabase:(FLObjectDatabase*) database;
@end

