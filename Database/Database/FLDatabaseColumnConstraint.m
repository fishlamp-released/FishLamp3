//
//  FLDatabaseColumnConstraint.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 4/21/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLDatabaseColumnConstraint.h"


#define FLDatabaseColumnConstraintPrimaryKeyAsc @"PRIMARY KEY ASC NOT NULL UNIQUE"

NSString* FLSqlConflictActionString(FLDatabaseOnConflictAction action) {
	switch(action) {
		case FLDatabaseOnConflictActionAbort: // this is default. 
			return @"";
			
		case FLDatabaseOnConflictActionRollback:
			return @" ON CONFLICT ROLLBACK";
			
		case FLDatabaseOnConflictActionFail:
			return @" ON CONFLICT FAIL";
		
		case FLDatabaseOnConflictActionIgnore:
			return @" ON CONFLICT IGNORE";
			
		case FLDatabaseOnConflictActionReplace:
			return @" ON CONFLICT REPLACE";
	}

	return nil;
}

@interface FLDatabaseColumnConstraint()
@property (readwrite, strong) NSString* sqlString;

@end

@implementation FLDatabaseColumnConstraint
@synthesize sqlString = _sqlString;

- (id) initWithSqlString:(NSString*) sql {	
	self = [super init];
	if(self) {
        self.sqlString = sql;
	}
	return self;
}

#if FL_MRC
- (void) dealloc {
	[_sqlString release];
	[super dealloc];
}
#endif

- (BOOL)isEqual:(id)object {
    return [object isKindOfClass:[self class]] && FLStringsAreEqual(self.sqlString, [object sqlString]);
}

- (NSUInteger)hash {
    return [self.sqlString hash];
}

- (id) copyWithZone:(NSZone *)zone {
    return [[[self class] alloc] initWithSqlString:self.sqlString];
}

- (NSString*) description {
    return self.sqlString;
}

+ (NSString*) columnConstraintsAsString:(NSSet*) contraints {
	if(contraints && contraints.count) {
		NSMutableString* str = [NSMutableString string];
		
		for(id constraint in contraints) {
			if(str.length) {
				[str appendFormat:@" %@", [constraint sqlString]];
			}
			else {
				[str appendString:[constraint sqlString]];
			}
		}
			
		return str;
	}
	
	return @"";
}

@end


@implementation FLPrimaryKeyConstraint

+ (NSString*) primaryKeyConstraint {
    FLReturnStaticObject( FLAutorelease([[[self class] alloc] initWithSqlString:@"PRIMARY KEY ASC NOT NULL"]); );
}

+ (NSString*) primaryKeyConstraintWithSortOrder:(FLDatabaseSortOrder) sortOrder 
                                 conflictAction:(FLDatabaseOnConflictAction) conflictAction 
                                  autoIncrement:(BOOL) autoIncrement {

    NSString* sql = [NSString stringWithFormat:@"PRIMARY KEY %@ NOT NULL %@%@", 
		sortOrder == FLDatabaseSortOrderAsc ? @"ASC" : @"DESC",
		FLSqlConflictActionString(conflictAction),
		autoIncrement ? @" AUTOINCREMENT" : @""];

    return FLAutorelease([[[self class] alloc] initWithSqlString:sql]);
}
@end

@implementation FLUniqueConstraint

+ (id) uniqueConstraintWithConflictAction:(FLDatabaseOnConflictAction) conflictAction {

    NSString* sql = [NSString stringWithFormat:@"UNIQUE%@", FLSqlConflictActionString(conflictAction)];

	return FLAutorelease([[[self class] alloc] initWithSqlString:sql]);
    
}

+ (id) uniqueConstraint {
	return FLAutorelease([[[self class] alloc] initWithSqlString: @"UNIQUE"]);
}
@end

@implementation FLNotNullConstraint

+ (id) notNullConstraintWithConflictAction:(FLDatabaseOnConflictAction) conflictAction {
    NSString* sql = [NSString stringWithFormat:@"NOT NULL%@", FLSqlConflictActionString(conflictAction)];
	return FLAutorelease([[[self class] alloc] initWithSqlString:sql]);
}

+ (id) notNullConstraint {
	FLReturnStaticObject( FLAutorelease([[[self class] alloc] initWithSqlString: @"NOT NULL"]););
}

@end

