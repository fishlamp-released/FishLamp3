//
//  FLObjcEnumType.h
//  CodeGenerator
//
//  Created by Mike Fullerton on 5/31/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLObjcObjectType.h"
@class FLObjcName;

@interface FLObjcEnumType : FLObjcObjectType 
+ (id) objcEnumType:(FLObjcName*) typeName 
       importFileName:(NSString*) importFileName;

- (NSString*) enumSetClassName;
- (NSString*) stringFromEnumFunctionName;
- (NSString*) enumFromStringFunctionName;
- (NSString*) stringFromEnumFunctionPrototype;
- (NSString*) enumFromStringFunctionPrototype;

@end


