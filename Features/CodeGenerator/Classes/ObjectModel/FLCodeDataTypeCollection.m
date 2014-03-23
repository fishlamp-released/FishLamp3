//
//  FLObjcDataTypeRegistry.m
//  CodeGenerator
//
//  Created by Mike Fullerton on 2/6/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLCodeDataTypeCollection.h"

@implementation FLCodeDataTypeCollection

- (id) init {
    self = [super init];
    if(self) {
        _types = [[NSMutableDictionary alloc] init];
    }
    return self;
}

+ (id) codeDataTypeCollection {
    return FLAutorelease([[[self class] alloc] init]);
}

#if FL_MRC
- (void) dealloc {
	[_types release];
	[super dealloc];
}
#endif

- (void) setDataType:(id) type forKey:(NSString*) key{
    [_types setObject:type forKey:[key lowercaseString]];
}

- (id) dataTypeForKey:(NSString*) key {
    return [_types objectForKey:[key lowercaseString]];
}

@end
