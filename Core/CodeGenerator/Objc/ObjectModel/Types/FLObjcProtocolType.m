//
//  FLObjcProtocolType.m
//  CodeGenerator
//
//  Created by Mike Fullerton on 5/31/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLObjcProtocolType.h"



@implementation FLObjcProtocolType
+ (id) objcProtocolType:(FLObjcName*) typeName 
       importFileName:(NSString*) importFileName {
    return FLAutorelease([[[self class] alloc] initWithTypeName:typeName importFileName:importFileName]);
}

- (NSString*) generatedReference {
    return [NSString stringWithFormat:@"id<%@>", [super generatedReference]];
}

@end
