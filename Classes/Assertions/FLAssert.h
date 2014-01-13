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

//#if __clang
//    #if ASSERTIONS
//        #undef ASSERTIONS
//    #endif
//#endif

#if ASSERTIONS

//#if 0 
//// __clang__
//
//    #define TURNOFF_CLANG_WARNING \
//        _Pragma("clang diagnostic push") \
//        _Pragma("clang diagnostic ignored \"-Wnonnull\"")
//        _Pragma("clang diagnostic ignored \"-Wall\"")
////
//
//    #define TURNON_CLANG_WARNINGS \
//        _Pragma("clang diagnostic pop")
//#else
//    #define TURNOFF_CLANG_WARNING
//    #define TURNON_CLANG_WARNINGS
//
//#endif

    #define FLHandleAssertionFailure(CODE, NAME, DESCRIPTION, CONTEXT) \
                do { \
                    NSException* __EX = [[FLAssertionHandler sharedHandler] assertionFailed:FLAssertionFailureErrorDomain \
                                                                                       code:CODE \
                                                                 stackTrace:FLStackTraceMake(FLCurrentFileLocation(), YES) \
                                                                       name:NAME \
                                                                description:[NSString stringWithFormat:@"%@: %@", CONTEXT, DESCRIPTION]]; \
                    if(__EX) { \
                        FLThrowException(__EX);  \
                    } \
                } \
                while (0)


    #define FLAssertFailed(DESCRIPTION...) \
                FLHandleAssertionFailure(FLAssertionFailureCondition, \
                    @"Assertion Failed", \
                    ([NSString stringWithFormat:@"" DESCRIPTION]), \
                    NSStringFromClass([self class]))

    #define FLCAssertFailed(DESCRIPTION...) \
                FLHandleAssertionFailure(FLAssertionFailureCondition, \
                    @"Assertion Failed", \
                    ([NSString stringWithFormat:@"" DESCRIPTION]), \
                    @"")


    #define FLAssert(CONDITION, DESCRIPTION...) \
                do { \
                    if(!(CONDITION)) { \
                        FLHandleAssertionFailure(FLAssertionFailureCondition, \
                            ([NSString stringWithFormat:@"Asserting \"%s\" Failed", #CONDITION]), \
                            ([NSString stringWithFormat:@"" DESCRIPTION]), \
                            NSStringFromClass([self class])); \
                    } \
                } \
                while(0)

    #define FLCAssert(CONDITION, DESCRIPTION...) \
                do { \
                    if(!(CONDITION)) { \
                        FLHandleAssertionFailure(FLAssertionFailureCondition, \
                            ([NSString stringWithFormat:@"Asserting \"%s\" Failed", #CONDITION]), \
                            ([NSString stringWithFormat:@"" DESCRIPTION]), \
                            @""); \
                    } \
                } \
                while(0)

    #define FLAssertNil(REFERENCE, DESCRIPTION...)  \
                do { \
                    if(nil != (REFERENCE)) { \
                        FLHandleAssertionFailure(FLAssertionFailureCondition, \
                            ([NSString stringWithFormat:@"Asserting '%s == nil' Failed", #REFERENCE]), \
                            ([NSString stringWithFormat:@"" DESCRIPTION]), \
                            NSStringFromClass([self class])); \
                    } \
                } \
                while(0)

    #define FLAssertNotNil(REFERENCE, DESCRIPTION...) \
                do { \
                    if(nil == (REFERENCE)) { \
                        FLHandleAssertionFailure(FLAssertionFailureCondition, \
                            ([NSString stringWithFormat:@"Asserting '%s != nil' Failed", #REFERENCE]), \
                            ([NSString stringWithFormat:@"" DESCRIPTION]), \
                            NSStringFromClass([self class])); \
                    } \
                } \
                while(0)

    #define FLCAssertNil(REFERENCE, DESCRIPTION...)  \
                do { \
                    if(nil != (REFERENCE)) { \
                        FLHandleAssertionFailure(FLAssertionFailureCondition, \
                            ([NSString stringWithFormat:@"Asserting '%s == nil' Failed", #REFERENCE]), \
                            ([NSString stringWithFormat:@"" DESCRIPTION]), \
                            @""); \
                    } \
                } \
                while(0)

    #define FLCAssertNotNil(REFERENCE, DESCRIPTION...) \
                do { \
                    if(nil == (REFERENCE)) { \
                        FLHandleAssertionFailure(FLAssertionFailureCondition, \
                            ([NSString stringWithFormat:@"Asserting '%s != nil' Failed", #REFERENCE]), \
                            ([NSString stringWithFormat:@"" DESCRIPTION]), \
                            @""); \
                    } \
                } \
                while(0)

    #define FLAssertNonZeroNumber(NUMBER, DESCRIPTION...) \
                do { \
                    if((NUMBER) == 0) { \
                        FLHandleAssertionFailure(FLAssertionFailureCondition, \
                            ([NSString stringWithFormat:@"Asserting '%s != 0' Failed", #NUMBER]), \
                            ([NSString stringWithFormat:@"" DESCRIPTION]), \
                            NSStringFromClass([self class])); \
                    } \
                } \
                while(0)

    #define FLAssertZeroNumber(NUMBER, DESCRIPTION...) \
                do { \
                    if((NUMBER) != 0) { \
                        FLHandleAssertionFailure(FLAssertionFailureCondition, \
                            ([NSString stringWithFormat:@"Asserting '%s != 0' Failed", #NUMBER]), \
                            ([NSString stringWithFormat:@"" DESCRIPTION]), \
                            NSStringFromClass([self class])); \
                    } \
                } \
                while(0)


    #define FLAssertNonNilPointer(POINTER, DESCRIPTION...) \
                do { \
                    if((POINTER) == nil) { \
                        FLHandleAssertionFailure(FLAssertionFailureCondition, \
                            ([NSString stringWithFormat:@"Asserting '%s != nil' Failed", #POINTER]), \
                            ([NSString stringWithFormat:@"" DESCRIPTION]), \
                            NSStringFromClass([self class])); \
                    } \
                } \
                while(0)

    #define FLAssertNilPointer(POINTER, DESCRIPTION...) \
                do { \
                    if((POINTER) != nil) { \
                        FLHandleAssertionFailure(FLAssertionFailureCondition, \
                            ([NSString stringWithFormat:@"Asserting '%s == nil' Failed", #POINTER]), \
                            ([NSString stringWithFormat:@"" DESCRIPTION]), \
                            NSStringFromClass([self class])); \
                    } \
                } \
                while(0)

    #define FLAssertStringIsNotEmpty(STRING, DESCRIPTION...) \
                do { \
                    if(FLStringIsEmpty(STRING) == YES) { \
                        FLHandleAssertionFailure(FLAssertionFailureCondition, \
                            ([NSString stringWithFormat:@"Asserting String is not empty for '%s' Failed", #STRING]), \
                            ([NSString stringWithFormat:@"" DESCRIPTION]), \
                            NSStringFromClass([self class])); \
                    } \
                } \
                while(0)


    #define FLAssertStringIsEmpty(STRING, DESCRIPTION...) \
                do { \
                    if(FLStringIsEmpty(STRING) == NO) { \
                        FLHandleAssertionFailure(FLAssertionFailureCondition, \
                            ([NSString stringWithFormat:@"Asserting String is empty for '%s' Failed", #STRING]), \
                            ([NSString stringWithFormat:@"" DESCRIPTION]), \
                            NSStringFromClass([self class])); \
                    } \
                } \
                while(0)


    #define FLCAssertNonZeroNumber(NUMBER, DESCRIPTION...) \
                do { \
                    if((NUMBER) == 0) { \
                        FLHandleAssertionFailure(FLAssertionFailureCondition, \
                            ([NSString stringWithFormat:@"Asserting '%s != 0' Failed", #NUMBER]), \
                            ([NSString stringWithFormat:@"" DESCRIPTION]), \
                            NSStringFromClass([self class])); \
                    } \
                } \
                while(0)

    #define FLCAssertZeroNumber(NUMBER, DESCRIPTION...) \
                do { \
                    if((NUMBER) != 0) { \
                        FLHandleAssertionFailure(FLAssertionFailureCondition, \
                            ([NSString stringWithFormat:@"Asserting '%s != 0' Failed", #NUMBER]), \
                            ([NSString stringWithFormat:@"" DESCRIPTION]), \
                            @""); \
                    } \
                } \
                while(0)


    #define FLCAssertNonNilPointer(POINTER, DESCRIPTION...) \
                do { \
                    if((POINTER) == nil) { \
                        FLHandleAssertionFailure(FLAssertionFailureCondition, \
                            ([NSString stringWithFormat:@"Asserting '%s != nil' Failed", #POINTER]), \
                            ([NSString stringWithFormat:@"" DESCRIPTION]), \
                            @""); \
                    } \
                } \
                while(0)

    #define FLCAssertNilPointer(POINTER, DESCRIPTION...) \
                do { \
                    if((POINTER) != nil) { \
                        FLHandleAssertionFailure(FLAssertionFailureCondition, \
                            ([NSString stringWithFormat:@"Asserting '%s == nil' Failed", #POINTER]), \
                            ([NSString stringWithFormat:@"" DESCRIPTION]), \
                            @""); \
                    } \
                } \
                while(0)



    #define FLCAssertStringIsNotEmpty(STRING, DESCRIPTION...) \
                do { \
                    if(FLStringIsEmpty(STRING) == YES) { \
                        FLHandleAssertionFailure(FLAssertionFailureCondition, \
                            ([NSString stringWithFormat:@"Asserting String is not empty for '%s' Failed", #STRING]), \
                            ([NSString stringWithFormat:@"" DESCRIPTION]), \
                            @""); \
                    } \
                } \
                while(0)


    #define FLCAssertStringIsEmpty(STRING, DESCRIPTION...) \
                do { \
                    if(FLStringIsEmpty(STRING) == NO) { \
                        FLHandleAssertionFailure(FLAssertionFailureCondition, \
                            ([NSString stringWithFormat:@"Asserting String is empty for '%s' Failed", #STRING]), \
                            ([NSString stringWithFormat:@"" DESCRIPTION]), \
                            @""); \
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


#else
    #define FLAssert(...) 
    #define FLAssertFailed()
    #define FLAssertNil(...)
    #define FLAssertNotNil(...)
    #define FLAssertStringIsNotEmpty(...)
    #define FLAssertStringIsEmpty(...)
    #define FLAssertIsKindOfClass(...)
    #define FLAssertNonZeroNumber(NUMBER, DESCRIPTION...)
    #define FLAssertZeroNumber(NUMBER, DESCRIPTION...)
    #define FLAssertNonNilPointer(POINTER, DESCRIPTION...)
    #define FLAssertNilPointer(POINTER, DESCRIPTION...)

    #define FLIsNotNil(THING) (THING) != nil

#endif


#define FLAssertionFailed \
            FLAssertFailed





