//
//  NSError+FLTestable.m
//  FishLampCore
//
//  Created by Mike Fullerton on 10/27/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "NSError+FLTestable.h"
#import "FLErrorException.h"
#import "FLAssertions.h"

NSString* const FLTAssertFailedErrorDomain = @"FLTAssertFailedErrorDomain";

//@implementation NSError (FLTestable)
//
//+ (id) testFailedError:(NSInteger) code
//             condition:(NSString*) condition
//               comment:(NSString*) comment
//            stackTrace:(FLStackTrace*) stackTrace{
// 
//    return [self errorWithDomain:FLTAssertFailedErrorDomain
//                            code:code
//            localizedDescription:condition
//                        userInfo:nil
//                         comment:comment
//                      stackTrace:stackTrace];
//}                    
//
//@end
