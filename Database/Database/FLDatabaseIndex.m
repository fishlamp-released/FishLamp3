//
//  FLDatabaseIndex.m
//  FishLamp
//
//  Created by Mike Fullerton on 7/3/11.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton.
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLDatabaseIndex.h"
#import "FLDatabase_Internal.h"

@interface FLDatabaseIndex ()
@property (readwrite, strong, nonatomic) NSString* columnName;
@property (readwrite, assign, nonatomic) FLDatabaseColumnIndexProperties indexProperties;

@end

@implementation FLDatabaseIndex

@synthesize columnName = _columnName;
@synthesize indexProperties = _indexMask;

- (id) initWithColumnName:(NSString*) columnName indexProperties:(FLDatabaseColumnIndexProperties) indexProperties {
	if((self = [super init])) {
		self.columnName = columnName;
		self.indexProperties = indexProperties;
	}
	
	return self;
}

#if FL_MRC
- (void) dealloc {
    [_columnName release];
    [super dealloc];
}
#endif

+ (FLDatabaseIndex*) databaseIndex:(NSString*) columnName 
                   indexProperties:(FLDatabaseColumnIndexProperties) indexProperties {

	return FLAutorelease([[FLDatabaseIndex alloc] initWithColumnName:columnName indexProperties:indexProperties]);
}

- (void) setColumnName:(NSString*) columnName {
    FLSetObjectWithRetain(_columnName, FLDatabaseNameEncode(columnName));
}

- (id) copyWithZone:(NSZone *)zone {
	return [[FLDatabaseIndex alloc] initWithColumnName:self.columnName indexProperties:self.indexProperties];
}

- (NSString*) createIndexSqlForTableName:(NSString*) tableName {

	NSMutableString* sql = [NSMutableString stringWithString:@"CREATE"];

	if(FLTestBits(_indexMask, FLDatabaseColumnIndexPropertyUnique)) {
		[sql appendString:@" UNIQUE"];
	}

	[sql appendFormat:@" INDEX idx_%@_%@ ON %@ (%@", // IF NOT EXISTS
		tableName, 
		self.columnName,
		tableName, 
		self.columnName];
	
	if(FLTestBits(_indexMask, FLDatabaseColumnIndexPropertyCollateBinary))
	{
		[sql appendString:@" COLLATE BINARY"];
	}
	else if(FLTestBits(_indexMask, FLDatabaseColumnIndexPropertyCollateNoCase))
	{
		[sql appendString:@" COLLATE NOCASE"];
	}
	else if(FLTestBits(_indexMask, FLDatabaseColumnIndexPropertyCollateTrim))
	{
		[sql appendString:@" COLLATE RTRIM"];
	}
	
	if(FLTestBits(_indexMask, FLDatabaseColumnIndexPropertyAsc))
	{
		[sql appendString:@" ASC"];
	}
	else if(FLTestBits(_indexMask, FLDatabaseColumnIndexPropertyDesc))
	{
		[sql appendString:@" DESC"];
	}

	[sql appendString:@")"];
	
	return sql;
}

@end
