//
//  FLDatabaseColumn.h
//  FishLamp
//
//  Created by Mike Fullerton on 5/27/11.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampMinimum.h"

@class FLDatabase;
@class FLDatabaseTable;
@class FLDatabaseColumn;

#import "FLDatabaseIndex.h"
#import "FLDatabaseDefines.h"
#import "FLDatabaseColumnConstraint.h"

@interface FLDatabaseColumn : NSObject<NSCopying> {
@private
	NSString* _name;
	NSString* _decodedColumnName;
	FLDatabaseType _columnType;

// deprecated
	NSArray* _columnConstraints;
}

@property (readonly, strong, nonatomic) NSString* columnName;
@property (readonly, strong, nonatomic) NSString* decodedColumnName;
@property (readonly, assign, nonatomic) FLDatabaseType columnType;

- (id) initWithColumnName:(NSString*) name
               columnType:(FLDatabaseType) columnType;

+ (FLDatabaseColumn*) databaseColumnWithName:(NSString*) name
                                  columnType:(FLDatabaseType) columnType;

@end


@interface FLDatabaseColumn ()
// deprecated

- (id) initWithColumnName:(NSString*) name
               columnType:(FLDatabaseType) columnType
        columnConstraints:(NSArray*) columnConstraints;

+ (FLDatabaseColumn*) databaseColumnWithName:(NSString*) name
                                    columnType:(FLDatabaseType) columnType
                             columnConstraints:(NSArray*) columnConstraints;

@property (readwrite, strong, nonatomic) NSArray* columnConstraints;

@end
