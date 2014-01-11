//
//  FLObjcArrayType.h
//  CodeGenerator
//
//  Created by Mike Fullerton on 5/31/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLObjcContainerType.h"
@class FLObjcContainerType;


@interface FLObjcArrayType : FLObjcContainerType 
+ (id) objcArrayType:(FLObjcName*) typeName 
       importFileName:(NSString*) importFileName;
@end

