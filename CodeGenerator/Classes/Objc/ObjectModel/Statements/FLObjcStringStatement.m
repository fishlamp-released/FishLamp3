//
//  FLObjcStringStatement.m
//  CodeGenerator
//
//  Created by Mike Fullerton on 5/31/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLObjcStringStatement.h"
#import "FLCodeChunk.h"
#import "FLObjcCodeGeneratorHeaders.h"

@implementation FLObjcStringStatement

@synthesize codeBuilder = _codeBuilder;

- (id) init {	
	self = [super init];
	if(self) {
		_codeBuilder = [[FLObjcCodeBuilder alloc] init];
	}
	return self;
}

#if FL_MRC
- (void) dealloc {
	[_codeBuilder release];
	[super dealloc];
}
#endif

- (void) writeCodeToSourceFile:(FLObjcFile*) file 
               withCodeBuilder:(FLObjcCodeBuilder*) codeBuilder {
               
    [codeBuilder appendString:_codeBuilder];
}

+ (id) objcStringStatement {
    return FLAutorelease([[[self class] alloc] init]);
}

- (BOOL) hasCode {
    return ![_codeBuilder isEmpty];
}

@end