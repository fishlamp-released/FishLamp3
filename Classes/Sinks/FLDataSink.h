//
//  FLDataSink.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 3/31/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLInputSink.h"

@interface FLDataSink : NSObject<FLInputSink>  {
@private
    NSMutableData* _responseData;
    NSData* _data;
}

+ (id) dataSink;
@end