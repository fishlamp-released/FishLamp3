//
//  FLSqlStatement.m
//  FishLamp
//
//  Created by Mike Fullerton on 11/29/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLSqlStatement.h"
#import "FLGuid.h"
#import "FLSqlBuilder.h"
#import "FLDatabase_Internal.h"
#import "FLDatabaseObjectSerializer.h"

NS_INLINE
sqlite3_stmt* FLStatmentFailed(	sqlite3_stmt* stmt) {
    FLConfirmationFailedWithComment(@"sqlite statement is nil");
    return stmt;
}

#define statement_ (_sqlite3_stmt != nil ? _sqlite3_stmt : FLStatmentFailed(_sqlite3_stmt))

@interface FLSqlStatement ()
@property (readwrite, strong) FLDatabase* database;

// column objects
@property (readonly, assign) int columnCount;
- (NSString*) nameForColumn:(int) column;
- (int) typeForColumn:(int) column;
- (NSNumber*) integerForColumn:(int) col;
- (NSNumber*) doubleForColumn:(int) col;
- (NSData*) blobForColumn:(int) col;
- (NSString*) textForColumn:(int) col;

// raw sql columns
- (const void *) column_blob:(int) columnIndex;
- (int) column_bytes:(int) columnIndex;
- (int) column_bytes16:(int) columnIndex;
- (double) column_double:(int) columnIndex;
- (int) column_int:(int) columnIndex;
- (sqlite3_int64) column_int64:(int) columnIndex;
- (const unsigned char*) column_text:(int) columnIndex;
- (const void *) column_text16:(int) columnIndex;
- (int) column_type:(int) columnIndex;
- (sqlite3_value*) column_value:(int) columnIndex;

// binding
- (void) bindBlob:(int) parameterIndex data:(NSData*) data;
- (void) bindZeroBlob:(int) parameterIndex size:(int) size;
- (void) bindDouble:(int) parameterIndex doubleValue:(double) aDouble;
- (void) bindInt:(int) parameterIndex intValue:(int) aInt;
- (void) bindInt64:(int) parameterIndex intValue:(sqlite3_int64) aInt;
- (void) bindNull:(int) parameterIndex;
- (void) bindText:(int) parameterIndex text:(NSString*) text; // encodes as utf8

- (int) bindParameterCount;
- (const char *) bindParameterName:(int) idx;
- (int) bindParameterIndex:(const char*) zName;

- (void) clearBindings;

@end





@implementation FLSqlStatement

@synthesize database = _database;
@synthesize stepValue = _stepValue;
@synthesize delegate = _delegate;
@synthesize table = _table;

+ (id) sqlStatement:(FLDatabase*) database {
    return FLAutorelease([[[self class] alloc] initWithDatabase:database table:nil]);
}

+ (id) sqlStatement:(FLDatabase*) database table:(FLDatabaseTable*) table {
    return FLAutorelease([[[self class] alloc] initWithDatabase:database table:table]);
}

- (id) initWithDatabase:(FLDatabase*) database {
    return [self initWithDatabase:database table:nil];
}

- (id) initWithDatabase:(FLDatabase*) database table:(FLDatabaseTable*) table{
    self = [super init];
    if(self) {
        self.database = database;
        self.delegate = database;
        self.table = table;
        FLAssertNotNil(_database);
    }
    return self;
}

#if FL_MRC
- (void) dealloc {
    [_table release];
    [_database release];
    [super dealloc];
}
#endif

- (void) prepareWithSql:(FLSqlBuilder*) sql {

    FLAssertNotNilWithComment(sql, @"empty sql");
    FLAssertIsNilWithComment(_sqlite3_stmt, @"statement already open");

    const char* sql_c = [[sql sqlString] UTF8String];
    
    if(sqlite3_prepare_v2(_database.sqlite3, sql_c, -1, &_sqlite3_stmt, nil)) {
        [_database throwSqliteError:sql_c];
    }
    
    [sql bindToSqlStatement:self];
}

