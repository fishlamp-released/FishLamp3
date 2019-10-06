//
//  FLWsdlCodeEnumType.h
//  CodeGenerator
//
//  Created by Mike Fullerton on 5/29/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLCodeEnumType.h"
@class FLWsdlCodeEnum;

@interface FLWsdlCodeEnumType : FLCodeEnumType

- (FLWsdlCodeEnum*) addEnum:(NSString*) theEnum enumValue:(NSString*) enumValueOrNil;

@end
