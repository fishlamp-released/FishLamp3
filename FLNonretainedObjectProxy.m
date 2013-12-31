//
//  FLNonretainedObjectProxy.m
//  FishLampiOS-Lib
//
//  Created by Mike Fullerton on 2/5/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLNonretainedObjectProxy.h"
#import "FishLampAssertions.h"

@implementation FLNonretainedObjectProxy

@synthesize containedObject = _containedObject;

- (id) init {	
	return [self initWithContainedObject:nil];
}

- (id) initWithContainedObject:(id) representedObject {
    FLAssertNotNil(representedObject);

    // assigned, not retained!
    _containedObject = representedObject;
	return self;
}

+ (id) nonretainedObjectProxy:(id) object {
	return FLAutorelease([[FLNonretainedObjectProxy alloc] initWithContainedObject:object]);
}

@end

@implementation NSObject (FLNonretainedObjectProxy)
- (id) nonretained_fl {
    return [FLNonretainedObjectProxy nonretainedObjectProxy:self];
}
@end

