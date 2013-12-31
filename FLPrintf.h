//
//  FLPrintf.h
//  FishLampFrameworks
//
//  Created by Mike Fullerton on 8/22/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton.. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampRequired.h"
#import "FLWhitespaceStringFormatter.h"

@interface FLPrintfStringFormatter : FLWhitespaceStringFormatter<FLWhitespaceStringFormatterDelegate> {
@private
    NSMutableString* _history;
    NSInteger _length;
    BOOL _rememberHistory;
}

@property (readwrite, assign, nonatomic) BOOL rememberHistory;

FLSingletonProperty(FLPrintfStringFormatter);

@end

#define FLPrintf(__FORMAT__, ...) [[FLPrintfStringFormatter instance] appendLineWithFormat:__FORMAT__, ##__VA_ARGS__]

//#define FLPrintf [FLPrintfStringFormatter instance]
