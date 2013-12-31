//
//  FLObjcClassInitializerMethod.m
//  CodeGenerator
//
//  Created by Mike Fullerton on 5/31/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLObjcClassInitializerMethod.h"
#import "FLObjcCodeGeneratorHeaders.h"
#import "FLCodeObject.h"

@implementation FLObjcClassInitializerMethod

- (void) configureWithInputConstructor:(FLCodeConstructor*) constructor 
                            withObject:(FLObjcObject*) object {
    
    self.methodName = [FLObjcMethodName objcMethodName:[object.objectName.generatedName stringByDeletingPrefix_fl:self.project.classPrefix]];

    self.returnType = [self.project.typeRegistry typeForKey:@"id"];
    self.isStatic = YES;
    self.isPrivate = NO;

    if(constructor && constructor.parameters.count) {

        NSMutableString* superparms = [NSMutableString string];

        for(FLCodeConstructorParameter* parameter in constructor.parameters) {
            FLObjcName* name = [FLObjcParameterName objcParameterName:parameter.name];
            FLObjcType* type = [self.project.typeRegistry typeForKey:parameter.type];

            [object addDependency:type];

            FLObjcParameter* objcParameter = [FLObjcParameter objcParameter:name parameterType:type key:parameter.name];
            [self addParameter:objcParameter];

            if(superparms.length) {
                [superparms appendFormat:@" %@:%@", name.generatedName, name.generatedName];
            }
            else {
                [superparms appendFormat:@"%@", name.generatedName];
            }


        }

        NSString* methodName = [FLObjcConstructor methodNameForConstructor:constructor].generatedName;
        [self.code appendReturnValue:
            [NSString stringWithFormat:@"FLAutorelease([[[self class] alloc] %@:%@])",
         methodName, superparms]];

    }
    else {
        [self.code appendReturnValue:@"FLAutorelease([[[self class] alloc] init])"];
    }
}


//- (void) didMoveToObject:(FLObjcObject*) object {
//    [super didMoveToObject:object];


    

    
//    [self.parentObject addDependency:self.ivar.variableType];
//    [self.parentObject addDependency:self.propertyType];
//    [self.parentObject addIvar:self.ivar];
//    
//    if(self.containerTypes && self.containerTypes.count) {
//        [self.parentObject addDependency:[self.project typeForKey:[FLObjectDescriber class]]];
//     
//        for(FLObjcContainerSubType* subType in self.containerTypes) {
//            [self.parentObject addDependency:subType.objcType];
//        }
//    }    
    
//}

@end
