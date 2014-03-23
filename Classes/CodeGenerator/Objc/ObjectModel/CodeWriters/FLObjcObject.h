//
//  FLObjcObject.h
//  CodeGenerator
//
//  Created by Mike Fullerton on 5/11/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLObjcCodeWriter.h"
#import "FLObjcType.h"

@class FLObjcProperty;
@class FLObjcIvar;
@class FLObjcType;
@class FLObjcName;
@class FLCodeObject;
@class FLObjcNamedObjectCollection;
@class FLObjcMethod;
@class FLObjcProject;
@class FLObjcClassName;

@interface FLObjcObject : FLObjcCodeWriter {
@private
    FLObjcType* _objectType;
    FLObjcType* _superclassType;
    FLObjcName* _objectName;
    FLObjcNamedObjectCollection* _ivars;
    FLObjcNamedObjectCollection* _properties;
    NSMutableArray* _methods;
    NSMutableSet* _dependencies;
    FLCodeObject* _codeObject;
    NSMutableArray* _protocols;
}

@property (readonly, strong, nonatomic) FLObjcNamedObjectCollection* properties;
@property (readonly, strong, nonatomic) FLObjcNamedObjectCollection* ivars;

@property (readwrite, strong, nonatomic) FLObjcType* objectType;
@property (readwrite, strong, nonatomic) FLObjcName* objectName;
@property (readwrite, strong, nonatomic) FLObjcType* superclassType;

+ (id) objcObject:(FLObjcProject*) project;

- (void) addIvar:(FLObjcIvar*) ivar;
- (void) addProperty:(FLObjcProperty*) property;
- (void) addMethod:(FLObjcMethod*) method;

- (void) addDependency:(FLObjcType*) type;
@end

@interface FLObjcGeneratedBaseClass : FLObjcObject
- (void) configureWithCodeObject:(FLCodeObject*) codeObject;
@end

@interface FLObjcGeneratedObject : FLObjcObject
- (void) configureWithCodeObject:(FLCodeObject*) codeObject;
@end

@interface FLObjcUserObject : FLObjcObject
- (void) configureWithCodeObject:(FLCodeObject*) codeObject
                       baseClass:(FLObjcGeneratedBaseClass*) baseClass;
@end