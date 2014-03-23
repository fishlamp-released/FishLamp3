//
//  FLAssertionHandler.m
//  FishLamp
//
//  Created by Mike Fullerton on 12/24/13.
//
//

#import "FLAssertionHandler.h"
//#import "FishLampErrors.h"
//#import "FishLampExceptions.h"

#import "NSError+FLStackTrace.h"
#import "NSException+FLError.h"

#import "FishLampSimpleLogger.h"

static id<FLAssertionHandler> s_sharedHandler = nil;

@implementation FLAssertionHandler

+ (void) setSharedHandler:(id<FLAssertionHandler>) sharedHandler {
    FLSetObjectWithRetain(s_sharedHandler, sharedHandler);
}

+ (id) sharedHandler {

#if DEBUG
    if(!s_sharedHandler) {
        NSLog(@"Assertion handler sharedHandler is nil");
    }
#endif

    return s_sharedHandler;
}

+ (void) initialize {
    if(!s_sharedHandler) {
        [self setSharedHandler:[self defaultHandler]];
    }
}

+ (id) assertionHandler {
   return FLAutorelease([[[self class] alloc] init]);
}

+ (id<FLAssertionHandler>) defaultHandler {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(!s_sharedHandler) {
            [self setSharedHandler:[FLAssertionHandler assertionHandler]];
        }
    });

    return s_sharedHandler;
}

- (NSException*) assertionFailed:(NSString*) domain
                            code:(NSInteger) code
                      stackTrace:(FLStackTrace_t) stackTrace
                            name:(NSString*) name
                     description:(NSString*) description {

    NSError* theError =
        [NSError errorWithDomain:domain
                            code:code
            localizedDescription:description
                        userInfo:nil
                      stackTrace:[FLStackTrace stackTrace:stackTrace]];


    NSException* ex = [NSException exceptionWithName:name reason:description userInfo:nil error:theError];
    FLLog(@"Will throw assertion failure: %@: %@", name, description);
    return ex;

}

@end