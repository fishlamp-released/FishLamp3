//
//  FLTestResultLogEntry.h
//  FishLampCore
//
//  Created by Mike Fullerton on 11/10/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FishLampCore.h"

@class FLStackTrace;

@interface FLTestResultLogEntry : NSObject {
@private
    NSString* _line;
    FLStackTrace* _stackTrace;
}

@property (readonly, strong, nonatomic) NSString* line;
@property (readonly, strong, nonatomic) FLStackTrace* stackTrace;

- (id) initWithLine:(NSString*) line
         stackTrace:(FLStackTrace*) stackTrace;

+ (id) testResultLogEntry:(NSString*) line
               stackTrace:(FLStackTrace*) stackTrace;
@end
