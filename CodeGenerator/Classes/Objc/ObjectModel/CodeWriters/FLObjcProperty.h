//
//  FLObjcProperty.h
//  CodeGenerator
//
//  Created by Mike Fullerton on 5/11/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLObjcCodeWriter.h"
@class FLObjcIvar;
@class FLObjcName;
@class FLCodeProperty;
@class FLObjcObject;
@class FLObjcProject;
@class FLObjcType;
@class FLObjcMethod;

@interface FLObjcProperty : FLObjcCodeWriter {
@private
    FLObjcIvar* _ivar;
    BOOL _isReadOnly;
    BOOL _isAtomic;
    BOOL _isImmutable;
    BOOL _useForEquality;
    BOOL _lazyCreate;
    NSMutableArray* _containerTypes;
    FLObjcMethod* _setter;
    FLObjcMethod* _getter;
    __unsafe_unretained FLObjcObject* _parentObject;
}
+ (id) objcProperty:(FLObjcProject*) project;

@property (readwrite, assign, nonatomic) FLObjcObject* parentObject;

// these all need to be set before generation of course
@property (readwrite, strong, nonatomic) FLObjcName* propertyName;
@property (readwrite, strong, nonatomic) FLObjcType* propertyType;
@property (readwrite, strong, nonatomic) FLObjcIvar* ivar;
@property (readwrite, assign, nonatomic) BOOL isStatic;
@property (readwrite, assign, nonatomic) BOOL isPrivate;
@property (readwrite, assign, nonatomic) BOOL isReadOnly;
@property (readwrite, assign, nonatomic) BOOL isAtomic;
@property (readwrite, assign, nonatomic) BOOL isImmutable;
@property (readwrite, assign, nonatomic) BOOL useForEquality;
@property (readwrite, assign, nonatomic) BOOL lazyCreate;

// if it's an array, etc.
@property (readonly, strong, nonatomic) NSArray* containerTypes;

@property (readonly, strong, nonatomic) FLObjcMethod* setter;
@property (readonly, strong, nonatomic) FLObjcMethod* getter;

// misc
- (void) configureWithCodeProperty:(FLCodeProperty*) codeProperty forObject:(FLObjcObject*) object;

@end
