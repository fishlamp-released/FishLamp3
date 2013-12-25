//
//  FLAssert.h
//  FishLampCore
//
//  Created by Mike Fullerton on 9/3/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FishLampRequired.h"
#import "FishLampExceptions.h"
#import "NSString+FishLampCore.h"
#import "NSError+FLStackTrace.h"
#import "FLAssertionFailedError.h"
#import "FLAssertionFailureErrorDomain.h"

#import "FLAssert_Implementation.h"

#import "FLAssertionHandler.h"

#define FLThrowAssertionFailure(CODE, NAME, DESCRIPTION) \
            FLThrowException( \
                [FLAssertionHandler createException:FLAssertionFailureErrorDomain \
                                               code:CODE \
                                         stackTrace:FLStackTraceMake(FLCurrentFileLocation(), YES) \
                                               name:NAME \
                                        description:DESCRIPTION])


#if !defined(ASSERTIONS) && (defined(DEBUG) || defined(TEST))
#define ASSERTIONS 1
#endif


#if ASSERTIONS

    #define FLAssertFailed(DESCRIPTION...) \
                FLThrowAssertionFailure(FLAssertionFailureCondition, \
                    @"Assertion Failed", \
                    ([NSString stringWithFormat:@"" DESCRIPTION]))

    #define FLAssert(CONDITION, DESCRIPTION...) \
                do { \
                    if(!(CONDITION)) { \
                        FLThrowAssertionFailure(FLAssertionFailureCondition, \
                            ([NSString stringWithFormat:@"Asserting \"%s\" Failed", #CONDITION]), \
                            ([NSString stringWithFormat:@"" DESCRIPTION])); \
                    } \
                } \
                while(0)

    #define FLAssertIsNil(REFERENCE, DESCRIPTION...)  \
                do { \
                    if((REFERENCE) == nil) { \
                        FLThrowAssertionFailure(FLAssertionFailureCondition, \
                            ([NSString stringWithFormat:@"Asserting '%s == nil' Failed", #REFERENCE]), \
                            ([NSString stringWithFormat:@"" DESCRIPTION])); \
                    } \
                } \
                while(0)

    #define FLAssertIsNotNil(REFERENCE, DESCRIPTION...) \
                do { \
                    if((REFERENCE) != nil) { \
                        FLThrowAssertionFailure(FLAssertionFailureCondition, \
                            ([NSString stringWithFormat:@"Asserting '%s != nil' Failed", #REFERENCE]), \
                            ([NSString stringWithFormat:@"" DESCRIPTION])); \
                    } \
                } \
                while(0)

    #define FL_ASSERT_THROWER(__CODE__, __REASON__, __COMMENT__) \
                FLThrowError([NSError assertionFailedError:__CODE__ reason:__REASON__ comment:__COMMENT__ stackTrace:FLCreateStackTrace(YES)])


    #define FLAssertStringIsNotEmpty(__STRING__, DESCRIPTION, ...) \
                FL_ASSERT_STRING_IS_NOT_EMPTY(FL_ASSERT_THROWER, __STRING__)


    #define FLAssertStringIsEmpty(__STRING__, DESCRIPTION, ...) \
                FL_ASSERT_STRING_IS_EMPTY(FL_ASSERT_THROWER, __STRING__)


    #define FLAssertStringsAreEqual(a,b, DESCRIPTION, ...) \
                FLAssert(FLStringsAreEqual(a,b));

    #define FLAssertStringsNotEqual(a,b, DESCRIPTION, ...) \
                FLAssert(!FLStringsAreEqual(a,b));

    #define FLAssertIsKindOfClass(__OBJ__, __CLASS__, DESCRIPTION, ...) \
                FLAssert([__OBJ__ isKindOfClass:[__CLASS__ class]])

    #define FLAssertConformsToProcol(__OBJ__, __PROTOCOL__, DESCRIPTION, ...) \
                FLAssert([__OBJ__ conformsToProtocol:@protocol(__PROTOCOL__)])


    #define FLAssertStringIsNotEmptyWithComment(__STRING__, __FORMAT__, ...) \
                FL_ASSERT_STRING_IS_NOT_EMPTY_WITH_COMMENT(FL_ASSERT_THROWER, __STRING__, __FORMAT__, ##__VA_ARGS__)
    #define FLAssertStringIsEmptyWithComment(__STRING__, __FORMAT__, ...) \
                FL_ASSERT_STRING_IS_EMPTY_WITH_COMMENT(FL_ASSERT_THROWER, __STRING__, __FORMAT__, ##__VA_ARGS__)

#else
    #define FLAssert(...) 
    #define FLAssertFailed()
    #define FLAssertIsNil(...)
    #define FLAssertIsNotNil(...)
    #define FLAssertStringIsNotEmpty(...)
    #define FLAssertStringIsEmpty(...)
    #define FLAssertIsKindOfClass(...)

    #define FLAssertStringIsNotEmptyWithComment(...)
    #define FLAssertStringIsEmptyWithComment(...)
    #define FLAssertIsKindOfClassWithComment(...)
#endif

#define FLAssertFailedWithComment FLAssertFailed
#define FLAssertWithComment FLAssert
#define FLAssertIsNilWithComment FLAssertIsNil
#define FLAssertIsNotNilWithComment FLAssertIsNotNil


#define FLAssertNotNil \
            FLAssertIsNotNil

#define FLAssertNotNilWithComment  \
            FLAssertIsNotNilWithComment

#define FLAssertNil \
            FLAssertIsNil

#define FLAssertNilWithComment \
            FLAssertIsNilWithComment

#define FLAssertionFailedWithComment \
            FLAssertFailedWithComment

#define FLAssertionFailed \
            FLAssertFailed


