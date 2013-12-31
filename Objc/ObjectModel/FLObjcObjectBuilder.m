//
//  FLObjcObjectBuilder.m
//  FishLampCodeGenerator
//
//  Created by Mike Fullerton on 8/17/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLObjcObjectBuilder.h"
#import "FLObjcCodeGeneratorHeaders.h"
#import "FishLampCodeGeneratorObjects.h"

@implementation FLObjcObjectBuilder

- (void) addPropertiesToObjcObject:(FLObjcObject*) object
                withCodeProperty:(FLCodeProperty*) codeProperty {
    [self addPropertyToObjcObject:object withCodeProperty:codeProperty];
}


- (FLObjcProperty*) addPropertyToObjcObject:(FLObjcObject*) object
                           withCodeProperty:(FLCodeProperty*) codeProperty {

    FLObjcProperty* property = [FLObjcProperty objcProperty:object.project];
    [property configureWithCodeProperty:codeProperty forObject:object];

    return property;
}

@end
