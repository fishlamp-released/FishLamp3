//
//  FLDatabaseColumn.m
//  FishLamp
//
//  Created by Mike Fullerton on 5/27/11.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLDatabaseColumn.h"
#import "FLDatabase_Internal.h"

@interface FLDatabaseColumn ()
@property (readwrite, strong, nonatomic) NSString* columnName;
@property (readwrite, strong, nonatomic) NSString* decodedColumnName;
@property (readwrite, assign, nonatomic) FLDatabaseType columnType;
@end

@implementation FLDatabaseColumn

@synthesize columnName = _name;
@synthesize columnConstraints = _columnConstraints;
@synthesize decodedColumnName = _decodedColumnName;
@synthesize columnType = _columnType;

- (id) initWithColumnName:(NSString*) name 
               columnType:(FLDatabaseType) columnType  {

    FLAssertStringIsNotEmpty(name);
    FLAssert(columnType != FLDatabaseTypeInvalid);

	if((self = [super init])) {
		self.columnName = name;
		self.columnType = columnType;
	}
	return self;
}

- (id) initWithColumnName:(NSString*) name 
               columnType:(FLDatabaseType) columnType  
        columnConstraints:(NSArray*) constraints {

	if((self = [self initWithColumnName:name columnType:columnType])) {
        self.columnConstraints = constraints;
    }
	return self;
}

- (id) init {
    return [self initWithColumnName:nil columnType:FLDatabaseTypeInvalid];
}


+ (FLDatabaseColumn*) databaseColumnWithName:(NSString*) name 
                                  columnType:(FLDatabaseType) columnType {
                           
	return FLAutorelease([[FLDatabaseColumn alloc] initWithColumnName:name columnType:columnType]);
}

+ (FLDatabaseColumn*) databaseColumnWithName:(NSString*) name 
                                  columnType:(FLDatabaseType) columnType  
                           columnConstraints:(NSArray*) columnConstraints {
                           
	return FLAutorelease([[FLDatabaseColumn alloc] initWithColumnName:name columnType:columnType columnConstraints:columnConstraints]);
}

- (void) setColumnName:(NSString*) columnName {
	FLSetObjectWithRetain(_name, FLDatabaseNameEncode(columnName));
	FLSetObjectWithRetain(_decodedColumnName, FLDatabaseNameDecode(columnName));
}

#if FL_MRC
- (void) dealloc {
	[_decodedColumnName release];
    [_columnConstraints release];
    [_name release];
    [super dealloc];
}
#endif


- (id) copyWithZone:(NSZone *)zone {
	return [[FLDatabaseColumn alloc] initWithColumnName:self.columnName 
                                             columnType:self.columnType];
}

- (BOOL)isEqual:(id)object {
    return [object isKindOfClass:[self class]] && FLStringsAreEqual(self.columnName, [object columnName]);
}

- (NSUInteger)hash {
    return [self.columnName hash];
}

- (NSString*) description {
    return [NSString stringWithFormat:@"%@ { propertyName: %@, columnName: %@, columnType: %d }", 
        [super description],
        self.decodedColumnName, 
        self.columnName, 
        self.columnType];
}


@end
