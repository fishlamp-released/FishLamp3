//
//  FLOwnershipTests.m
//  FishLampCore
//
//  Created by Mike Fullerton on 9/3/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLOwnershipTests.h"
#import "FishLampTesting.h"

#import "FLObjectProxies.h"
@interface FLObjectProxyTestObject : NSObject {
@private
    BOOL _propertyWasCalled;
}
@property (readwrite, assign, nonatomic) BOOL propertyWasCalled;

@end

static BOOL s_deleted = NO;

@implementation FLObjectProxyTestObject
@synthesize propertyWasCalled = _propertyWasCalled;

+ (id) objectProxyTestObject {
    return FLAutorelease([[[self class] alloc] init]);
}

- (id) init {	
	self = [super init];
	if(self) {
	}
	return self;
}

- (void)dealloc {

    s_deleted = YES;
#if FL_MRC
	[super dealloc];
#endif
}

@end


@implementation FLOwnershipTests

- (void) testMethodForwarding {

    FLObjectProxyTestObject* testObject = [FLObjectProxyTestObject objectProxyTestObject];
    FLConfirm(!testObject.propertyWasCalled);
    testObject.propertyWasCalled = YES;
    FLConfirm(testObject.propertyWasCalled);

    testObject.propertyWasCalled = NO;
    id proxy = [FLRetainedObject retainedObject:testObject];

    FLConfirm([proxy representedObject] == testObject);
    FLConfirm(![proxy propertyWasCalled]);
    [proxy setPropertyWasCalled:YES];

    FLConfirm(testObject.propertyWasCalled);
    FLConfirm([proxy propertyWasCalled]);
}

- (void) testRetainedObjectProxy {
    s_deleted = NO;

    @autoreleasepool {
        FLRetainedObject* object = [FLRetainedObject retainedObject:[FLObjectProxyTestObject objectProxyTestObject]];
        FLConfirm(object != nil);
        FLConfirm(!s_deleted);
    }
    FLConfirm(s_deleted);
}

@end
