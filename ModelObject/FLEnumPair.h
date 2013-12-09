//
//  FLEnumPair.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 5/30/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampMinimum.h"

@interface FLEnumPair : NSObject {
@private
    NSString* _enumName;
    NSInteger _enumValue;
}
@property (readonly, strong, nonatomic) NSString* enumName;
@property (readonly, assign, nonatomic) NSInteger enumValue;

+ (id) enumPair:(NSString*) name enumValue:(NSInteger) enumValue;

@end