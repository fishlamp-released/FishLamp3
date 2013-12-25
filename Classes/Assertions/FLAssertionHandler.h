//
//  FLAssertionHandler.h
//  FishLamp
//
//  Created by Mike Fullerton on 12/24/13.
//
//

#import "FLStackTrace.h"

typedef NSException* FLCreateAssertionExceptionFunction(NSString* domain,
                                                        NSInteger code,
                                                        FLStackTrace_t stackTrace,
                                                        NSString* name,
                                                        NSString* description);


extern NSException* FLDefaultCreateAssertionException(  NSString* domain,
                                                        NSInteger code,
                                                        FLStackTrace_t stackTrace,
                                                        NSString* name,
                                                        NSString* description);

@interface FLAssertionHandler : NSObject {
}

+ (void) setExceptionFactory:(FLCreateAssertionExceptionFunction*) function;

+ (FLCreateAssertionExceptionFunction*) exceptionFactory;

+ (NSException*) createException:(NSString*) domain
                            code:(NSInteger) code
                      stackTrace:(FLStackTrace_t) stackTrace
                            name:(NSString*) name
                     description:(NSString*) description;

@end

