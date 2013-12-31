//
//  FLObjectPropertyName.m
//  CodeGenerator
//
//  Created by Mike Fullerton on 5/31/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLObjectPropertyName.h"

@implementation FLObjcPropertyName : FLObjcName
+ (id) objcPropertyName:(NSString*) propertyName {
    return FLAutorelease([[[self class] alloc] initWithIdentifierName:propertyName prefix:nil suffix:nil]);
}

- (NSString*) generatedName {
    return [NSString stringWithFormat:@"%@%@%@", self.prefix, [self.identifier stringWithLowercaseFirstLetter_fl], self.suffix];
}

@end
