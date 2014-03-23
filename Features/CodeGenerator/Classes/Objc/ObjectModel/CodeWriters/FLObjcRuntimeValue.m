//
//  FLObjcRuntimeValue.m
//  CodeGenerator
//
//  Created by Mike Fullerton on 5/12/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLObjcRuntimeValue.h"
#import "FLObjcType.h"

@implementation FLObjcRuntimeValue
@synthesize valueName = _valueName;
@synthesize valueType = _valueType;

- (id) initWithValueName:(NSString*) name valueType:(FLObjcType*) type {	
	self = [super init];
	if(self) {
        self.valueName = name;
	}
	return self;
}
#if FL_MRC
- (void) dealloc {
	[_valueName release];
    [_valueType release];
    [super dealloc];
}
#endif

- (void) writeCodeToHeaderFile:(FLObjcFile*) file withCodeBuilder:(FLObjcCodeBuilder*) codeBuilder {
}
- (void) writeCodeToSourceFile:(FLObjcFile*) file withCodeBuilder:(FLObjcCodeBuilder*) codeBuilder {
}
@end

@implementation FLObjcRuntimeObject

+ (id) objcRuntimeObject:(NSString*) name objectType:(FLObjcType*) type {
    return FLAutorelease([[[self class] alloc] initWithValueName:name valueType:type]);
}

@end
