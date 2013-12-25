//
//  FL_ASSERT.h
//  FishLampCore
//
//  Created by Mike Fullerton on 9/4/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FishLampCore.h"
#import "FLAssertionFailedError.h"
#import "FLStackTrace.h"

/// @brief: This will throw an diction failure exception
#define FL_ASSERT_FAILED(__THROWER__) \
            __THROWER__( FLAssertionFailureCondition, @"Condition failed", @"Assertion failed")

/// @brief: This will throw an diction failure exception
#define FL_ASSERT_FAILED__WITH_COMMENT(__THROWER__, __COMMENT__, ...) \
            __THROWER__( FLAssertionFailureCondition, @"Condition failed", \
                            FLStringWithFormatOrNil(__COMMENT__, ##__VA_ARGS__))

#define FL_ASSERT(__THROWER__, __CONDITION__) \
            if(!(__CONDITION__)) \
                __THROWER__(    FLAssertionFailureCondition, \
                                FLStringWithFormatOrNil(@"\"%s\"", #__CONDITION__), \
                                @"Assertion Failure")

#define FL_ASSERT_WITH_COMMENT(__THROWER__, __CONDITION__, __FORMAT__, ...) \
            if(!(__CONDITION__)) \
                __THROWER__(    FLAssertionFailureCondition, \
                                FLStringWithFormatOrNil(@"\"%s\"", #__CONDITION__), \
                                FLStringWithFormatOrNil(__FORMAT__, ##__VA_ARGS__))

/// @brief: Assert a pointer is nil
#define FL_ASSERT_IS_NIL(__THROWER__, __CONDITION__) \
    if((__CONDITION__) != nil) \
        __THROWER__( FLAssertionFailureIsNotNil, \
                                            FLStringWithFormatOrNil(@"\"%s != nil\"", #__CONDITION__), \
                                            @"unexpected non nil ptr")

/// @brief: Assert a pointer is nil
#define FL_ASSERT_IS_NIL_WITH_COMMENT(__THROWER__, __CONDITION__, __COMMENT__, ...) \
    if((__CONDITION__) != nil) \
        __THROWER__( FLAssertionFailureIsNotNil, \
                                            FLStringWithFormatOrNil(@"\"%s != nil\"", #__CONDITION__), \
                                            FLStringWithFormatOrNil(__COMMENT__, ##__VA_ARGS__)) 

/// @brief: Assert a pointer is NOT nil
#define FL_ASSERT_IS_NOT_NIL(__THROWER__, __CONDITION__) \
    if((__CONDITION__) == nil) \
        __THROWER__( FLAssertionFailureIsNil, \
                                            FLStringWithFormatOrNil(@"\"%s == nil\"", #__CONDITION__), \
                                            @"unexpected nil ptr")


/// @brief: Assert a pointer is NOT nil
#define FL_ASSERT_IS_NOT_NIL_WITH_COMMENT(__THROWER__, __CONDITION__, __COMMENT__, ...) \
    if((__CONDITION__) == nil) \
        __THROWER__( FLAssertionFailureIsNil, \
                                            FLStringWithFormatOrNil(@"\"%s == nil\"", #__CONDITION__), \
                                            FLStringWithFormatOrNil(__COMMENT__, ##__VA_ARGS__)) 

/// @brief: Assert a string is empty (either nil or of length 0)
/// empty is either nil or of zero length
#define FL_ASSERT_STRING_IS_NOT_EMPTY(__THROWER__, __STRING__) \
    if(FLStringIsEmpty(__STRING__)) \
        __THROWER__(FLAssertionFailureIsEmpty, FLStringWithFormatOrNil(@"String unexpectedly empty: %s", #__STRING__), nil) 

/// @brief: Assert a string is empty (either nil or of length 0)
/// empty is either nil or of zero length
#define FL_ASSERT_STRING_IS_NOT_EMPTY_WITH_COMMENT(__THROWER__, __STRING__, __COMMENT__, ...) \
    if(FLStringIsEmpty(__STRING__)) \
        __THROWER__(FLAssertionFailureIsEmpty, FLStringWithFormatOrNil(@"String unexpectedly empty: %s", #__STRING__),  FLStringWithFormatOrNil(__COMMENT__, ##__VA_ARGS__)) 

/// @brief: Assert a string is NOT empty
/// empty is either nil or of zero length
#define FL_ASSERT_STRING_IS_EMPTY(__THROWER__, __STRING__) \
    if((FLStringIsNotEmpty(__STRING__)) \
        __THROWER__(FLAssertionFailureIsNotEmpty, FLStringWithFormatOrNil(@"String unexpectedly not empty: %s", #__STRING__), nil) 


/// @brief: Assert a string is NOT empty
/// empty is either nil or of zero length
#define FL_ASSERT_STRING_IS_EMPTY_WITH_COMMENT(__THROWER__, __STRING__, __COMMENT__, ...) \
    if((FLStringIsNotEmpty(__STRING__)) \
        __THROWER__(FLAssertionFailureIsNotEmpty, FLStringWithFormatOrNil(@"String unexpectedly not empty: %s", #__STRING__),  FLStringWithFormatOrNil(__COMMENT__, ##__VA_ARGS__)) 

