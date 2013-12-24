//  FLConfirmations.h
//  FishLampFrameworks
//
//  Created by Mike Fullerton on 8/28/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton.. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//
// this is meant to be included by FishLampAssertions.h

#import "FL_ASSERT.h"

#define FL_CONFIRM_THROWER(__CODE__, __REASON__, __COMMENT__) \
            FLThrowError([NSError assertionFailedError:__CODE__ reason:__REASON__ comment:__COMMENT__ stackTrace:FLCreateStackTrace(YES)])

#define FLConfirmationFailed() \
            FL_ASSERT_FAILED(FL_CONFIRM_THROWER)

#define FLConfirmationFailedWithComment(__FORMAT__, ...) \
            FL_ASSERT_FAILED__WITH_COMMENT(FL_CONFIRM_THROWER, __FORMAT__, ##__VA_ARGS__)

#define FLConfirm(__CONDITION__) \
            FL_ASSERT(FL_CONFIRM_THROWER, __CONDITION__)

#define FLConfirmWithComment(__CONDITION__, __FORMAT__, ...) \
            FL_ASSERT_WITH_COMMENT(FL_CONFIRM_THROWER, __CONDITION__, __FORMAT__, ##__VA_ARGS__)

#define FLConfirmIsNil(__PTR__) \
            FL_ASSERT_IS_NIL(FL_CONFIRM_THROWER, __PTR__)

#define FLConfirmIsNilWithComment(__PTR__, __FORMAT__, ...) \
            FL_ASSERT_IS_NIL_WITH_COMMENT(FL_CONFIRM_THROWER, __PTR__, __FORMAT__, ##__VA_ARGS__)

#define FLConfirmIsNotNil(__PTR__) \
            FL_ASSERT_IS_NOT_NIL(FL_CONFIRM_THROWER, __PTR__)

#define FLConfirmIsNotNilWithComment(__PTR__, __FORMAT__, ...) \
            FL_ASSERT_IS_NOT_NIL_WITH_COMMENT(FL_CONFIRM_THROWER, __PTR__, __FORMAT__, ##__VA_ARGS__)

#define FLConfirmStringIsNotEmpty(__STRING__) \
            FL_ASSERT_STRING_IS_NOT_EMPTY(FL_CONFIRM_THROWER, __STRING__)

#define FLConfirmStringIsNotEmptyWithComment(__STRING__, __FORMAT__, ...) \
            FL_ASSERT_STRING_IS_NOT_EMPTY_WITH_COMMENT(FL_CONFIRM_THROWER, __STRING__, __FORMAT__, ##__VA_ARGS__)

#define FLConfirmStringIsEmpty(__STRING__) \
            FL_ASSERT_STRING_IS_EMPTY(FL_CONFIRM_THROWER, __STRING__)

#define FLConfirmStringIsEmptyWithComment(__STRING__, __FORMAT__, ...) \
            FL_ASSERT_STRING_IS_EMPTY_WITH_COMMENT(FL_CONFIRM_THROWER, __STRING__, __FORMAT__, ##__VA_ARGS__)

#define FLConfirmStringsAreEqual(a,b) \
            FLConfirm(FLStringsAreEqual(a,b));

#define FLConfirmStringsNotEqual(a,b) \
            FLConfirm(!FLStringsAreEqual(a,b));

#define FLConfirmIsKindOfClass(__OBJ__, __CLASS__) \
            FLConfirm([__OBJ__ isKindOfClass:[__CLASS__ class]])

#define FLConfirmConformsToProcol(__OBJ__, __PROTOCOL__) \
            FLConfirm([__OBJ__ conformsToProtocol:@protocol(__PROTOCOL__)])

#define FLConfirmNotNil \
            FLConfirmIsNotNil

#define FLConfirmNotNilWithComment \
            FLConfirmIsNotNilWithComment

#define FLConfirmNil \
            FLConfirmIsNil

#define FLConfirmNilWithComment \
            FLConfirmIsNilWithComment

#define FLConfirmNotError(__OBJ__) \
            FLConfirm(![__OBJ__ isKindOfClass:[NSError class]])

#define FLConfirmTrue(__CONDITION__) \
            FLConfirm((__CONDITION__) == YES)

#define FLConfirmFalse(__CONDITION__) \
            FLConfirm(!(__CONDITION__))

