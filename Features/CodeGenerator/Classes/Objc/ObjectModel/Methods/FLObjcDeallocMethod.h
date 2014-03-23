//
//  FLObjcDeallocMethod.h
//  CodeGenerator
//
//  Created by Mike Fullerton on 5/31/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLObjcMethod.h"

@class FLObjcDeallocStatement;
@interface FLObjcDeallocMethod : FLObjcMethod {
@private
    FLObjcDeallocStatement* _deallocStatement;
}
@end

