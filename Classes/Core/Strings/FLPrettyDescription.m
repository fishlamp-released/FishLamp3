//
//  FLPrettyDescription.m
//  FishLampCore
//
//  Created by Mike Fullerton on 11/11/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLPrettyDescription.h"
#import "FLPrettyString.h"

@implementation NSObject (FLPrettyString)

- (NSString*) prettyDescription {
    FLPrettyString* str = [FLPrettyString prettyString];
    [self prettyDescription:str];
    return [str string];
}

- (void) prettyDescription:(id<FLStringFormatter>) string {
    [string appendLine:[self description]];
}

@end

@implementation NSArray (FLPrettyString)
- (void) prettyDescription:(id<FLStringFormatter>) string {
    for(id object in self) {
        [string appendPrettyDescriptionForObject:object];
    }
}
@end

@implementation NSDictionary (FLPrettyString)
- (void) prettyDescribe:(id<FLStringFormatter>) string {
    for(id key in self) {
        [string appendFormat:@"%@: ", key];
        [string appendPrettyDescriptionForObject:[self objectForKey:key]];
    }
}
@end

