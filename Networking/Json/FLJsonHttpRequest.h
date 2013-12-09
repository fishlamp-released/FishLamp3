//
//  FLJsonNetworkOperationBehavior.h
//  FishLamp
//
//  Created by Mike Fullerton on 5/13/11.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton.
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampMinimum.h"
#import "FLHttpRequest.h"
#import "FLJsonStringBuilder.h"

@interface FLJsonHttpRequest : FLHttpRequest {
@private
	FLJsonStringBuilder* _json;
    id _outputObject;
}

@property (readwrite, strong) id outputObject;
@property (readwrite, strong) FLJsonStringBuilder* json;

@end