//- (void) bindAndPrepareStatementForWrite:(NSString *)sqlStatement forObject:(id) object {
//
//    int idx = 1;
//    for(FLDatabaseColumn* column in self.table.columns.objectEnumerator)
//    {
//        id dataToSave = [object valueForKey:column.decodedColumnName];
//                                        
//        if(dataToSave) {
//            [dataToSave bindToStatement:self parameterIndex:idx];
//        }
//        else {
//            [self bindNull:idx];
//        }
//        
//        ++idx;
//    }
//}

- (void) bindBlob:(int) parameterIndex data:(NSData*) data {
	if(!data || data.length == 0) {
		[self bindNull:parameterIndex];
	}
	else {
		if(sqlite3_bind_blob(statement_, parameterIndex, data.bytes, (int) data.length, SQLITE_TRANSIENT)) {
			[_database throwSqliteError:nil];
		}	
	}
}

- (void) bindZeroBlob:(int) parameterIndex size:(int) size  {
	if(sqlite3_bind_zeroblob(statement_, parameterIndex, size)) {
		[_database throwSqliteError:nil];
	}	
}

- (void) bindDouble:(int) parameterIndex doubleValue:(double) aDouble {
	if(sqlite3_bind_double(statement_, parameterIndex, aDouble)) {
		[_database throwSqliteError:nil];
	}	
}

- (void) bindInt:(int) parameterIndex intValue:(int) aInt {
	if(sqlite3_bind_int(statement_, parameterIndex, aInt)) {
		[_database throwSqliteError:nil];
	}	
}

- (void) bindInt64:(int) parameterIndex intValue:(sqlite3_int64) aInt {
	if(sqlite3_bind_int64(statement_, parameterIndex, aInt)) {
		[_database throwSqliteError:nil];
	}	
}

- (void) bindNull:(int) parameterIndex {
	int result = sqlite3_bind_null(statement_, parameterIndex);
	if(result) {
		[_database throwSqliteError:nil];
	}	
}

- (void) bindText:(int) parameterIndex text:(NSString*) text 
{
	if(!text || text.length == 0) {
		[self bindNull:parameterIndex];
	}
	else {
		const char* utf8String = [text UTF8String];
		if(sqlite3_bind_text(statement_, parameterIndex, utf8String, (int) strlen(utf8String), SQLITE_TRANSIENT)) {
			[_database throwSqliteError:nil];
		}	
	}
}

- (int) bindParameterCount {
	return sqlite3_bind_parameter_count(statement_);
}

- (const char *) bindParameterName:(int) idx {
	return sqlite3_bind_parameter_name(statement_, idx);
}

- (int) bindParameterIndex:(const char*) zName {
	return sqlite3_bind_parameter_index(statement_, zName);
}

- (void) clearBindings {
	if(sqlite3_clear_bindings(statement_)) {
		[_database throwSqliteError:nil];
	}	
}

- (const void *) column_blob:(int) columnIndex {
    return sqlite3_column_blob(statement_, columnIndex);
}

- (int) column_bytes:(int) columnIndex {
    return sqlite3_column_bytes(statement_, columnIndex);
}

- (int) column_bytes16:(int) columnIndex {
    return sqlite3_column_bytes16(statement_, columnIndex);
}

- (double) column_double:(int) columnIndex {
    return sqlite3_column_double(statement_, columnIndex);
}

- (int) column_int:(int) columnIndex {
    return sqlite3_column_int(statement_, columnIndex);
}

- (sqlite3_int64) column_int64:(int) columnIndex {
    return sqlite3_column_int64(statement_, columnIndex);
}

- (const unsigned char*) column_text:(int) columnIndex {
    return sqlite3_column_text(statement_, columnIndex);
}

- (const void *) column_text16:(int) columnIndex {
    return sqlite3_column_text16(statement_, columnIndex);
}

