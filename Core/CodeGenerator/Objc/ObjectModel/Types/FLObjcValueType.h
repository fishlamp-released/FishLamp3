//
//  FLObjcValueType.h
//  CodeGenerator
//
//  Created by Mike Fullerton on 5/31/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLObjcType.h"
@class FLObjcName;

@interface FLObjcValueType : FLObjcType
+ (id) objcValueType:(FLObjcName*) typeName 
       importFileName:(NSString*) importFileName;
@end

