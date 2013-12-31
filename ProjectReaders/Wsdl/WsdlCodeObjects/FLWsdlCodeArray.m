//
//  FLWsdlCodeArray.m
//  CodeGenerator
//
//  Created by Mike Fullerton on 5/29/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLWsdlCodeArray.h"
#import "FLWsdlCodeProjectReader.h"
#import "FLWsdlCodeArrayContainedType.h"

@implementation FLWsdlCodeArray

- (id) initWithArrayName:(NSString*) arrayName {	
	self = [super init];
	if(self) {
		self.name = arrayName;
	}
	return self;
}

+ (id) wsdlCodeArray:(NSString*) arrayName {
    return FLAutorelease([[[self class] alloc] initWithArrayName:arrayName]);
}

- (void) setName:(NSString*) name {
    [super setName:FLDeleteNamespacePrefix(name)];
    FLConfirmStringIsNotEmptyWithComment(self.name, @"array cannot be empty");
}

- (void) addContainedType:(FLWsdlCodeArrayContainedType*) type {
    FLConfirmNotNil(type);
    [self.types addObject:type];
}

- (void) addContainedType:(NSString*) typeName identifier:(NSString*) identifier {
    [self addContainedType:[FLWsdlCodeArrayContainedType wsdlCodeArrayContainedType:typeName identifier:identifier]];
}


@end