- (int) column_type:(int) columnIndex {
    return sqlite3_column_type(statement_, columnIndex);
}

- (sqlite3_value*) column_value:(int) columnIndex {
    return sqlite3_column_value(statement_, columnIndex);
}

- (NSNumber*) integerForColumn:(int) col {
	long long intValue = [self column_int64:col];
	
    if(intValue == 0) {
		return [NSNumber numberWithInt:(int)0];
	}
	else if(intValue >= INT32_MAX || intValue <= INT32_MIN) {
		return [NSNumber numberWithLongLong:intValue];
	}
	else if(intValue >= INT16_MAX || intValue <= INT16_MIN) {
		return [NSNumber numberWithLong:(long)intValue];
	}
	else if(intValue >= INT8_MAX || intValue <= INT8_MIN) {
		return [NSNumber numberWithShort:(short)intValue];
	}
	else {
		return [NSNumber numberWithChar:(char)intValue];
	}

	return nil;
}

- (NSString*) textForColumn:(int) col {
	NSString* outString = nil;
	const char* cstr = (const char*) sqlite3_column_text(statement_, col);
	if(cstr) {
		outString = FLAutorelease([[NSString alloc] initWithUTF8String:cstr]);
	}
	
	return outString;
}

- (NSData*) blobForColumn:(int) col {
	return [NSData dataWithBytes:sqlite3_column_blob(statement_, col) 
													length:sqlite3_column_bytes(statement_, col)];
}


- (BOOL) isDone {
    return self.stepValue == SQLITE_DONE;
}

//- (id) decodeColumnData:(id) data forTable:(FLDatabaseTable*) table forColumn:(FLDatabaseColumn*) column {
//    
//    if(column.columnType == FLDatabaseIgnored) {
//        FLObjectWrapper* wrapper = [NSKeyedUnarchiver unarchiveObjectWithData:data]
//        return wrapper ? wrapper.object;
//    }
//
//    
////    switch(column.columnType) {
////        case FLDatabaseIgnored:
////            FLAssertFailedWithComment(@"invalid column type");
////            return nil;
////            break;
////            
////        case FLDatabaseIgnored:
////        case FLDatabaseIgnored:
////            return nil;
////            break;
////            
////        case FLDatabaseIgnored:
////        case FLDatabaseIgnored: 
////            FLConfirmIsNotNil(data);
////            FLAssertWithComment([data isKindOfClass:[NSNumber class]], @"expecting a number here");
////            return [_delegate sqlStatement:self willDecodeNumber:data forTable:table forColumn:column];
////        break;
////        
////        case FLDatabaseIgnored:
////            FLConfirmIsKindOfClass(data, NSString);
////            return [_delegate sqlStatement:self willDecodeString:data forTable:table  forColumn:column];
////        break;
////			
////        case FLDatabaseIgnored:
////            FLConfirmIsKindOfClass(data, NSNumber);
////            return [_delegate sqlStatement:self willDecodeDate:data forTable:table forColumn:column];
////        break;
////			
////        case FLDatabaseIgnored:
////            FLConfirmIsNotNil(data);
////            FLConfirmIsKindOfClass(data, NSData);
////            return [_delegate sqlStatement:self willDecodeBlob:data forTable:table forColumn:column];
////        break;
////			           
////        case FLDatabaseIgnored:
////            FLConfirmIsNotNil(data);
////            FLConfirmIsKindOfClass(data, NSData);
////            return [_delegate sqlStatement:self willDecodeObject:data forTable:table forColumn:column];
////        break;
////    }
//    
//    return data;
//}


