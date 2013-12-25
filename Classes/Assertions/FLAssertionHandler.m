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

NSException* FLDefaultCreateAssertionException(NSString* domain,
                                        NSInteger code,
                                        FLStackTrace_t stackTrace,
                                        NSString* name,
                                        NSString* description) {

    NSError* theError =
        [NSError errorWithDomain:domain
                            code:code
            localizedDescription:description
                        userInfo:nil
                      stackTrace:[FLStackTrace stackTrace:stackTrace]];

    return [NSException exceptionWithName:name reason:description userInfo:nil error:theError];
}

static FLCreateAssertionExceptionFunction* s_exceptionFactory = nil;

@implementation FLAssertionHandler

+ (void) initialize {
    if(!s_exceptionFactory) {
        s_exceptionFactory = &FLDefaultCreateAssertionException;
    }
}

+ (void) setExceptionFactory:(FLCreateAssertionExceptionFunction*) function {
    s_exceptionFactory = s_exceptionFactory;
}

+ (FLCreateAssertionExceptionFunction*) exceptionFactory {
    return s_exceptionFactory;
}

+ (NSException*) createException:(NSString*) domain
                            code:(NSInteger) code
                      stackTrace:(FLStackTrace_t) stackTrace
                            name:(NSString*) name
                     description:(NSString*) description {

    return (*s_exceptionFactory)(domain, code, stackTrace, name, description);
}

@end