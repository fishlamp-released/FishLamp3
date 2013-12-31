//
//  FLObjcConstructor.m
//  FishLampCodeGenerator
//
//  Created by Mike Fullerton on 6/8/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLObjcConstructor.h"

#import "FLCodeConstructor.h"
#import "FLObjcCodeGeneratorHeaders.h"
#import "NSString+FishLamp.h"

@implementation FLObjcConstructor

- (id) initWithProject:(FLObjcProject*) project {	
	self = [super initWithProject:project];
	if(self) {
		
	}
	return self;
}

+ (id) objcConstructor:(FLObjcProject*) project {
    return FLAutorelease([[[self class] alloc] initWithProject:project]);
}

+ (FLObjcMethodName*) methodNameForConstructor:(FLCodeConstructor*) constructor {
    return [FLObjcMethodName objcMethodName:
            [NSString stringWithFormat:@"initWith%@",
         [[[constructor.parameters objectAtIndex:0] name] stringWithUppercaseFirstLetter_fl]]];
}

- (void) configureWithInputConstructor:(FLCodeConstructor*) constructor 
                            withObject:(FLObjcObject*) object {

    self.isStatic = NO;
    self.isPrivate = YES;
    self.returnType = [self.project.typeRegistry typeForKey:@"id"];
    if(constructor.parameters.count) {
        self.isPrivate = NO;
        self.methodName = [FLObjcConstructor methodNameForConstructor:constructor];
    }
    else {
        self.methodName = [FLObjcMethodName objcMethodName:@"init"];
    }

    NSMutableString* superparms = [NSMutableString string];

    for(FLCodeConstructorParameter* parameter in constructor.parameters) {

        FLObjcName* name = [FLObjcParameterName objcParameterName:parameter.name];
        FLObjcType* type = [self.project.typeRegistry typeForKey:parameter.type];

        [object addDependency:type];

        FLObjcParameter* objcParameter = [FLObjcParameter objcParameter:name parameterType:type key:parameter.name];
        [self addParameter:objcParameter];

        if(parameter.passToSuper) {
            if(superparms.length) {
                [superparms appendFormat:@" %@:%@", name.generatedName, name.generatedName];
            }
            else {
                [superparms appendFormat:@"%@", name.generatedName];
            }
        }
    }

    if(superparms.length) {
        [self.code appendLineWithFormat:@"self = [super %@:%@];", self.methodName.generatedName, superparms];
    }
    else {
        [self.code appendLine:@"self = [super init];"];
    }

    [self.code appendString:@"if(self) {"];
    [self.code indentLinesInBlock:^{
        for(FLCodeConstructorParameter* parameter in constructor.parameters) {
            if(FLStringIsNotEmpty(parameter.setProperty)) {
                FLObjcName* parameterName = [FLObjcParameterName objcParameterName:parameter.name];
                FLObjcName* propertyName = [FLObjcPropertyName objcPropertyName:parameter.setProperty];

                [self.code appendLineWithFormat:@"self.%@ = %@;", propertyName.generatedName, parameterName.generatedName];
            }
        }

        for(FLCodeElement* element in constructor.lines) {
            [self.code appendCodeElement:element withProject:self.project];
        }

    }];
    [self.code appendString:@"}"];

    [self.code appendReturnValue:@"self"];



}

@end
