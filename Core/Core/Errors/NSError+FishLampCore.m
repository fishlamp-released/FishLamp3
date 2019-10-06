//
//	NSError.m
//	FishLamp
//
//	Created by Mike Fullerton on 5/22/09.
//	Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "NSError+FishLampCore.h"
#import "NSString+FishLamp.h"
#import "FishLampExceptions.h"

#import "NSError+FLStackTrace.h"
#import "FLDeclareDictionaryProperty.h"

@implementation NSError (FishLampCore)

FLSynthesizeDictionaryGetterProperty(underlyingError, NSError*, NSUnderlyingErrorKey, self.userInfo)
FLSynthesizeDictionaryGetterProperty(stringEncoding, NSArray*, NSStringEncodingErrorKey, self.userInfo)
FLSynthesizeDictionaryGetterProperty(URL, NSURL*, NSURLErrorKey, self.userInfo)
FLSynthesizeDictionaryGetterProperty(filePath, NSString*, NSFilePathErrorKey, self.userInfo)


+ (NSError*) errorWithDomain:(id) domain
                        code:(NSInteger) code
        localizedDescription:(NSString*) localizedDescription {

    return FLAutorelease([[NSError alloc] initWithDomain:domain
                                                         code:code
                                         localizedDescription:localizedDescription
                                                     userInfo:nil
                                                   stackTrace:nil]);
}

- (BOOL) isErrorCode:(NSInteger) code domain:(NSString*) domain {
	return code == self.code && [domain isEqualToString:self.domain];
}

- (BOOL) isErrorDomain:(NSString*) domain {
	return [domain isEqualToString:self.domain];
}

- (id) initWithDomain:(NSString*) domain
                 code:(NSInteger) code
 localizedDescription:(NSString*) localizedDescription {
    return [self initWithDomain:domain code:code localizedDescription:localizedDescription userInfo:nil stackTrace:nil];
}

/*
#if 0
    NSString* errorCodeString = nil; // [[FLErrorDomainInfo instance] stringFromErrorCode:code withDomain:domain];
    NSString* commentAddOn = nil;
    if(errorCodeString) {
        commentAddOn = [NSString stringWithFormat:@"[%@:%ld (%@)]", domain, (long) code, errorCodeString];
    }
    else {
        commentAddOn = [NSString stringWithFormat:@"[%@:%ld]", domain, (long)code];
    }

    if(comment) {
        localizedDescription = [NSString stringWithFormat:@"%@ (%@) %@", localizedDescription, comment, commentAddOn];
    }
    else {
        localizedDescription = [NSString stringWithFormat:@"%@ %@", localizedDescription, commentAddOn];
    }
    

    if(comment) {
        comment = [NSString stringWithFormat:@"%@ %@", comment, commentAddOn];
    }
    else {
        comment = commentAddOn;
    }
#endif    
*/

- (BOOL) isError_fl {
    return YES;
}

- (NSString*) nameForException {
    return [NSString stringWithFormat:@"%@:%ld", self.domain, (unsigned long) self.code];
}

- (NSString*) reasonForException {
    return [self localizedDescription];
}

- (BOOL) isEqualToError:(NSError*) error {
    return [self.domain isEqualToString:error.domain] && error.code == self.code;
}

@end

@implementation NSObject (FishLampCoreErrors)

- (BOOL) isError_fl {
    return NO;
}

@end
