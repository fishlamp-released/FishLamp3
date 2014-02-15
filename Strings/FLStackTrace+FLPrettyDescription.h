//
//  FLStackTrace+FLPrettyDescription.h
//  Pods
//
//  Created by Mike Fullerton on 1/1/14.
//
//

#import "FLStackTrace.h"

@protocol FLStringFormatter;

@interface FLStackTrace (FLPrettyDescription)
- (void) appendToStringFormatter:(id<FLStringFormatter>) string;
- (void) prettyDescription:(id<FLStringFormatter>) string;
@end
