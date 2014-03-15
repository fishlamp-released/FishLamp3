//
//  printf_fl.h
//  FishLampFrameworks
//
//  Created by Mike Fullerton on 8/22/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton.. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampRequired.h"
#import "FLWhitespaceStringFormatter.h"
#import "FishLampPropertyDeclaring.h"

@interface FLPrintfStringFormatter : FLWhitespaceStringFormatter<FLWhitespaceStringFormatterDelegate> {
@private
    NSMutableString* _history;
    NSInteger _length;
    BOOL _rememberHistory;
}

@property (readwrite, assign, nonatomic) BOOL rememberHistory;

FLSingletonProperty(FLPrintfStringFormatter);

@end

#define printf_fl(FORMAT, ...) [[FLPrintfStringFormatter instance] appendLineWithFormat:FORMAT, ##__VA_ARGS__]

//#define printf_fl [FLPrintfStringFormatter instance]
