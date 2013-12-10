//
//  FLSqlBuilder.m
//  FishLampFrameworks
//
//  Created by Mike Fullerton on 8/16/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLSqlBuilder.h"
#import "NSString+Lists.h"
#import "FLSqlStatement.h"
#import "FLStringUtils.h"

#define SQL_PLACEHOLDER @"?"

@implementation FLSqlBuilder

@synthesize sqlString = _sqlString;
@synthesize objects = _dataToBind;

- (id) initWithString:(NSString*) string {
    self = [super init];
    if(self) {
        if(!string) {
            _sqlString = [[NSMutableString alloc] init];
        }
        else {
            _sqlString = [string mutableCopy];
        }
    }
    
    return self;
}

- (id) init {
    return [self initWithString:nil];
}

+ (id) sqlBuilderWithString:(NSString*) string {
    return FLAutorelease([[[self class] alloc] initWithString:string]);
}

- (NSInteger) length {
    return _sqlString.length;
}

- (void) setSqlString:(NSString*) string {
    [_sqlString setString:string];
    
    if(FLStringIsEmpty(_sqlString) || [_sqlString characterAtIndex:_sqlString.length - 1] == ' ' ) {
        _spaceDisableCount = 1;
    }
    else {
        _spaceDisableCount = 0;
    }
}


+ (FLSqlBuilder*) sqlBuilder {
    return FLAutorelease([[FLSqlBuilder alloc] init]);
}

- (void) bindToSqlStatement:(FLSqlStatement*) statement {

    FLAssertWithComment([_sqlString subStringCount_fl:@"?"] == self.objects.count,   
        @"binding failure. placeholder count:%ld, object count: %ld",
        (unsigned long) [_sqlString subStringCount_fl:@"?"],
        (unsigned long) self.objects.count);

    if(self.objects) {
        int parmIdx = 0;
        for(id object in self.objects) {
            [object bindToStatement:statement parameterIndex:++parmIdx];
        }
    }

    FLReleaseWithNil(_delimiter);
    FLReleaseWithNil(_dataToBind);
    self.sqlString = @"";
}
#if FL_MRC 
- (void) dealloc {
    FLRelease(_delimiter);
    FLRelease(_dataToBind);
    FLRelease(_sqlString);
    FLSuperDealloc();
}
#endif

- (void) appendString:(NSString*) string {
    
    if(_inList) {
        [self appendDelimiter:_delimiter insertSpace:_insertPrefixDelimiterSpace];
    }
    
    FLAssertWithComment(_spaceDisableCount >= 0, @"space disable less than zero");
    
    if(_spaceDisableCount == 0) {
        [_sqlString appendFormat:@" %@", string];
    }
    else {
        [_sqlString appendString:string];
        --_spaceDisableCount;
    }
}

- (void) appendDelimiter:(NSString*) delimiter
             insertSpace:(BOOL) insertSpace {

    if(_inList && _listCount++) {
        if(insertSpace) {
            [self appendString:delimiter];
        }
        else {
            [_sqlString appendString:delimiter];
        }
    }
}

- (void) openParen {
    _spaceDisableCount = 2;
    [self appendString:@"("];
}

- (void) closeParen {
    _spaceDisableCount = 1;
    [self appendString:@")"];
}

- (void) appendFormat:(NSString*) format, ... {

	va_list va_args;
	va_start(va_args, format);
	NSString *string = [[NSString alloc] initWithFormat:format arguments:va_args];
	va_end(va_args);
	[self appendString:string];
    FLRelease(string);
}

- (void) appendString:(NSString*) string andString:(NSString*) andString {
    [self appendString:string];
    
    if(FLStringIsNotEmpty(andString)) {
        [self appendString:andString];
    }
}

- (void) openListWithDelimiter:(NSString*) delimiter
                  withinParens:(BOOL) withinParens
      prefixDelimiterWithSpace:(BOOL) prefixDelimiterWithSpace {

    FLSetObjectWithRetain(_delimiter, delimiter);
    _insertPrefixDelimiterSpace = prefixDelimiterWithSpace;
    if(withinParens) {
        [self openParen];
    }
    _closeParens = withinParens;
    _inList = YES;
    _listCount = 0;
}


- (void) closeList {
    FLReleaseWithNil(_delimiter);
    _inList = NO;
    _listCount = 0;
    if(_closeParens) {
        [self closeParen];
    }
}

- (void) appendObject:(id) object
     comparedToString:(NSString*) string
         withComparer:(NSString*) compareString {

    if(!_dataToBind) {
        _dataToBind = [[NSMutableArray alloc] init];
    }

    [self appendFormat:@"%@%@?", string, compareString];

    [_dataToBind addObject:object];
}

- (void) appendObject:(id) data {
    if(!_dataToBind) {
        _dataToBind = [[NSMutableArray alloc] init];
    }

    [self appendString:@"?"];

    [_dataToBind addObject:data];
}

+ (NSString*)   sqlListFromArray:(NSArray*) list
                       delimiter:(NSString*) delimiter
                    withinParens:(BOOL) withinParens
        prefixDelimiterWithSpace:(BOOL) prefixDelimiterWithSpace
                     emptyString:(NSString*) emptyStringOrNil {

    if(list && list.count) {
    
		NSMutableString* sqlList = [NSMutableString stringWithString:[list objectAtIndex:0]];
		
        NSString* prefix = prefixDelimiterWithSpace ? @" " : @"";
            
		for(int i = 1; i < list.count; i++) {
			[sqlList appendFormat:@"%@%@ %@", prefix, delimiter, [list objectAtIndex:i]];
		}
        if(withinParens) {
            sqlList = [NSMutableString stringWithFormat:@"(%@)", sqlList];
        }
        return sqlList;
    }
    return emptyStringOrNil != nil ? emptyStringOrNil : @"";
}

+ (NSString*)   sqlListFromArray:(NSArray*) list
                       delimiter:(NSString*) delimiter
                    withinParens:(BOOL) withinParens
        prefixDelimiterWithSpace:(BOOL) prefixDelimiterWithSpace {
    return [self sqlListFromArray:list delimiter:delimiter withinParens:NO prefixDelimiterWithSpace:prefixDelimiterWithSpace emptyString:nil];
}

- (void) appendInsertClauseForRow:(NSDictionary*) row {

    [self openListWithDelimiter:@"," withinParens:YES prefixDelimiterWithSpace:NO];

    for(NSString* column in row) {
        [self appendString:column];
    }

    [self closeList];
    
    [self appendString:SQL_VALUES];

    [self openListWithDelimiter:@"," withinParens:YES prefixDelimiterWithSpace:NO];
    for(NSString* column in row) {
        [self appendObject: [row objectForKey:column]];
    }

    [self closeList];
}
@end
