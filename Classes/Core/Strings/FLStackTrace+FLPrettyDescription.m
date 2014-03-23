//
//  FLStackTrace+FLPrettyDescription.m
//  Pods
//
//  Created by Mike Fullerton on 1/1/14.
//
//

#import "FLStackTrace+FLPrettyDescription.h"
#import "FishLampStrings.h"
#import "FishLampStackTrace.h"

@implementation FLStackTrace (FLPrettyDescription)

- (void) appendToStringFormatter:(id<FLStringFormatter>) string {
    [string appendLineWithFormat:@"%s:%d, %s",
                            FLFileLocationGetFileName(&_stackTrace.location),
                            _stackTrace.location.line, 
                            _stackTrace.location.function];

    [string indentLinesInBlock:^{
        for(int i = 0; i < self.stackDepth; i++) {
            [string appendLineWithFormat:@"%s", [self stackEntryAtIndex:i]];
        }
    }];
}

- (void) prettyDescription:(id<FLStringFormatter>) string {
    [self appendToStringFormatter:string];
}

- (NSString*) description {
    return [self prettyDescription];
}

@end
