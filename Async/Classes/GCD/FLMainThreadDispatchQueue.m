//
//  FLMainThreadDispatchQueue.m
//  FishLamp
//
//  Created by Mike Fullerton on 1/4/14.
//  Copyright (c) 2014 Mike Fullerton. All rights reserved.
//

#import "FLMainThreadDispatchQueue.h"

@implementation FLMainThreadDispatchQueue

- (id) init {	
	return [super initWithDispatchQueue:dispatch_get_main_queue()];
}

FLSynthesizeSingleton(FLMainThreadDispatchQueue);

@end
