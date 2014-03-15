//
//  NSError+FLStackTrace.h
//  FishLamp
//
//  Created by Mike Fullerton on 12/24/13.
//
//

#import "FishLampRequired.h"

#import "FLStackTrace.h"

@interface NSError (FLStackTrace)

@property (readonly, strong, nonatomic) FLStackTrace* stackTrace;

- (id) initWithDomain:(NSString*) domain
                 code:(NSInteger) code
 localizedDescription:(NSString*) localizedDescription
             userInfo:(NSDictionary *)dict
           stackTrace:(FLStackTrace*) stackTrace;


+ (NSError*) errorWithDomain:(id) domainStringOrDomainObject
                        code:(NSInteger)code
        localizedDescription:(NSString*) localizedDescription
                    userInfo:(NSDictionary *)dict
                  stackTrace:(FLStackTrace*) stackTrace;

+ (NSError*) errorWithError:(NSError*) error stackTrace:(FLStackTrace*) stackTrace;


@end
