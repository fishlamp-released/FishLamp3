//
//  FLAssert.h
//  FishLampCore
//
//  Created by Mike Fullerton on 9/3/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FishLampCore.h"
#import "FL_ASSERT.h"

#if !defined(ASSERTIONS) && (defined(DEBUG) || defined(TEST))
#define ASSERTIONS 1
#endif


#if ASSERTIONS
    #define FL_ASSERT_THROWER(__CODE__, __REASON__, __COMMENT__) \
                FLThrowError([NSError assertionFailedError:__CODE__ reason:__REASON__ comment:__COMMENT__ stackTrace:FLCreateStackTrace(YES)])

    #define FLAssertFailed() \
                FL_ASSERT_FAILED(FL_ASSERT_THROWER)

    #define FLAssertFailedWithComment(__FORMAT__, ...) \
                FL_ASSERT_FAILED__WITH_COMMENT(FL_ASSERT_THROWER, __FORMAT__, ##__VA_ARGS__)

    #define FLAssert(__CONDITION__) \
                FL_ASSERT(FL_ASSERT_THROWER, __CONDITION__)

    #define FLAssertWithComment(__CONDITION__, __FORMAT__, ...) \
                FL_ASSERT_WITH_COMMENT(FL_ASSERT_THROWER, __CONDITION__, __FORMAT__, ##__VA_ARGS__)

    #define FLAssertIsNil(__PTR__) \
                FL_ASSERT_IS_NIL(FL_ASSERT_THROWER, __PTR__)

    #define FLAssertIsNilWithComment(__PTR__, __FORMAT__, ...) \
                FL_ASSERT_IS_NIL_WITH_COMMENT(FL_ASSERT_THROWER, __PTR__, __FORMAT__, ##__VA_ARGS__)

    #define FLAssertIsNotNil(__PTR__) \
                FL_ASSERT_IS_NOT_NIL(FL_ASSERT_THROWER, __PTR__)

    #define FLAssertIsNotNilWithComment(__PTR__, __FORMAT__, ...) \
                FL_ASSERT_IS_NOT_NIL_WITH_COMMENT(FL_ASSERT_THROWER, __PTR__, __FORMAT__, ##__VA_ARGS__)

    #define FLAssertStringIsNotEmpty(__STRING__) \
                FL_ASSERT_STRING_IS_NOT_EMPTY(FL_ASSERT_THROWER, __STRING__)

    #define FLAssertStringIsNotEmptyWithComment(__STRING__, __FORMAT__, ...) \
                FL_ASSERT_STRING_IS_NOT_EMPTY_WITH_COMMENT(FL_ASSERT_THROWER, __STRING__, __FORMAT__, ##__VA_ARGS__)

    #define FLAssertStringIsEmpty(__STRING__) \
                FL_ASSERT_STRING_IS_EMPTY(FL_ASSERT_THROWER, __STRING__)

    #define FLAssertStringIsEmptyWithComment(__STRING__, __FORMAT__, ...) \
                FL_ASSERT_STRING_IS_EMPTY_WITH_COMMENT(FL_ASSERT_THROWER, __STRING__, __FORMAT__, ##__VA_ARGS__)

    #define FLAssertStringsAreEqual(a,b) \
                FLAssert(FLStringsAreEqual(a,b));

    #define FLAssertStringsNotEqual(a,b) \
                FLAssert(!FLStringsAreEqual(a,b));

    #define FLAssertIsKindOfClass(__OBJ__, __CLASS__) \
                FLAssert([__OBJ__ isKindOfClass:[__CLASS__ class]])

    #define FLAssertConformsToProcol(__OBJ__, __PROTOCOL__) \
                FLAssert([__OBJ__ conformsToProtocol:@protocol(__PROTOCOL__)])


#else
    #define FLAssert(...) 
    #define FLAssertWithComment(...) 
    #define FLAssertFailed() 
    #define FLAssertFailedWithComment(...) 
    #define FLAssertIsNil(...) 
    #define FLAssertIsNilWithComment(...) 
    #define FLAssertIsNotNil(...) 
    #define FLAssertIsNotNilWithComment(...) 
    #define FLAssertStringIsNotEmpty(...) 
    #define FLAssertStringIsNotEmptyWithComment(...) 
    #define FLAssertStringIsEmpty(...) 
    #define FLAssertStringIsEmptyWithComment(...) 
    #define FLAssertIsKindOfClass(...) 
    #define FLAssertIsKindOfClassWithComment(...) 
#endif

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
