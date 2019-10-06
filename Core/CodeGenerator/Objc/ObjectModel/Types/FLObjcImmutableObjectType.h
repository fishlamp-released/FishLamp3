//
//  FLObjcImmutableObjectType.h
//  CodeGenerator
//
//  Created by Mike Fullerton on 6/3/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLObjcObjectType.h"

@interface FLObjcImmutableObjectType : FLObjcObjectType

+ (id) objcImmutableObjectType:(FLObjcName*) typeName 
                importFileName:(NSString*) importFileName;

@end
