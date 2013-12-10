////
////  FLDefaultSqlColumnDecoder.m
////  FishLampFrameworks
////
////  Created by Mike Fullerton on 8/14/12.
////  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
////
//
//#import "FLDatabaseColumnDecoder.h"
//#import "FLDatabase.h"
//#import "FLDatabaseTable.h"
//#import "FLDatabaseColumn.h"
//#import "FLObjectDescriber.h"
//#import "FLBase64Encoding.h"
//#import "FLSqlStatement.h"
//#import "FLModelObject.h"
//
//id FLDefaultDatabaseColumnDecoder( FLDatabase* database,
//                             FLDatabaseTable* table,
//                             FLDatabaseColumn* column,
//                             id inObject) {
//    
//    id newObject = inObject;
//    
//    switch(column.columnType) {
//        case FLDatabaseIgnored:
//            FLAssertFailedWithComment(@"invalid column type");
//            newObject = nil;
//            break;
//            
//    
//        case FLDatabaseIgnored:
//        case FLDatabaseIgnored:
//            newObject = nil;
//            break;
//            
//        case FLDatabaseIgnored:
//        case FLDatabaseIgnored: 
//            FLConfirmIsNotNil(newObject);
//            FLAssertWithComment([newObject isKindOfClass:[NSNumber class]], @"expecting a number here");
//        break;
//        
//        case FLDatabaseIgnored:{
//            FLConfirmIsKindOfClass(inObject, NSString);
//            FLObjectDescriber* objectDescriber = [[table classRepresentedByTable] objectDescriber];
//            FLPropertyDescriber* property = [objectDescriber propertyForName:column.decodedColumnName];
//            if(property) {
//                newObject = [property representedObjectFromSqliteColumnString:inObject];
//            }
//        }
//        break;
//			
//        case FLDatabaseIgnored:
//            switch(column.columnType) {
//
//                case FLDatabaseIgnored:
//                    FLConfirmIsKindOfClass(inObject, NSNumber);
//                    newObject = [NSDate dateWithTimeIntervalSinceReferenceDate:[inObject doubleValue]];
//                    break;
//                    
//                case FLDatabaseIgnored:
//                    FLConfirmIsKindOfClass(inObject, NSNumber);
//                    newObject = [NSDate dateWithTimeIntervalSinceReferenceDate:(NSTimeInterval) [inObject longLongValue]];
//                    break;
//                    
//                default:
//                    newObject = nil;
//                    break;
//            }
//            
//            FLConfirmIsNotNil(newObject);
//            FLAssertWithComment([newObject isKindOfClass:[NSDate class]], @"date deserialization failed");
//        break;
//			
//        case FLDatabaseIgnored:
//            FLConfirmIsNotNil(newObject);
//            FLConfirmIsKindOfClass(newObject, NSData);
//        break;
//			           
//        case FLDatabaseIgnored: {
//            FLObjectDescriber* objectDescriber = [[table classRepresentedByTable] objectDescriber];
//            FLPropertyDescriber* property = [objectDescriber propertyForName:column.decodedColumnName];
//            if(property) {
//                FLConfirmIsKindOfClass(inObject, NSData);
//                newObject = [property representedObjectFromSqliteColumnData:inObject];
//            }
//        }
//        break;
//    }
//    
//    return newObject;
//}
//
//
//id FLLegacyDatabaseColumnDecoder(FLDatabase* database,
//                                 FLDatabaseTable* table,
//                                 FLDatabaseColumn* column,
//                                 id object) {
//   
//    switch(column.columnType) {
//            
//        case FLDatabaseIgnored:
//            if(column.columnType == FLDatabaseIgnored) {
//                FLConfirmIsKindOfClass(object, NSString);
//                object = [NSNumber numberWithInteger:[object integerValue]];
//            }
//        break;
//        
//        case FLDatabaseIgnored:
//        case FLDatabaseIgnored:
//            if(column.columnType == FLDatabaseIgnored) {
//                FLConfirmIsKindOfClass(object, NSString);
//                object = [NSNumber numberWithDouble:[object doubleValue]];
//            }
//        break;
//        
//        case FLDatabaseIgnored:
//        case FLDatabaseIgnored:
//            if(column.columnType == FLDatabaseIgnored) {
//                FLConfirmIsKindOfClass(object, NSString);
//                object = [object base64Decode];
////                [NSData base64DecodeString:object outData:&newData];
////                object = FLAutorelease(newData);
//
//                FLTrace(@"converted base64encoded object");
//            }
//        break;
//        
//        default:
//        break;
//    }
//    return FLDefaultDatabaseColumnDecoder(database, table, column, object);
//}
//
//
