//
//  FLAssertionHandler.h
//  FishLamp
//
//  Created by Mike Fullerton on 12/24/13.
//
//

#import "FLStackTrace.h"

@protocol FLAssertionHandler <NSObject>

- (NSException*) assertionFailed:(NSString*) domain
                            code:(NSInteger) code
                      stackTrace:(FLStackTrace_t) stackTrace
                            name:(NSString*) name
                     description:(NSString*) description;

@end

@interface FLAssertionHandler : NSObject<FLAssertionHandler>

+ (void) setSharedHandler:(id<FLAssertionHandler>) defaultHandler;
+ (id) sharedHandler;

+ (id<FLAssertionHandler>) defaultHandler;

@end


