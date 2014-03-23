//  FLConfirmations.h
//  FishLampFrameworks
//
//  Created by Mike Fullerton on 8/28/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton.. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampRequired.h"
#import "NSString+FishLamp.h"
#import "NSError+FLStackTrace.h"
//#import "FLAssertionFailedError.h"

//#define FL_CONFIRM_THROWER(CODE, REASON, COMMENT) \
//            FLThrowError([NSError assertionFailedError:CODE reason:REASON comment:COMMENT stackTrace:FLCreateStackTrace(YES)])
//
//#define FLConfirmationFailed(COMMENT...) \
//            FL_ASSERT_FAILED(FL_CONFIRM_THROWER)
//
//#define FLConfirmationFailed(FORMAT, ...) \
//            FL_ASSERT_FAILEDWITH_COMMENT(FL_CONFIRM_THROWER, FORMAT, ##VA_ARGS)
//
//#define FLConfirm(CONDITION) \
//            FL_ASSERT(FL_CONFIRM_THROWER, CONDITION)
//
//#define FLConfirm(CONDITION, FORMAT, ...) \
//            FL_ASSERT_WITH_COMMENT(FL_CONFIRM_THROWER, CONDITION, FORMAT, ##VA_ARGS)
//
//#define FLConfirmIsNil(PTR) \
//            FL_ASSERT_IS_NIL(FL_CONFIRM_THROWER, PTR)
//
//#define FLConfirmIsNil(PTR, FORMAT, ...) \
//            FL_ASSERT_IS_NIL_WITH_COMMENT(FL_CONFIRM_THROWER, PTR, FORMAT, ##VA_ARGS)
//
//#define FLConfirmIsNotNil(PTR) \
//            FL_ASSERT_IS_NOT_NIL(FL_CONFIRM_THROWER, PTR)
//
//#define FLConfirmIsNotNil(PTR, FORMAT, ...) \
//            FL_ASSERT_IS_NOT_NIL_WITH_COMMENT(FL_CONFIRM_THROWER, PTR, FORMAT, ##VA_ARGS)
//
//#define FLConfirmStringIsNotEmpty(STRING) \
//            FL_ASSERT_STRING_IS_NOT_EMPTY(FL_CONFIRM_THROWER, STRING)
//
//#define FLConfirmStringIsNotEmpty(STRING, FORMAT, ...) \
//            FL_ASSERT_STRING_IS_NOT_EMPTY_WITH_COMMENT(FL_CONFIRM_THROWER, STRING, FORMAT, ##VA_ARGS)
//
//#define FLConfirmStringIsEmpty(STRING) \
//            FL_ASSERT_STRING_IS_EMPTY(FL_CONFIRM_THROWER, STRING)
//
//#define FLConfirmStringIsEmpty(STRING, FORMAT, ...) \
//            FL_ASSERT_STRING_IS_EMPTY_WITH_COMMENT(FL_CONFIRM_THROWER, STRING, FORMAT, ##VA_ARGS)
//



#define FLHandleConfirmationFailure(CODE, NAME, DESCRIPTION) 

//\
//            do { \
//                NSException* __EX = [[FLConfirmationHandler sharedHandler] assertionFailed:FLConfirmationFailureErrorDomain \
//                                                                                   code:CODE \
//                                                             stackTrace:FLStackTraceMake(FLCurrentFileLocation(), YES) \
//                                                                   name:NAME \
//                                                            description:DESCRIPTION]; \
//                if(__EX) { \
//                    FLThrowException(__EX);  \
//                } \
//            } \
//            while (0)


#define FLConfirmFailed(DESCRIPTION...) \
            FLHandleConfirmationFailure(FLConfirmationFailureCondition, \
                @"Confirmation Failed", \
                ([NSString stringWithFormat:@"" DESCRIPTION]))

#define FLConfirmationFailed FLConfirmFailed

#define FLConfirm(CONDITION, DESCRIPTION...) \
            do { \
                if(!(CONDITION)) { \
                    FLHandleConfirmationFailure(FLConfirmationFailureCondition, \
                        ([NSString stringWithFormat:@"Confirming \"%s\" Failed", #CONDITION]), \
                        ([NSString stringWithFormat:@"" DESCRIPTION])); \
                } \
            } \
            while(0)

#define FLConfirmIsNil(REFERENCE, DESCRIPTION...)  \
            do { \
                if((REFERENCE) == nil) { \
                    FLHandleConfirmationFailure(FLConfirmationFailureCondition, \
                        ([NSString stringWithFormat:@"Confirming '%s == nil' Failed", #REFERENCE]), \
                        ([NSString stringWithFormat:@"" DESCRIPTION])); \
                } \
            } \
            while(0)

#define FLConfirmIsNotNil(REFERENCE, DESCRIPTION...) \
            do { \
                if((REFERENCE) != nil) { \
                    FLHandleConfirmationFailure(FLConfirmationFailureCondition, \
                        ([NSString stringWithFormat:@"Confirming '%s != nil' Failed", #REFERENCE]), \
                        ([NSString stringWithFormat:@"" DESCRIPTION])); \
                } \
            } \
            while(0)



#define FLConfirmStringIsNotEmpty(STRING, DESCRIPTION...) \
            do { \
                if(FLStringIsEmpty(STRING) == YES) { \
                    FLHandleConfirmationFailure(FLConfirmationFailureCondition, \
                        ([NSString stringWithFormat:@"Confirming String is not empty for '%s' Failed", #STRING]), \
                        ([NSString stringWithFormat:@"" DESCRIPTION])); \
                } \
            } \
            while(0)


#define FLConfirmStringIsEmpty(STRING, DESCRIPTION...) \
            do { \
                if(FLStringIsEmpty(STRING) == NO) { \
                    FLHandleConfirmationFailure(FLConfirmationFailureCondition, \
                        ([NSString stringWithFormat:@"Confirming String is empty for '%s' Failed", #STRING]), \
                        ([NSString stringWithFormat:@"" DESCRIPTION])); \
                } \
            } \
            while(0)


#define FLConfirmStringsAreEqual(a,b, DESCRIPTION...) \
            FLConfirm(FLStringsAreEqual(a,b), @"" DESCRIPTION);

#define FLConfirmStringsNotEqual(a,b, DESCRIPTION...) \
            FLConfirm(!FLStringsAreEqual(a,b), @"" DESCRIPTION);

#define FLConfirmIsKindOfClass(__OBJ__, __CLASS__, DESCRIPTION...) \
            FLConfirm([__OBJ__ isKindOfClass:[__CLASS__ class]], @"" DESCRIPTION)

#define FLConfirmConformsToProcol(__OBJ__, __PROTOCOL__, DESCRIPTION...) \
            FLConfirm([__OBJ__ conformsToProtocol:@protocol(__PROTOCOL__)], @"" DESCRIPTION)

#define FLConfirmNotNil \
            FLConfirmIsNotNil

#define FLConfirmNil \
            FLConfirmIsNil

#define FLConfirmNotError(OBJ) \
            FLConfirm(![OBJ isKindOfClass:[NSError class]])

#define FLConfirmTrue(CONDITION) \
            FLConfirm((CONDITION) == YES)

#define FLConfirmFalse(CONDITION) \
            FLConfirm(!(CONDITION))


