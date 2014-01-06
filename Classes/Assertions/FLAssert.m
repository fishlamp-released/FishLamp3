//
//  FLAssert.m
//  FishLampCore
//
//  Created by Mike Fullerton on 9/3/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLAssert.h"
#import "FishLampExceptions.h"
#import "FLStackTrace.h"
#import "NSError+FLStackTrace.h"
#import "FLAssert.h"

id _FLAssertIsClass(id object, Class aClass) {
    if(object) {
        FLCAssertNotNil(aClass, @"class for %@ is nil", NSStringFromClass(aClass));
        FLCAssert([object isKindOfClass:aClass],
            @"expecting type of %@ but got %@", 
            NSStringFromClass(aClass), 
            NSStringFromClass([object class]));
    }
    return object;
}

id _FLAssertConformsToProtocol(id object, Protocol* proto) {
    if(object) {
        FLCAssert([object conformsToProtocol:proto], @"expecting object to implement protocol: %@", NSStringFromProtocol(proto));
    }
    return object;
}

#if DEBUG
// This works around a spurious clang warning caused by comparision to nil in asserts
id NARG() {
    return (void*) 0L;
}
#endif
