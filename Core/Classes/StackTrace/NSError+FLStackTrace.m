//
//  NSError+FLStackTrace.m
//  FishLamp
//
//  Created by Mike Fullerton on 12/24/13.
//
//

#import "NSError+FLStackTrace.h"
#import "NSString+FishLamp.h"

#import "FLDeclareDictionaryProperty.h"

NSString* const FLStackTraceKey = @"com.fishlamp.stacktrace";

@implementation NSError (FLStackTrace)

FLSynthesizeDictionaryGetterProperty(stackTrace, FLStackTrace*, FLStackTraceKey, self.userInfo);

- (id) initWithDomain:(NSString*) domain
                 code:(NSInteger) code
 localizedDescription:(NSString*) localizedDescription
             userInfo:(NSDictionary *) userInfo
           stackTrace:(FLStackTrace*) stackTrace {


    NSMutableDictionary* newUserInfo = userInfo != nil ?
                                            FLMutableCopyWithAutorelease(userInfo) :
                                            [NSMutableDictionary dictionaryWithCapacity:5];

    if([localizedDescription length] > 0) {
        [newUserInfo setObject:localizedDescription forKey:NSLocalizedDescriptionKey];
    }
    if(stackTrace) {
        [newUserInfo setObject:stackTrace forKey:FLStackTraceKey];
    }

    return [self initWithDomain:domain code:code userInfo:newUserInfo];
}

+ (NSError*) errorWithDomain:(id) domain
                        code:(NSInteger)code
        localizedDescription:localizedDescription
                    userInfo:(NSDictionary *)dict
                  stackTrace:(FLStackTrace*) stackTrace {

    return FLAutorelease([[[NSError class] alloc] initWithDomain:domain
                                                        code:code
                                         localizedDescription:localizedDescription
                                                    userInfo:dict
                                                     stackTrace:stackTrace]);
}

+ (NSError*) errorWithError:(NSError*) error stackTrace:(FLStackTrace*) stackTrace {

    NSDictionary* userInfo = error.userInfo;
    if(stackTrace) {
        if(userInfo) {
            NSMutableDictionary* newUserInfo = FLMutableCopyWithAutorelease(userInfo);
            [newUserInfo setObject:stackTrace forKey:FLStackTraceKey];
            userInfo = newUserInfo;
        }
        else {
            userInfo = [NSDictionary dictionaryWithObject:stackTrace forKey:FLStackTraceKey];
        }

        return FLAutorelease([[NSError alloc] initWithDomain:error.domain code:error.code userInfo:userInfo]);
    }

    return FLRetainWithAutorelease(error);
}

@end
