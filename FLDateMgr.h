//
//  NSDate+Decoding.h
//  fBee
//
//  Created by Mike Fullerton on 5/29/11.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton.
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampCore.h"

@interface FLDateMgr : NSObject {
@private
	id _formatter;
}

FLSingletonProperty(FLDateMgr); 

- (NSDate*) ISO8601StringToDate:(NSString*) string;
- (NSString*) ISO8601DateToString:(NSDate*) date;

- (NSString*) ISO3339DateToString:(NSDate*) date;
- (NSDate*) ISO3339StringToDate:(NSString*) string;

@end


