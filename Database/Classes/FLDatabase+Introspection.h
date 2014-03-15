//
//  FLDatabase+Introspection.h
//  FishLampFrameworks
//
//  Created by Mike Fullerton on 8/17/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLDatabase.h"

@interface FLDatabase (Introspection)

//
// useful commands
// see http://sqlite.org/pragma.html#pragma_index_list
//

// This returns info from PRAGMA table_info
- (NSDictionary*) detailsForTableNamed:(NSString*) tableName; // keys are columnname strings.

- (NSArray*) columnNamesForTableNamed:(NSString*) tableName;

- (NSArray*) indexesForTableNamed:(NSString*) tableName;

- (NSArray*) detailsForIndexedNamed:(NSString*) indexName;

/// returns array populated with all the names of the tables in the database.
- (NSArray*) tableNamesInDatabase;

/// returns total count of tables in database
- (NSUInteger) tableCount;

@end
