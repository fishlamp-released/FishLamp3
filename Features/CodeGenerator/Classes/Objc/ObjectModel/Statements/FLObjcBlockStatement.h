//
//  FLObjcBlockStatement.h
//  CodeGenerator
//
//  Created by Mike Fullerton on 5/31/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLObjcStatement.h"

@interface FLObjcBlockStatement : FLObjcStatement {
@private
    NSMutableArray* _statements;
}
@property (readonly, strong, nonatomic) NSArray* statements;

+ (id) objcBlockStatement;

- (void) addStatement:(FLObjcStatement*) statement;

@end
