//
//  NSError+_FLNetworking_.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 3/20/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampCore.h"

@interface NSError (FLNetworking)
@property (readonly, nonatomic) BOOL didLoseNetwork;
@property (readonly, nonatomic) BOOL isNotConnectedToInternetError;
@end
