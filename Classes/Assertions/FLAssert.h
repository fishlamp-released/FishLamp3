//
//  FLAssert.h
//  FishLampCore
//
//  Created by Mike Fullerton on 9/3/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FishLampRequired.h"
#import "FishLampExceptions.h"
#import "NSError+FLStackTrace.h"
#import "FLAssertionFailureErrorDomain.h"
#import "FLAssertionHandler.h"

#if !defined(ASSERTIONS) && (defined(DEBUG) || defined(TEST))
#define ASSERTIONS 1
#endif

#if ASSERTIONS

    #define FLHandleAssertionFailure(CODE, NAME, DESCRIPTION) \
                do { \
                    NSException* __EX = [[FLAssertionHandler sharedHandler] assertionFailed:FLAssertionFailureErrorDomain \
                                                                                       code:CODE \
                                                                 stackTrace:FLStackTraceMake(FLCurrentFileLocation(), YES) \
                                                                       name:NAME \
                                                                description:DESCRIPTION]; \
                    if(__EX) { \
                        FLThrowException(__EX);  \
                    } \
                } \
                while (0)


    #define FLAssertFailed(DESCRIPTION...) \
                FLHandleAssertionFailure(FLAssertionFailureCondition, \
                    @"Assertion Failed", \
                    ([NSString stringWithFormat:@"" DESCRIPTION]))

    #define FLAssert(CONDITION, DESCRIPTION...) \
                do { \
                    if(!(CONDITION)) { \
                        FLHandleAssertionFailure(FLAssertionFailureCondition, \
                            ([NSString stringWithFormat:@"Asserting \"%s\" Failed", #CONDITION]), \
                            ([NSString stringWithFormat:@"" DESCRIPTION])); \
                    } \
                } \
                while(0)

    #define FLAssertIsNil(REFERENCE, DESCRIPTION...)  \
                do { \
                    if((REFERENCE) == nil) { \
                        FLHandleAssertionFailure(FLAssertionFailureCondition, \
                            ([NSString stringWithFormat:@"Asserting '%s == nil' Failed", #REFERENCE]), \
                            ([NSString stringWithFormat:@"" DESCRIPTION])); \
                    } \
                } \
                while(0)

    #define FLAssertIsNotNil(REFERENCE, DESCRIPTION...) \
                do { \
                    if((REFERENCE) != nil) { \
                        FLHandleAssertionFailure(FLAssertionFailureCondition, \
                            ([NSString stringWithFormat:@"Asserting '%s != nil' Failed", #REFERENCE]), \
                            ([NSString stringWithFormat:@"" DESCRIPTION])); \
                    } \
                } \
                while(0)



    #define FLAssertStringIsNotEmpty(STRING, DESCRIPTION...) \
                do { \
                    if(FLStringIsEmpty(STRING) == YES) { \
                        FLHandleAssertionFailure(FLAssertionFailureCondition, \
                            ([NSString stringWithFormat:@"Asserting String is not empty for '%s' Failed", #STRING]), \
                            ([NSString stringWithFormat:@"" DESCRIPTION])); \
                    } \
                } \
                while(0)


    #define FLAssertStringIsEmpty(STRING, DESCRIPTION...) \
                do { \
                    if(FLStringIsEmpty(STRING) == NO) { \
                        FLHandleAssertionFailure(FLAssertionFailureCondition, \
                            ([NSString stringWithFormat:@"Asserting String is empty for '%s' Failed", #STRING]), \
                            ([NSString stringWithFormat:@"" DESCRIPTION])); \
                    } \
                } \
                while(0)


    #define FLAssertStringsAreEqual(a,b, DESCRIPTION...) \
                FLAssert(FLStringsAreEqual(a,b), @"" DESCRIPTION);

    #define FLAssertStringsNotEqual(a,b, DESCRIPTION...) \
                FLAssert(!FLStringsAreEqual(a,b), @"" DESCRIPTION);

    #define FLAssertIsKindOfClass(__OBJ__, __CLASS__, DESCRIPTION...) \
                FLAssert([__OBJ__ isKindOfClass:[__CLASS__ class]], @"" DESCRIPTION)

    #define FLAssertConformsToProcol(__OBJ__, __PROTOCOL__, DESCRIPTION...) \
                FLAssert([__OBJ__ conformsToProtocol:@protocol(__PROTOCOL__)], @"" DESCRIPTION)

//    #define FLAssertStringIsNotEmptyWithComment(__STRING__, __FORMAT__, ...) \
//                FL_ASSERT_STRING_IS_NOT_EMPTY_WITH_COMMENT(FL_ASSERT_THROWER, __STRING__, __FORMAT__, ##__VA_ARGS__)
//
//    #define FLAssertStringIsEmptyWithComment(__STRING__, __FORMAT__, ...) \
//                FL_ASSERT_STRING_IS_EMPTY_WITH_COMMENT(FL_ASSERT_THROWER, __STRING__, __FORMAT__, ##__VA_ARGS__)

#else
    #define FLAssert(...) 
    #define FLAssertFailed()
    #define FLAssertIsNil(...)
    #define FLAssertIsNotNil(...)
    #define FLAssertStringIsNotEmpty(...)
    #define FLAssertStringIsEmpty(...)
    #define FLAssertIsKindOfClass(...)
#endif


#define FLAssertNotNil \
            FLAssertIsNotNil

#define FLAssertNil \
            FLAssertIsNil

#define FLAssertionFailed \
            FLAssertFailed

