//
//  FLDatabaseColumnConstraint.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 4/21/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampCore.h"
#import "FLDatabaseSqlWriter.h"

typedef enum {
	FLDatabaseOnConflictActionAbort,
	FLDatabaseOnConflictActionRollback,
	FLDatabaseOnConflictActionFail,
	FLDatabaseOnConflictActionIgnore,
	FLDatabaseOnConflictActionReplace,
	
	FLDatabaseOnConflictActionDefault = FLDatabaseOnConflictActionAbort
} FLDatabaseOnConflictAction;
	
typedef enum { 
	FLDatabaseSortOrderAsc,
	FLDatabaseSortOrderDesc
} FLDatabaseSortOrder;	

// TODO: add check constraint
// TODO: add default constraint
// TODO: add collation contraint


@interface FLDatabaseColumnConstraint : NSObject<FLDatabaseSqlWriter, NSCopying> {
@private
    NSString* _sqlString;
}

+ (NSString*) columnConstraintsAsString:(NSSet*) contraints;

@end

@interface FLPrimaryKeyConstraint : FLDatabaseColumnConstraint 

+ (id) primaryKeyConstraint;

+ (id) primaryKeyConstraintWithSortOrder:(FLDatabaseSortOrder) sortOrder 
                          conflictAction:(FLDatabaseOnConflictAction) conflictAction 
                           autoIncrement:(BOOL) autoIncrement; // auto increment only valid if type is INTEGER

@end

@interface FLUniqueConstraint : FLDatabaseColumnConstraint 
+ (id) uniqueConstraint;
+ (id) uniqueConstraintWithConflictAction:(FLDatabaseOnConflictAction) conflictAction;
@end

@interface FLNotNullConstraint : FLDatabaseColumnConstraint 
+ (id) notNullConstraint;
+ (id) notNullConstraintWithConflictAction:(FLDatabaseOnConflictAction) conflictAction;
@end