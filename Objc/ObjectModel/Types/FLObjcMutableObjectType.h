//
//  FLObjcMutableObjectType.h
//  CodeGenerator
//
//  Created by Mike Fullerton on 6/3/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLObjcObjectType.h"

@interface FLObjcMutableObjectType : FLObjcObjectType

+ (id) objcMutableObjectType:(FLObjcName*) typeName 
       importFileName:(NSString*) importFileName;
       

@end