- (NSDictionary*) nextRow {

	int columnCount = self.columnCount;
	NSMutableDictionary* row = nil;
	
	if(columnCount) {
        row = [NSMutableDictionary dictionaryWithCapacity:columnCount]; 
        for(int i = 0; i < columnCount; i++) {
            NSString* colName = [self nameForColumn:i];
            
            id data = nil;
            switch([self typeForColumn:i])
            {
                case SQLITE_INTEGER:
                    data = [self integerForColumn:i];
                    FLAssertIsNotNil(data);
                break;
                
                case SQLITE_FLOAT:
                    if([_table columnByName:colName].columnType == FLDatabaseTypeDate) {
                    
                        NSTimeInterval time = sqlite3_column_double(statement_, i);
                    
                        NSTimeInterval timeZoneOffset = [[NSTimeZone defaultTimeZone] secondsFromGMT]; 
        
                        time += timeZoneOffset;

                        data = [NSDate dateWithTimeIntervalSinceReferenceDate:time];
                    }
                    else {
                        data = [self doubleForColumn:i];
                    }
                    FLAssertIsNotNil(data);
                    
                    
                break;
                
                case SQLITE_BLOB: {
                    data = [self blobForColumn:i];
                    FLAssertIsNotNil(data);
                    
                    FLDatabaseObjectSerializer* wrapper = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                    if(wrapper) {
                        data = FLRetainWithAutorelease(wrapper.object);
                    }
                }
                break;
                
                case SQLITE_NULL:
                    data = nil; // to be clear, we don't inflate to NSNULL
                break;
                
                case SQLITE_TEXT:
                    data = [self textForColumn:i];
                    FLAssertIsNotNil(data);
                break;
            }
        
            if(data) {
                [row setObject:data forKey:colName];
            }
        }
	}
    return row;
}

- (NSDictionary*) step {

    NSDictionary* row = nil;

    _stepValue = sqlite3_step(statement_);
    
    switch(_stepValue) {
        case SQLITE_ROW:
            row = [self nextRow];

            FLDbLog(@"%@ -> %@", self.database.fileName, [row description]);
        break;

        case SQLITE_DONE:
            [self finalizeStatement];
        break;

        case SQLITE_BUSY:
        // start over. note we don't support transaction yet, but if we do it will need to be rolled back here
            [self resetStatement];
        break;

        case SQLITE_OK:
            FLAssertFailedWithComment(@"not expecting SQLITE_OK here");
            break;
            
        default:
        case SQLITE_MISUSE:
        case SQLITE_ERROR:
            [_database throwSqliteError:sqlite3_sql(statement_)];
            break;
    } 

	return row;
}

- (NSNumber*) doubleForColumn:(int) col {
	return [NSNumber numberWithDouble:sqlite3_column_double(statement_, col)] ;
}

- (int) columnCount {
    return sqlite3_column_count(statement_);
}

- (NSString*) nameForColumn:(int) column {
    const char* c_colName = sqlite3_column_name(statement_, column);
    NSString* colName = [NSString stringWithCString:c_colName encoding:NSUTF8StringEncoding];
    FLAssertStringIsNotEmptyWithComment(colName, nil);
                
    return colName;
}

- (int) typeForColumn:(int) column {
    return sqlite3_column_type(statement_, column);
}

- (void) resetStatement {
	sqlite3_reset(statement_);
    _stepValue = 0;
}

- (void) finalizeStatement {
	if(_sqlite3_stmt) {
        FLDbLog(@"%@ -> DONE", self.database.fileName);
		sqlite3_finalize(_sqlite3_stmt);
		_sqlite3_stmt = nil;
	}
}

@end

