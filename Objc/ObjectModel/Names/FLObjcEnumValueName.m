//
//  FLObjcEnumValueName.m
//  CodeGenerator
//
//  Created by Mike Fullerton on 5/31/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLObjcEnumValueName.h"



@implementation FLObjcEnumValueName : FLObjcName 
+ (id) objcEnumValueName:(NSString*) name prefix:(NSString*) prefix {
    return FLAutorelease([[[self class] alloc] initWithIdentifierName:name prefix:prefix suffix:nil]);
}
- (NSString*) generatedName {
    return [NSString stringWithFormat:@"%@%@", self.prefix, [self.identifier stringWithUppercaseFirstLetter_fl]];
}
@end
