//
//  FLDatabase+Introspection.m
//  FishLampFrameworks
//
//  Created by Mike Fullerton on 8/17/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLDatabase+Introspection.h"

@implementation FLDatabase (Introspection)

- (NSArray*) tableNamesInDatabase {
	NSMutableArray* outArray = [NSMutableArray array];

	[self execute:@"SELECT name FROM sqlite_master WHERE type='table'" 
      rowResultBlock:^(NSDictionary *row, BOOL *stop) {
          NSString* name = [row objectForKey:@"name"];
          if(name) {
              [outArray addObject:name];
          }
      }];
	
	return outArray;
}

- (NSArray*) columnNamesForTableNamed:(NSString*) tableName {
    return [[self detailsForTableNamed:tableName] allKeys];
}

- (NSDictionary*) detailsForTableNamed:(NSString*) tableName {

	NSMutableDictionary* info = [NSMutableDictionary dictionary];
	[self executeSql:[FLSqlBuilder sqlBuilderWithString:[NSString stringWithFormat:@"PRAGMA table_info(%@)", tableName]]
      rowResultBlock:^(NSDictionary *row, BOOL *stop) {
          [info setObject:row forKey:[row objectForKey:@"name"]];
      }];

	return info;
}

- (NSArray*) indexesForTableNamed:(NSString*) tableName {
	return [self execute:[NSString stringWithFormat:@"PRAGMA index_list(%@)", tableName]];
}

- (NSArray*) detailsForIndexedNamed:(NSString*) indexName {
	return [self execute:[NSString stringWithFormat:@"PRAGMA index_info(%@)", indexName]];
}

- (NSUInteger) tableCount {
    __block NSUInteger count = 0;
    
    [self execute:@"SELECT COUNT(*) FROM sqlite_master WHERE type='table'" 
      rowResultBlock:^(NSDictionary* row, BOOL* stop) {
        
        NSNumber* number = [row objectForKey:@"COUNT(*)"];
        if(number) {
            count = [number integerValue];
            *stop = YES;
        }
    }];
    
	return count;
}

@end
