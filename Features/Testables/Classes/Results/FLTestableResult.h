//
//  FLTestableResult.h
//  FishLamp
//
//  Created by Mike Fullerton on 10/18/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLTestResultCollection.h"
@protocol FLTestable;

@interface FLTestableResult : FLTestResultCollection {
@private
    id<FLTestable> _unitTest;
}

@property (readonly, strong) id<FLTestable> testable;

@end