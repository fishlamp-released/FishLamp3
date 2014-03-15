//
//  FLObjcContainerType.h
//  CodeGenerator
//
//  Created by Mike Fullerton on 5/31/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLObjcMutableObjectType.h"

@class FLObjcContainerSubType;
@interface FLObjcContainerType : FLObjcMutableObjectType {
@private
    NSMutableArray* _containerSubTypes;
}
+ (id) objcContainerType;

@property (readonly, strong, nonatomic) NSArray* containerSubTypes;

- (void) addContainerSubType:(FLObjcContainerSubType*) subType;

@end