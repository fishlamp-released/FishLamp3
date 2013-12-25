//
//  FLAssert.m
//  FishLampCore
//
//  Created by Mike Fullerton on 9/3/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLAssert.h"
#import "FLExceptions.h"
#import "FishLampAssertions.h"

id _FLAssertIsClass(id object, Class aClass) {
    if(object) {
        FLAssertNotNilWithComment(aClass, @"class for %@ is nil", NSStringFromClass(aClass));
        FLAssertWithComment([object isKindOfClass:aClass], 
            @"expecting type of %@ but got %@", 
            NSStringFromClass(aClass), 
            NSStringFromClass([object class]));
    }
    return object;
}

id _FLAssertConformsToProtocol(id object, Protocol* proto) {
    if(object) {
        FLAssertWithComment([object conformsToProtocol:proto], @"expecting object to implement protocol: %@", NSStringFromProtocol(proto));
    }
    return object;
}


