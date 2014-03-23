//
//  FLObjcDeallocMethod.m
//  CodeGenerator
//
//  Created by Mike Fullerton on 5/31/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLObjcDeallocMethod.h"
#import "FLObjcCodeGeneratorHeaders.h"

@implementation FLObjcDeallocMethod 

//+ (id) objcDeallocMethod {
//    return FLAutorelease([[[self class] alloc] init]);
//}

- (id) initWithProject:(FLObjcProject *)project {	
	self = [super initWithProject:project ];
	if(self) {
		_deallocStatement = [[FLObjcDeallocStatement alloc] init];
        self.methodName = [FLObjcMethodName objcMethodName:@"dealloc"];
        self.returnType = [FLObjcVoidType objcVoidType];
        self.isStatic = NO;
        self.isPrivate = YES;
        
        [self addStatement:_deallocStatement];
	}
	return self;
}

#if FL_MRC
- (void) dealloc {
	[_deallocStatement release];
    [super dealloc];
}
#endif

- (void) didMoveToObject:(FLObjcObject*) object {
    [super didMoveToObject:object];

    _deallocStatement.object = object;
}

- (void) writeCodeToSourceFile:(FLObjcFile*) file withCodeBuilder:(FLObjcCodeBuilder*) codeBuilder {

//    if(self.statement.statements.count == 0) {
    [codeBuilder appendPreprocessorIf:@"FL_MRC"];
    [super writeCodeToSourceFile:file withCodeBuilder:codeBuilder];
    [codeBuilder appendPreprocessorEndIf];
//    }
}


@end