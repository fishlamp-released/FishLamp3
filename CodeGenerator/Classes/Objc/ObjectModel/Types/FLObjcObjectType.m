//
//  FLObjcObjectType.m
//  CodeGenerator
//
//  Created by Mike Fullerton on 5/31/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLObjcObjectType.h"

@implementation FLObjcObjectType

- (NSString*) generatedReference {
    return [NSString stringWithFormat:@"%@*", [super generatedReference]];
}

- (BOOL) isObject {
    return YES;
}

@end