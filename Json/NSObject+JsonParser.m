//
//  NSObject+JsonParser.m
//  FishLamp
//
//  Created by Mike Fullerton on 5/17/11.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton.
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#if REFACTOR

#import "NSObject+JsonParser.h"
#import "FLDateMgr.h"
#import "FLObjectDescriber.h"
#import "FLStringToObjectConverting.h"

@implementation NSObject (FLJsonParser)

- (BOOL) openJsonObjectForKey:(NSString *)key 
	parentKey:(NSString*) parentKey
	parentObject:(id) parentObject 
	outObject:(id*) outObject
{
//	FLAssertStringIsNotEmpty(key);
//
//	FLObjectDescriber* describer = [[self class] objectDescriber];
//	FLAssertIsNotNil(describer);
//
//	FLObjectDescriber* desc = [describer propertyForName:key];
////	FLAssertIsNotNil(desc);
//
//	if(desc)
//	{
//		FLAssertWithComment(desc.objectDescriber.isObject, @"opening object thats a simple type");
//		if(FLDataTypeIsObject(desc.objectDescriber))
//		{
//			id newObject = [self valueForKey:key];
//			if(!newObject)
//			{
//				newObject = FLAutorelease([[desc.objectDescriber.actualClass alloc] init]);
//				[self setValue:newObject forKey:key];
//			}
//		
//			FLAssertIsNotNil(newObject);
//			if(outObject)
//			{
//				*outObject = FLRetain(newObject);
//			}
//			
//			return YES;
//		}
//	}
//
//	FLLog(@"Warning: unable to open object: %@.%@.%@", NSStringFromClass([parentObject class]), parentKey, key);
//	if(outObject)
//	{
//		*outObject = FLRetain([NSNull null]);
//	}
	
	return NO;
}
- (BOOL) setJsonData:(id) data forKey:(NSString*) key
{
//	FLAssertStringIsNotEmpty(key);
//
//	FLObjectDescriber* describer = [[self class] objectDescriber];
//	FLAssertIsNotNil(describer);
//
//	FLObjectDescriber* desc = [describer propertyForName:key];
////	FLAssertIsNotNil(desc);
//
//	if(desc) {
//		switch(desc.objectDescriber.specificType) {
//			case FLSpecificTypeDate: {
//				data = [[FLDateMgr instance] ISO3339StringToDate:data];
//			}
//			break;
//			
//			default:
//			break;
//		}
//	
//		[self setValue:data forKey:key];
//		
//		return YES;
//	}
//
//	FLLog(@"Warning: data not set for key:%@.%@. Data: %@", NSStringFromClass([self class]), key, [data description]);
	return NO;
}

@end

@implementation NSMutableArray (FLJsonParser)

- (BOOL) openJsonObjectForKey:(NSString *) arrayItemKey 
	parentKey:(NSString*) parentPropertyKey
	parentObject:(id) parentObject 
	outObject:(id*) outObject
{
	FLAssertStringIsNotEmpty(arrayItemKey);


	FLObjectDescriber* describer = [[parentObject class] objectDescriber];
	FLAssertIsNotNil(describer);

	FLObjectDescriber* desc = [describer propertyForName:arrayItemKey];
	FLAssertIsNotNil(desc);
	
	if(desc)
	{
		for(FLObjectDescriber* property in desc.arrayTypes)
		{
		//	if(FLStringsAreEqual(property.objectName, arrayItemKey))
			{
                FLAssertIsNotNil(property.objectDescriber.actualClass);
                FLObjectDescriber* propDescriber = [property.objectDescriber.actualClass objectDescriber];
            
				if(propDescriber)
				{
					
					id obj = [[property.objectDescriber.actualClass alloc] init];
					FLAssertWithComment(obj != nil, @"Unable to created object of type: %@", NSStringFromClass(property.objectDescriber.actualClass));

					FLAssertIsNotNil(obj);
					[self addObject:obj];
					FLRelease(obj);
					
					if(outObject)
					{
						*outObject = FLRetain(obj);
					}
				}
				else
				{
					if(outObject)
					{
						*outObject = FLRetain(self);
					}
				}
				
				return YES;	
			}
		}
	}
	
	FLLog(@"Warning: unable to open array object: %@.%@.%@", NSStringFromClass([parentObject class]), parentPropertyKey, arrayItemKey);
	
	if(outObject)
	{
		*outObject = FLRetain([NSNull null]);
	}
	
	return NO;
}

- (BOOL) setJsonData:(id) data forKey:(NSString*) key
{
	[self addObject:data];
	return YES;
}

@end

@implementation NSNull (FLJsonParser)

- (BOOL) openJsonObjectForKey:(NSString *)key 
	parentKey:(NSString*) parentKey
	parentObject:(id) parentObject 
	outObject:(id*) outObject
{
	// no-op
	
	if(outObject)
	{
		*outObject = FLRetain(self);
	}
	
	FLLog(@"opening data for NSNull failed by design");
	
	return YES;
}
@end

#endif
