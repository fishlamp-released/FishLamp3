//
//  FLObjcClassConstructor.m
//  FishLampCodeGenerator
//
//  Created by Mike Fullerton on 6/8/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLObjcClassConstructor.h"

@implementation FLObjcClassConstructor


- (id) initWithProject:(FLObjcProject*) project {	
	self = [super initWithProject:project];
	if(self) {
		
	}
	return self;
}

+ (id) objcClassConstructor:(FLObjcProject*) project {
    return FLAutorelease([[[self class] alloc] initWithProject:project]);
}

- (void) configureWithInputConstructor:(FLCodeConstructor*) constructor 
                            withObject:(FLObjcObject*) object {
                            
    [super configureWithInputConstructor:constructor withObject:object];
                            
    self.isStatic = YES;
                            
}

@end
