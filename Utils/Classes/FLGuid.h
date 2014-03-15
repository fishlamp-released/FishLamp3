//
//	FLGuid.h
//	FishLamp
//
//	Created by Mike Fullerton on 2/16/10.
//	Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampCore.h"

#import "FishLampCore.h"

#import "NSString+GUID.h"

// TODO: see new SDK object NSUUID

@interface FLGuid : NSObject<NSCopying, NSCoding> {
@private
	NSString* _guid;
}

+ (FLGuid*) emptyGuid;

+ (FLGuid*) guid;
+ (FLGuid*) guidWithNewGuid;
+ (FLGuid*) guidWithString:(NSString*) aGuidString;

- (id) init;
- (id) initWithGuidString:(NSString*) guid;
- (id) initWithNewGuid;

@property (readwrite, retain, nonatomic) NSString* guidString;

- (BOOL)isEqualToString:(NSString*) aString;
- (BOOL)isEqualToGuid:(FLGuid*) aGuid;

@end

NS_INLINE 
BOOL FLIsValidGuid(FLGuid* guid)
{
	return guid != nil && FLStringIsNotEmpty(guid.guidString);
}