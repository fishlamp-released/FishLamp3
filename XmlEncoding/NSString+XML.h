//
//  NSString+XML.h
//  FishLamp
//
//  Created by Mike Fullerton on 5/11/11.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton.
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampMinimum.h"


@interface NSString (XML)
- (NSString*) xmlEncode;
- (NSString*) xmlDecode;
@end
