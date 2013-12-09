//
//  FLStringToObjectConversionManager.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 8/18/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLStringToObjectConversionManager.h"
#import "FLStringToObjectConverting.h"

@implementation FLStringToObjectConversionManager

#define Key(k) [k lowercaseString]

- (id) init {	
	self = [super init];
	if(self) {
		_converters = [[NSMutableDictionary alloc] init];
	}
	return self;
}

#if FL_MRC
- (void) dealloc {
    [_converters release];
    [super dealloc];
}
#endif

- (void) addConverter:(id<FLStringToObjectConverting>) converter {
    NSArray* keys = [[converter class] typeNames];
    if(keys) {
        for(NSString* key in keys) {
            [_converters setObject:converter forKey:Key(key)];
        }
    }
}

- (id<FLStringToObjectConverting>) converterForTypeName:(NSString*) key {
    return [_converters objectForKey:Key(key)];
}

- (NSString*) stringFromObject:(id) object 
                   forTypeName:(NSString*) typeName {

    id<FLStringToObjectConverting> converter = [_converters objectForKey:Key(typeName)];
    FLAssertNotNilWithComment(converter, @"converter for %@ not found", typeName);

    if(converter) {
        return [converter stringFromObject:object];
    }
    
    return object;
} 

- (id) objectFromString:(NSString*) string
            forTypeName:(NSString*) typeName {

    id<FLStringToObjectConverting> converter = [_converters objectForKey:Key(typeName)];
    FLAssertNotNilWithComment(converter, @"decoder for %@ not found", typeName);

    if(converter) {
        return [converter objectFromString:string];
    }
    
    return string;
                
}                

@end

@implementation FLDefaultStringToObjectConversionManager

+ (id) defaultConverter {
   return FLAutorelease([[[self class] alloc] init]);
}

- (id) init {
	if((self = [super init])) {

        [self addConverter:[FLStringToObjectConverter stringToObjectConverter]];

        [self addConverter:[FLURLStringToNSURLObjectConverter stringToObjectConverter]];

        [self addConverter:[FLISO8601StringToNSDateObjectConverter stringToObjectConverter]];

#if OSX
        if(OSXVersionIs10_6()) {
            [self addConverter:[FLCustomNumberStringToNSNumberObjectConverter stringToObjectConverter]];
        }
        else {
            [self addConverter:[FLNumberStringToNSNumberObjectConverter stringToObjectConverter]];
        }
#else
        [self addConverter:[FLNumberStringToNSNumberObjectConverter stringToObjectConverter]];
#endif

        [self addConverter:[FLBoolStringToNSNumberObjectConverter stringToObjectConverter]];

        [self addConverter:[FLUTF8StringToNSDataObjectConverter stringToObjectConverter]];

        [self addConverter:[FLBase64StringToNSDataObjectConverter stringToObjectConverterWithStringConverter:
                                [FLUTF8StringToNSDataObjectConverter stringToObjectConverter]]];
    }

	return self;
}

@end
