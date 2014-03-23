//
//  FLObjcGeneratedBaseClassName.m
//  FishLampCodeGenerator
//
//  Created by Mike Fullerton on 6/19/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLObjcGeneratedBaseClassName.h"

#define kAddition @"BaseClass"

@implementation FLObjcGeneratedBaseClassName

- (id) initWithIdentifierName:(NSString*) name  
                       prefix:(NSString*) prefix 
                       suffix:(NSString*) suffix {
    return [super initWithIdentifierName:[NSString stringWithFormat:@"%@%@", name, kAddition] prefix:prefix suffix:suffix];

}

+ (id) objcGeneratedClassName:(NSString*) className prefix:(NSString*) prefix {
    return FLAutorelease([[[self class] alloc] initWithIdentifierName:className prefix:prefix suffix:nil]);
}

@end
