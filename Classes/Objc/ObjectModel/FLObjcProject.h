//
//  FLObjcProject.h
//  CodeGenerator
//
//  Created by Mike Fullerton on 6/1/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FishLampCore.h"

@class FLObjcFileManager;
@class FLObjcTypeRegistry;
@class FLCodeProject;
@class FLCodeGeneratorResult;
@class FLObjcNamedObjectCollection;

@interface FLObjcProject : NSObject {
@private 
    FLObjcFileManager* _fileManager;
    FLObjcTypeRegistry* _typeRegistry;
    FLObjcNamedObjectCollection* _generatedEnums;
    FLObjcNamedObjectCollection* _generatedObjects;
    FLCodeProject* _inputProject;
}

@property (readonly, strong, nonatomic) FLCodeProject* inputProject;

@property (readonly, strong, nonatomic) FLObjcFileManager* fileManager;
@property (readonly, strong, nonatomic) FLObjcTypeRegistry* typeRegistry;

@property (readonly, strong, nonatomic) FLObjcNamedObjectCollection* generatedEnums;
@property (readonly, strong, nonatomic) FLObjcNamedObjectCollection* generatedObjects;

@property (readonly, strong, nonatomic) NSString* classPrefix;

+ (id) objcProject;

- (void) configureWithProjectInput:(FLCodeProject*) project;

@end
