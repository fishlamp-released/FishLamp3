//
//  FLSqlBuilder.h
//  FishLampFrameworks
//
//  Created by Mike Fullerton on 8/16/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampMinimum.h"
@class FLSqlStatement;

#define SQL_ALL @"*"

#define SQL_SELECT                      @"SELECT"
#define SQL_FROM                        @"FROM"
#define SQL_WHERE                       @"WHERE"
#define SQL_DELETE                      @"DELETE"
#define SQL_AND                         @"AND"
#define SQL_OR                          @"OR"
#define SQL_VALUES                      @"VALUES"
#define SQL_INSERT                      @"INSERT"
#define SQL_REPLACE                     @"REPLACE"
#define SQL_INTO                        @"INTO"
#define SQL_BEGIN                       @"BEGIN"
#define SQL_BEGIN_TRANSACTION           @"BEGIN TRANSACTION"
#define SQL_END_TRANSACTION             @"END TRANSACTION"
#define SQL_ROLLBACK                    @"ROLLBACK"

#define SQL_EQUAL                       @"="
#define SQL_NOT_EQUAL                   @"!="

typedef enum {
    FLSqlSpaceNone,
    FLSqlSpaceLeading,
    FLSqlSpaceTrailing
} FLSqlSpace;

@interface FLSqlBuilder : NSObject {
@private
    NSMutableString* _sqlString;
    NSString* _delimiter;
    NSMutableArray* _dataToBind;

    NSInteger _listCount;
    NSInteger _spaceDisableCount;
    BOOL _inList;
    BOOL _closeParens;
    BOOL _insertPrefixDelimiterSpace;
}


@property (readwrite, nonatomic, copy) NSString* sqlString;

// objects are appended as placeholders "?" until the SQL statement is bound to data.
@property (readonly, nonatomic, strong) NSArray* objects;

- (id) initWithString:(NSString*) string;

+ (FLSqlBuilder*) sqlBuilder;
+ (FLSqlBuilder*) sqlBuilderWithString:(NSString*) string;

- (void) openParen;
- (void) closeParen;

- (void) appendString:(NSString*) string;
- (void) appendFormat:(NSString*) format, ... NS_FORMAT_FUNCTION(1,2);

- (void) appendString:(NSString*) string andString:(NSString*) andString;

- (void) openListWithDelimiter:(NSString*) delimiter
                  withinParens:(BOOL) withinParens
      prefixDelimiterWithSpace:(BOOL) prefixDelimiterWithSpace;

- (void) appendDelimiter:(NSString*) delimiter
             insertSpace:(BOOL) insertSpace;
                        
- (void) closeList;

- (void) appendObject:(id) object
     comparedToString:(NSString*) string
         withComparer:(NSString*) compareString; // e.g. SQL_EQUAL

- (void) appendObject:(id) data;

+ (NSString*)   sqlListFromArray:(NSArray*) list
                       delimiter:(NSString*) delimiter
                    withinParens:(BOOL) withinParens
        prefixDelimiterWithSpace:(BOOL) prefixDelimiterWithSpace
                     emptyString:(NSString*) emptyStringOrNil;

+ (NSString*)   sqlListFromArray:(NSArray*) list
                       delimiter:(NSString*) delimiter
                    withinParens:(BOOL) withinParens
        prefixDelimiterWithSpace:(BOOL) prefixDelimiterWithSpace;

- (void) appendInsertClauseForRow:(NSDictionary*) row;

- (void) bindToSqlStatement:(FLSqlStatement*) statement;

@end

