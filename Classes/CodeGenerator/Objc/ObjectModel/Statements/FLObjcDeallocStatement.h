//
//  FLObjcDeallocStatement.h
//  CodeGenerator
//
//  Created by Mike Fullerton on 5/31/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLObjcStatement.h"
@class FLObjcObject;

@interface FLObjcDeallocStatement : FLObjcStatement {
@private
    __unsafe_unretained FLObjcObject* _object;
}
@property (readwrite, assign, nonatomic) FLObjcObject* object;
@end