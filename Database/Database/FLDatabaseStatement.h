//
//  FLDatabaseStatement.h
//  FishLamp
//
//  Created by Mike Fullerton on 11/29/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampMinimum.h"

#import "FLSqlBuilder.h"
#import "FLDatabaseTable.h"

typedef void (^FLDatabaseStatementPrepareBlock)(BOOL* stop);
typedef void (^FLDatabaseStatementDidSelectRowBlock)(NSDictionary* row, BOOL* stop);
typedef void (^FLDatabaseStatementDidSelectObjectBlock)(id object, BOOL* stop);
typedef void (^FLDatabaseStatementFinishedBlock)();
typedef void (^FLDatabaseStatementFailedBlock)(NSError* error);

@interface FLDatabaseStatement : FLSqlBuilder {
@private
    FLDatabaseStatementPrepareBlock _prepare;
    FLDatabaseStatementDidSelectRowBlock _rowResultBlock;
    FLDatabaseStatementDidSelectObjectBlock _objectResultBlock;
    FLDatabaseStatementFinishedBlock _finished;
    FLDatabaseStatementFailedBlock _failed;
    FLDatabaseTable* _table;
}

@property (readonly, strong) FLDatabaseTable* table;

@property (readwrite, copy) FLDatabaseStatementPrepareBlock prepare;
@property (readwrite, copy) FLDatabaseStatementDidSelectRowBlock rowResultBlock;
@property (readwrite, copy) FLDatabaseStatementDidSelectObjectBlock objectResultBlock;
@property (readwrite, copy) FLDatabaseStatementFinishedBlock finished;
@property (readwrite, copy) FLDatabaseStatementFailedBlock failed;

- (id) initWithDatabaseTable:(FLDatabaseTable*) table;
+ (FLDatabaseStatement*) databaseStatement:(FLDatabaseTable*) table;


@end


