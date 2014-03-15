//
//  FLJsonBuilder.m
//  FishLamp
//
//  Created by Mike Fullerton on 5/11/11.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton.
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLJsonStringBuilder.h"
#import "FLStringToObjectConversionManager.h"

@implementation FLJsonStringBuilder

@synthesize dataEncoder = _dataEncoder;

-(void)dealloc
{
	FLRelease(_dataEncoder);
	FLSuperDealloc();
}


//- (void) appendElementValueWithString:(NSString*) dataString {
//	if(dataString) {
//		[self.writer appendLine:dataString];
//	}
//}


// TODO(Json builder no worky)
// TODO: fix this

//- (void) beginStreamingObjectForType:(FLDataTypeStruct*) type
//{
//	if(type->typeID == FLDataTypeObject)
//	{
//		[self appendFormat:@"\"%@\": {", type->key];
//		[self closeLine];
//	}
//	else
//	{
//		[self appendFormat:@"\"%@\": ", type->key];
//	}
//}


//- (void) appendLineWithEncodedObject:(id) object	forType:(FLDataTypeStruct*) type
//{
//	if(object)
//	{
//		NSString* string = nil;
//		[self.dataEncoder encodeDataToString:object forType:type->typeID outEncodedString:&string];
//		@try
//		{
//			[self appendElementValueWithString:string];
//		}
//		@finally
//		{
//			FLRelease(string);
//		}
//	}
//}
//
//- (void) addObjectAsXML:(id) object forType:(FLDataTypeStruct*) type
//{
//	if(type->typeID == FLDataTypeObject)
//	{
//		[object streamSelfTo:self dataType:type];
//	}
//	else
//	{
//		[self appendLineWithEncodedObject:object forType:type];
//	}
//}
//
//- (void) endStreamingObjectForType:(FLDataTypeStruct*) type
//{
//	if(type->typeID == FLDataTypeObject)
//	{
//		[self appendString:@"}"];
//	}
//	[self closeLine];
//}
//
- (void) streamObject:(id) object
{
//	[object streamSelfTo:self dataType:[[object class] dataTypeStruct]];
}


@end

