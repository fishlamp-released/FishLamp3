//
//  FLObjcMethod.h
//  CodeGenerator
//
//  Created by Mike Fullerton on 5/11/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLObjcCodeWriter.h"

@class FLObjcParameter;
@class FLObjcType;
@class FLObjcName;
@class FLObjcStatement;
@class FLObjcMethodName;
@class FLObjcBlockStatement;
@class FLObjcObject;
@class FLObjcProject;
@class FLCodeMethod;
@class FLObjcCodeBuilder;
@class FLObjcStringStatement;

@interface FLObjcMethod : FLObjcCodeWriter {
@private
    NSMutableArray* _parameters;
    FLObjcBlockStatement* _statement;
    FLObjcStringStatement* _stringStatement;
    FLObjcType* _returnType;
    FLObjcName* _methodName;
    BOOL _isPrivate;
    BOOL _isStatic;
    __unsafe_unretained FLObjcObject* _parentObject;
}
+ (id) objcMethod:(FLObjcProject*) project;

@property (readwrite, strong, nonatomic) FLObjcBlockStatement* statement;

@property (readwrite, assign, nonatomic) FLObjcObject* parentObject;
@property (readwrite, assign, nonatomic) BOOL isPrivate;
@property (readwrite, assign, nonatomic) BOOL isStatic;

@property (readwrite, strong, nonatomic) FLObjcName* methodName;
@property (readwrite, strong, nonatomic) FLObjcType* returnType;

// parameters
- (void) addParameter:(FLObjcParameter*) parameter;
- (void) addOrReplaceParameter:(FLObjcParameter*) parameter;

- (void) removeParameter:(FLObjcParameter*) parameter;

- (FLObjcParameter*) parameterForName:(NSString*) variableIdentifierName;

- (void) replaceParameter:(FLObjcParameter*) oldParameter 
            withParameter:(FLObjcParameter*) newParameter;

// statement
- (void) addStatement:(FLObjcStatement*) statement;
- (FLObjcCodeBuilder*) code;

// mise
- (void) didMoveToObject:(FLObjcObject*) object;

- (void) configureWithCodeMethod:(FLCodeMethod*) codeMethod ;
                   
@end