@implementation NSNumber (FLSqlStatement)
- (void) bindToStatement:(FLSqlStatement*) statement parameterIndex:(int) parameterIndex {
	
    switch(CFNumberGetType(FLBridge(CFNumberRef, self))) {
		case kCFNumberCGFloatType: 
		case kCFNumberDoubleType:
		case kCFNumberFloatType:
		case kCFNumberFloat32Type:
		case kCFNumberFloat64Type:
			[statement bindDouble:parameterIndex doubleValue:[self doubleValue]];
		break;
		
		case kCFNumberSInt64Type:
		case kCFNumberLongLongType:
			[statement bindInt64:parameterIndex intValue:[self longLongValue]];
		break;
		
		case kCFNumberCFIndexType:
		case kCFNumberCharType:
		case kCFNumberShortType:
		case kCFNumberIntType:
		case kCFNumberLongType:
		case kCFNumberSInt8Type:
		case kCFNumberSInt16Type:
		case kCFNumberSInt32Type:
        case kCFNumberNSIntegerType:
			[statement bindInt:parameterIndex intValue:[self intValue]];
		break;
	}
}

+ (FLDatabaseType) databaseColumnType {
    return FLDatabaseTypeInteger;
}

@end


@implementation NSDate (FLSqlStatement) 
- (void) bindToStatement:(FLSqlStatement*) statement parameterIndex:(int) parameterIndex {

    NSTimeInterval time = [self timeIntervalSinceReferenceDate];

    NSTimeInterval timeZoneOffset = [[NSTimeZone defaultTimeZone] secondsFromGMT]; 
    
    time -= timeZoneOffset;
	
    FLTrace(@"%@", [NSDate dateWithTimeIntervalSinceReferenceDate:time]);
    
    [statement bindDouble:parameterIndex doubleValue:time];
}
+ (FLDatabaseType) databaseColumnType {
    return FLDatabaseTypeDate;
}
@end

@implementation NSString (FLSqlStatement) 
- (void) bindToStatement:(FLSqlStatement*) statement parameterIndex:(int) parameterIndex {
	[statement bindText:parameterIndex text:self];
}

+ (FLDatabaseType) databaseColumnType {
    return FLDatabaseTypeText;
}
@end

@implementation NSObject (FLSqlStatement)



- (void) bindToStatement:(FLSqlStatement*) statement parameterIndex:(int) parameterIndex {
    
    id archivable = [self databaseRepresentation]; 

	if(archivable) {
        FLAssert([archivable conformsToProtocol:@protocol(NSCoding)]);
    
        FLDatabaseObjectSerializer* wrapper = [FLDatabaseObjectSerializer objectSerializer:archivable];
        NSData* encodedData = [NSKeyedArchiver archivedDataWithRootObject:wrapper]; 
		[statement bindBlob:parameterIndex data:encodedData];
	}
	else {
        FLLog(@"Warning: trying to archive object %@ that doesn't conform to NSCoding protocol. Implement databaseRepresentation and objectWithDatabaseRepresentation for this class", NSStringFromClass([self class]));
		[statement bindNull:parameterIndex];
	}
}
//+ (FLDatabaseIgnored) sqlType {
//	return [self conformsToProtocol:@protocol(NSCoding)] ? FLDatabaseIgnored : FLDatabaseIgnored;
//}
@end

//#import "FishLampMinimum.h"

//@implementation SDKImage (FLSqlStatement)
////+ (id) decodeObjectWithSqliteColumnData:(NSData*) data {
////	return [SDKImage imageWithData:data];
////}
////- (void) bindToStatement:(FLSqlStatement*) statement parameterIndex:(int) parameterIndex {
////FIXME("osx");
////#if IOS
////	NSData* data = SDKImageJPEGRepresentation(self, 1.0f);
////	[data bindToStatement:statement parameterIndex:parameterIndex];
////#endif    
////}
////+ (FLDatabaseIgnored) sqlType {
////	return FLDatabaseIgnored;
////}
//@end

//@implementation SDKColor (FLDatabaseIterator) 
//- (void) bindToStatement:(FLDatabaseIterator*) statement parameterIndex:(int) parameterIndex
//{
//	[statement bindText:parameterIndex text:[self toRgbString]];
//}
//+ (FLDatabaseIgnored) sqlType
//{
//	return FLDatabaseIgnored;
//}
//@end

