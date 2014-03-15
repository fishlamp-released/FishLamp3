//
//  FLObjcVariable.m
//  CodeGenerator
//
//  Created by Mike Fullerton on 2/10/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLObjcVariable.h"
#import "FLObjcObject.h"
#import "FLObjcName.h"
#import "FLObjcType.h"
#import "FLObjcRuntimeValue.h"
#import "FLObjcCodeBuilder.h"

@implementation FLObjcVariable
@synthesize variableName = _variableName;
@synthesize variableType = _variableType;
@synthesize runtimeValue = _runtimeValue;

- (id) initWithVariableName:(FLObjcName*) variableName variableType:(FLObjcType*) variableType {	
	self = [super init];
	if(self) {
		self.variableName = variableName;
        self.variableType = variableType;
	}
	return self;
}

#if FL_MRC
- (void) dealloc {
    [_runtimeValue release];
	[_variableName release];
    [_variableType release];
    [super dealloc];
}
#endif

- (NSString*) description {
    return [NSString stringWithFormat:@"%@, %@", self.variableName, self.variableType];
}


- (void) writeCodeToHeaderFile:(FLObjcFile*) file
               withCodeBuilder:(FLObjcCodeBuilder*) codeBuilder {
}

- (void) writeCodeToSourceFile:(FLObjcFile*) file
               withCodeBuilder:(FLObjcCodeBuilder*) codeBuilder {
}

- (FLObjcFile*) headerFile {
    return nil;
}

- (FLObjcFile*) sourceFile {
    return nil;
}

- (BOOL) includeInAllFiles {
    return NO;
}

- (BOOL) hasCode {
    return NO;
}

@end

