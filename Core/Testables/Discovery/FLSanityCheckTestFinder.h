//
//  FLSanityCheckRunner.h
//  FishLamp
//
//  Created by Mike Fullerton on 10/24/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLTestFinder.h"
#import "FLOperation.h"

#define FLSanityCheckStaticTestMethodPrefix @"sanityCheck_"

@interface FLSanityCheckTestFinder : NSObject<FLTestMethodFinder>
+ (id) sanityCheckTestFinder;
@end

