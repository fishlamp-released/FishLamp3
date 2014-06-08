//
//  FishLampExceptions.h
//  FishLampFrameworks
//
//  Created by Mike Fullerton on 8/30/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton.. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampRequired.h"

#import "NSException+FLError.h"
#import "NSError+FLException.h"
#import "NSError+FishLampCore.h"

#ifndef INCLUDE_STACK_TRACE
#define INCLUDE_STACK_TRACE YES
#endif

typedef NSException* FLWillThrowExceptionHandlerFunction(NSException *exception);

//extern void FLSetWillThrowExceptionHandler(FLWillThrowExceptionHandlerFunction* handler);
//
//extern FLWillThrowExceptionHandlerFunction* FLGetWillThrowExceptionHandler(void);

FLWillThrowExceptionHandlerFunction* FLGetWillThrowExceptionHandler(void);
void FLSetWillThrowExceptionHandler(FLWillThrowExceptionHandlerFunction* handler);

NSException* FLDefaultWillThrowExceptionHandler(NSException *exception);


#define FL_THROW_ERROR(ERROR, THROWER) \
            do {  \
                NSError* __error = ERROR; \
                if(!__error.stackTrace) { \
                    __error = [NSError errorWithError:__error stackTrace:FLCreateStackTrace(INCLUDE_STACK_TRACE)]; \
                } \
                \
                THROWER([NSException exceptionWithError:__error]); \
            } \
            while(0)

#define FLThrowException(EX) \
            @throw FLGetWillThrowExceptionHandler()(EX)

#define FLThrowError(ERROR) \
            do {  \
                NSError* __error = ERROR; \
                if(!__error.stackTrace) { \
                    __error = [NSError errorWithError:__error stackTrace:FLCreateStackTrace(INCLUDE_STACK_TRACE)]; \
                } \
                \
                @throw FLGetWillThrowExceptionHandler()([NSException exceptionWithError:__error]); \
            } \
            while(0)

#define FLThrowIfError(OBJECT) \
            do { \
                id __object = (id)(OBJECT);\
                if([__object isError_fl]) { \
                    FLThrowError(__object); \
                } \
            } while(0)

#define FLThrowErrorCode(DOMAIN, CODE, DESCRIPTION...) \
            FLThrowError([NSError errorWithDomain:DOMAIN \
                            code:CODE \
                            localizedDescription: ([NSString stringWithFormat:@"" DESCRIPTION]) \
                            userInfo:nil \
                            stackTrace:FLCreateStackTrace(INCLUDE_STACK_TRACE)])

