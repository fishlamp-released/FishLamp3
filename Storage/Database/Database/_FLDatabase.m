//
//  FLDatabase.m
//  FishLamp
//
//  Created by Mike Fullerton on 5/25/11.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton.
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLDatabase_Internal.h"


NSString* FLDatabaseTypeToString(FLDatabaseType type)
{
	switch(type)
	{
		case FLDatabaseTypeInteger:
			return @"INTEGER";

		case FLDatabaseTypeFloat:
			return @"REAL";
		break;

		case FLDatabaseTypeObject:
		case FLDatabaseTypeBlob:
			return @"BLOB";
		
        case FLDatabaseTypeNull:
		case FLDatabaseTypeText:
			return @"TEXT";

		case FLDatabaseTypeDate:
			return @"REAL";
			
		case FLDatabaseTypeNone:
			return nil;
            
        case FLDatabaseTypeInvalid:
            FLAssertFailedWithComment(@"invalid sql type");
            break;
            
	}

	return nil;
}
//
//
//
