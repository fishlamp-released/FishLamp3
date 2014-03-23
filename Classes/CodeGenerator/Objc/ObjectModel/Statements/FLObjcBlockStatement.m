//
//  FLObjcBlockStatement.m
//  CodeGenerator
//
//  Created by Mike Fullerton on 5/31/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLObjcBlockStatement.h"
#import "FLObjcCodeBuilder.h"

@implementation FLObjcBlockStatement

@synthesize statements = _statements;

- (id) init {	
	self = [super init];
	if(self) {
		_statements = [[NSMutableArray alloc] init];
	}
	return self;
}

+ (id) objcBlockStatement {
    return FLAutorelease([[[self class] alloc] init]);
}

- (void) writeCodeToSourceFile:(FLObjcFile*) file withCodeBuilder:(FLObjcCodeBuilder*) codeBuilder {

    [codeBuilder appendLine:@"{"];
    [codeBuilder indent:^{
        for(FLObjcStatement* statement in _statements) {
            [statement writeCodeToSourceFile:file withCodeBuilder:codeBuilder];
        }
    }];
    [codeBuilder appendLine:@"}"];
}

- (void) addStatement:(FLObjcStatement*) statement {
    [_statements addObject:statement];
}

#if FL_MRC
- (void) dealloc {
	[_statements release];
	[super dealloc];
}
#endif

- (BOOL) hasCode {

    for(id statement in _statements) {
        if([statement hasCode]) {
            return YES;
        }
    }

    return NO;
}



@end
