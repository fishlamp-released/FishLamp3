//
//	NSError.h
//	FishLamp
//
//	Created by Mike Fullerton on 5/22/09.
//	Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampObjc.h"

@class FLStackTrace;

extern NSString* const FLErrorCommentKey;
extern NSString* const FLStackTraceKey;

@interface NSError (FishLamp) 

// fishlamp properties
@property (readonly, strong, nonatomic) FLStackTrace* stackTrace;

// sdk helpers
@property (readonly, strong, nonatomic) NSError* underlyingError;
@property (readonly, strong, nonatomic) NSString* stringEncoding;
@property (readonly, strong, nonatomic) NSURL* URL;
@property (readonly, strong, nonatomic) NSString* filePath; 

- (id) initWithDomain:(NSString*) domain
                 code:(NSInteger) code
 localizedDescription:(NSString*) localizedDescription;

- (id) initWithDomain:(NSString*) domain
                 code:(NSInteger) code
 localizedDescription:(NSString*) localizedDescription
             userInfo:(NSDictionary *)dict
           stackTrace:(FLStackTrace*) stackTrace;

+ (NSError*) errorWithDomain:(id) domainStringOrDomainObject
                        code:(NSInteger) code
        localizedDescription:(NSString*) localizedDescription;

+ (NSError*) errorWithDomain:(id) domainStringOrDomainObject
                        code:(NSInteger)code
        localizedDescription:(NSString*) localizedDescription
                    userInfo:(NSDictionary *)dict
                  stackTrace:(FLStackTrace*) stackTrace;

+ (NSError*) errorWithError:(NSError*) error stackTrace:(FLStackTrace*) stackTrace;

// utils.

- (BOOL) isErrorCode:(NSInteger) code domain:(NSString*) domain;

- (BOOL) isErrorDomain:(NSString*) domain;

- (BOOL) isError;

- (BOOL) isEqualToError:(NSError*) error;

- (NSString*) nameForException;

- (NSString*) reasonForException;
@end


