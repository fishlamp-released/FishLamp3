//
//  FLObjcBoolType.m
//  CodeGenerator
//
//  Created by Mike Fullerton on 5/31/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLObjcBoolType.h"
#import "FLObjcCodeGeneratorHeaders.h"


@implementation FLObjcBoolType 

- (id) init {	
	return [super initWithTypeName:[FLObjcImportedName objcImportedName:@"BOOL"]  importFileName:nil];
}

+ (id) objcBoolType {
    return FLAutorelease([[[self class] alloc] init]);
}

- (BOOL) isObject {
    return NO;
}

//+ (id) objcNumberValueType:(NSString*) numberType {
//    return FLAutorelease([[[self class] alloc] init]);
//}

static NSString* s_yesValues[] = {
    @"YES", @"TRUE", @"1", nil
};
static NSString* s_noValues[] = {
    @"NO", @"FALSE", @"0", nil
};

- (FLCodeElement*) defaultValueForString:(NSString*) string {

    for(int i = 0; s_yesValues[i] != nil; i++) {
        if(FLStringsAreEqualCaseInsensitive(s_yesValues[i], string)) {
            return [FLCodeStatement codeStatement:
                        [FLCodeReturn codeReturn:@"YES"]];
        }
    }

    for(int i = 0; s_noValues[i] != nil; i++) {
        if(FLStringsAreEqualCaseInsensitive(s_yesValues[i], string)) {
            return [FLCodeStatement codeStatement:
                        [FLCodeReturn codeReturn:@"NO"]];
        }
    }


    return nil;
}

//- (NSString*) generatedObjectClassName {
//    return @"NSNumber";
//}


@end
