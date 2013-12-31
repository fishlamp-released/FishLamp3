//
//  FLObjcClassName.m
//  CodeGenerator
//
//  Created by Mike Fullerton on 5/31/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLObjcClassName.h"

@implementation FLObjcClassName 
+ (id) objcClassName:(NSString*) className prefix:(NSString*) prefix {
    return FLAutorelease([[[self class] alloc] initWithIdentifierName:className prefix:prefix suffix:nil]);
}

- (NSString*) generatedName {
    return [NSString stringWithFormat:@"%@%@%@", self.prefix, [self.identifier stringWithUppercaseFirstLetter_fl], self.suffix];
}

@end