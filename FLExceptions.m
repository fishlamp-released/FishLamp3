//
//  FLExceptions.m
//  FishLampFrameworks
//
//  Created by Mike Fullerton on 8/30/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton.. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLErrorException.h"
#import "FLExceptions.h"

NSException* FLDefaultWillThrowExceptionHandler(NSException *exception) {
    return exception;
}

static FLWillThrowExceptionHandler* s_will_throw_exception_handler = nil;

void FLSetWillThrowExceptionHandler(FLWillThrowExceptionHandler handler) {
    s_will_throw_exception_handler = handler;
}

FLWillThrowExceptionHandler* FLGetWillThrowExceptionHandler() {
    return s_will_throw_exception_handler == nil ? FLDefaultWillThrowExceptionHandler : s_will_throw_exception_handler;
}


