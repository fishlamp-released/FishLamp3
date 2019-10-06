//
//  FLCodeGeneratorErrors.h
//  CodeGenerator
//
//  Created by Mike Fullerton on 2/3/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FishLampCore.h"
#import "FishLampExceptions.h"

extern NSString* const FLCodeGeneratorErrorDomain;

typedef NS_ENUM(NSInteger, FLCodeGeneratorErrorCode) {
    FLCodeGeneratorErrorCodeUnknownError                = 1,
    FLCodeGeneratorErrorCodeItemExists                  = 2,
    FLCodeGeneratorErrorCodeDuplicateItem               = 3, 
    FLCodeGeneratorErrorCodeUnexpectedlyEmptyString     = 4, 
    FLCodeGeneratorErrorCodeUnknownType                 = 5, 
    FLCodeGeneratorErrorCodeTranslatorFailed            = 6, 
    FLCodeGeneratorErrorCodeProjectNotFound             = 7, 
    FLCodeGeneratorErrorCodeMissingName                 = 8,
    FLCodeGeneratorErrorImportNotLoaded                 = 9
};

#define FLThrowCodeGeneratorError(__CODE__, __FORMAT__, ...) \
            FLThrowError([NSError errorWithDomain:FLCodeGeneratorErrorDomain \
                            code:(__CODE__) \
                            localizedDescription: FLStringWithFormatOrNil(__FORMAT__, ##__VA_ARGS__) \
                            userInfo:nil \
                            stackTrace:FLCreateStackTrace(YES)])
