//
//  FLDatabaseStatement.m
//  FishLamp
//
//  Created by Mike Fullerton on 11/29/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLDatabaseStatement.h"

@interface FLDatabaseStatement ()
@property (readwrite, strong) FLDatabaseTable* table;
@end

@implementation FLDatabaseStatement

@synthesize prepare = _prepare;
@synthesize finished = _finished;
@synthesize rowResultBlock = _rowResultBlock;
@synthesize objectResultBlock = _objectResultBlock;
@synthesize failed = _failed;
@synthesize table = _table;

- (id) init {
    return [self initWithDatabaseTable:nil];
}

- (id) initWithDatabaseTable:(FLDatabaseTable*) table {
    self = [super init];
    if(self) {
        FLAssertNotNil(table);
        self.table = table;
    }
    
    return self;
}

+ (FLDatabaseStatement*) databaseStatement:(FLDatabaseTable*) table {
    return FLAutorelease([[[self class] alloc] initWithDatabaseTable:table]);
}

#if FL_MRC
- (void) dealloc {
    [_table release];
    [_finished release];
    [_rowResultBlock release];
    [_objectResultBlock release];
    [_failed release];
    [super dealloc];
}
#endif

@end