//
//  FLStructFlagsProperty.h
//  FishLampFrameworks
//
//  Created by Mike Fullerton on 9/2/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton.. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampObjc.h"

#define FLSynthesizeStructGetterProperty(GET_NAME, __TYPE__, STRUCT) \
	- (__TYPE__) GET_NAME { return (__TYPE__) STRUCT.GET_NAME; } 

#define FLSynthesizeStructProperty(GET_NAME, SET_NAME, __TYPE__, STRUCT) \
	- (__TYPE__) GET_NAME { return (__TYPE__) STRUCT.GET_NAME; } \
	- (void) SET_NAME:(__TYPE__) inValue { STRUCT.GET_NAME = (__TYPE__) inValue; }

