//
//  FLCommandLineTask.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 4/18/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLOperation.h"

@interface FLCommandLineTask : FLOperation {
@private
    NSMutableArray* _operations;
}

@property (readonly, strong, nonatomic) NSArray* operations;

+ (id) commandLineTask;

- (void) queueOperation:(FLOperation*) operation;

@end
