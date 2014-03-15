//
//	NSError.h
//	FishLamp
//
//	Created by Mike Fullerton on 5/22/09.
//	Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampRequired.h"

@class FLStackTrace;

extern NSString* const FLErrorCommentKey;
extern NSString* const FLStackTraceKey;

@interface NSError (FishLampCore)

// fishlamp properties

// sdk helpers
@property (readonly, strong, nonatomic) NSError* underlyingError;
@property (readonly, strong, nonatomic) NSString* stringEncoding;
@property (readonly, strong, nonatomic) NSURL* URL;
@property (readonly, strong, nonatomic) NSString* filePath; 

- (id) initWithDomain:(NSString*) domain
                 code:(NSInteger) code
 localizedDescription:(NSString*) localizedDescription;


+ (NSError*) errorWithDomain:(id) domainStringOrDomainObject
                        code:(NSInteger) code
        localizedDescription:(NSString*) localizedDescription;


// utils.

- (BOOL) isErrorCode:(NSInteger) code domain:(NSString*) domain;

- (BOOL) isErrorDomain:(NSString*) domain;

- (BOOL) isError_fl;

- (BOOL) isEqualToError:(NSError*) error;

- (NSString*) nameForException;

- (NSString*) reasonForException;
@end

@interface NSObject (FishLampCoreErrors)
- (BOOL) isError_fl;
@end


