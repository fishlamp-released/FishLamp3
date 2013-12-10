//
//  FLJson.h
//  FishLamp
//
//  Created by Mike Fullerton on 5/12/11.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton.
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampMinimum.h"

@interface FLJsonParser : NSObject {
@private
}
+ (FLJsonParser*) jsonParser;

- (id) parseData:(NSData*) data;
- (id) parseFileAtPath:(NSString*) path;
- (id) parseFileAtURL:(NSURL*) url;

+ (BOOL) canParseData:(NSData*) data;
@end
