//
//  FLObjcParameter.m
//  CodeGenerator
//
//  Created by Mike Fullerton on 5/31/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLObjcParameter.h"


@implementation FLObjcParameter
@synthesize key = _key;

- (id) initWithParameterName:(FLObjcName*) variableName parameterType:(FLObjcType*) parameterType key:(NSString*) key {
    self = [self initWithVariableName:variableName variableType:parameterType];
    if(self) {
        self.key = key;
    }   
    return self;
}

+ (id) objcParameter:(FLObjcName*) variableName parameterType:(FLObjcType*) parameterType key:(NSString*) key {
    return FLAutorelease([[[self class] alloc] initWithParameterName:variableName parameterType:parameterType key:key]);
}

#if FL_MRC
- (void) dealloc {
	[_key release];
	[super dealloc];
}
#endif

//- (void) writeCodeToHeaderFile:(FLObjcFile*) file withCodeBuilder:(FLObjcCodeBuilder*) codeBuilder {
//}
//- (void) writeCodeToSourceFile:(FLObjcFile*) file withCodeBuilder:(FLObjcCodeBuilder*) codeBuilder {
//}

@end
