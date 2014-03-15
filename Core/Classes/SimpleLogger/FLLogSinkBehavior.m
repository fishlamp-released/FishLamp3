//
//  FLLogSinkBehavior.m
//  Pods
//
//  Created by Mike Fullerton on 2/23/14.
//
//

#import "FLLogSinkBehavior.h"

@implementation FLLogSinkBehavior

@synthesize outputLocation = _outputLocation;
@synthesize outputStackTrace = _outputStackTrace;

+ (id) logSinkBehavior {
    return FLAutorelease([[[self class] alloc] init]);
}

@end
