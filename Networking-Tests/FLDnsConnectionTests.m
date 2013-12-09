//
//  FLDnsConnectionTests.m
//  FishLamp
//
//  Created by Mike Fullerton on 9/4/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLDnsConnectionTests.h"
#import "FLNetworkHost.h"
#import "FLNetworkHostResolver.h"
#import "FLDispatchQueue.h"

@implementation FLDnsConnectionTests


//+ (Class) testGroupClass {
//    return @"FishLampNetworking";
//}

- (void) testCreateHostByName:(FLTestCase*) testCase {

    FLNetworkHost* host = [FLNetworkHost networkHostWithName:@"google.com"];
    
    FLAssert(!host.isResolved);
    FLAssertStringsAreEqual(host.hostName, @"google.com");
    
    FLTestLog(testCase, host.hostName);
}


- (void) testFailureOnBadInput {

//    [self runTestWithExpectedFailure:^{
//        FLNetworkHost* host = [FLNetworkHost networkHostWithName:nil];
//        FLAssertIsNil(host);
//        }];
}

- (void) testResolve {

//    FLNetworkHost* host = [FLNetworkHost networkHostWithName:@"google.com"];
//    
//    FLNetworkHostResolver* resolver = [FLNetworkHostResolver networkHostResolver:host];
//    FLFinisher* finisher = [resolver openConnection:FLFifoQueue];
//    [finisher waitUntilFinished];
//    
//    FLThrowError(finisher.result);
//    
//    FLAssertIsTrue(host.isResolved);
//    
//    NSArray* resolvedAddressStrings = [host resolvedAddressStrings];
//    for(NSString* string in resolvedAddressStrings) {
//        FLLog(string);
//    }
}
@end
