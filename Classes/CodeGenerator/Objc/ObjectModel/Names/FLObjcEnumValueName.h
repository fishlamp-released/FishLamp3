//
//  FLObjcEnumValueName.h
//  CodeGenerator
//
//  Created by Mike Fullerton on 5/31/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLObjcName.h"

@interface FLObjcEnumValueName : FLObjcName 
+ (id) objcEnumValueName:(NSString*) name  prefix:(NSString*) prefix;
@end
