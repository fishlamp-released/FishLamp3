//
//  FLObjcStringType.m
//  FishLampCodeGenerator
//
//  Created by Mike Fullerton on 7/1/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLObjcStringType.h"
#import "FishLampCodeGeneratorObjects.h"

@implementation FLObjcStringType

- (FLCodeElement*) defaultValueForString:(NSString*) string {
    return [FLCodeStatement codeStatement:
                [FLCodeReturn codeReturn:
                    [FLCodeString codeString:string]]];
}

@end
