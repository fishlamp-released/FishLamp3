//
//  FLConsoleLogSink.h
//  FLCore
//
//  Created by Mike Fullerton on 11/1/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton.. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampRequired.h"
#import "FLLogSink.h"

@interface FLConsoleLogSink : FLLogSink<FLLogSink> {
@private
}
+ (id) consoleLogSink;
+ (FLLogSink*) consoleLogSink:(FLLogSinkBehavior*) outputFlags;

@end

