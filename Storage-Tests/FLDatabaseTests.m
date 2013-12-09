//
//  FLDatabase+FLTestCase.m
//  Fishlamp
//
//  Created by Mike Fullerton on 6/20/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLDatabaseTests.h"
#import "FLTempFolder.h"
#import "FLDatabase.h"

#import "FLTestable.h"
#import "FLModelObject.h"


@implementation FLDatabaseTests
@synthesize database = _database;

#if FL_MRC
- (void) dealloc {
	[_database release];
	[super dealloc];
}
#endif

//+ (Class) testGroupClass {
//    return @"FishLampNetworking";
//}

- (id) createDatabase:(NSString*) filePath {
    return FLAutorelease([[FLDatabase alloc] initWithFilePath:filePath]);
}

- (void) firstTest {
    FLTempFolder* folder = [FLTempFolder tempFolder];
    [folder createIfNeeded];
    
    NSString* path = [NSString stringWithFormat:@"%@.sqlite", NSStringFromClass([self class])];
    
    _database = FLRetain([self createDatabase:[folder pathForFile:path]]);
    
    [_database openDatabase:FLDatabaseOpenFlagsDefault];
    FLAssertWithComment([_database isOpen], @"database is not open");
}

- (void) lastTest {

    [_database closeDatabase];
    [_database deleteOnDisk];
}

- (void) testIsOpen {
    FLAssertIsNotNil(_database);
    FLAssertWithComment([_database isOpen], @"database is not open");
}

@end

