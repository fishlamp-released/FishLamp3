//
//  FishLampCoreTests.m
//  FishLampCore
//
//  Created by Mike Fullerton on 12/30/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#if defined(XCTFail)

#import <XCTest/XCTest.h>

@interface FishLampCoreTests : XCTestCase

@end

@implementation FishLampCoreTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
    NSLog(@"hello?");

    int val = 0;

    XCTAssert(val == 1);


    XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}

@end

#endif