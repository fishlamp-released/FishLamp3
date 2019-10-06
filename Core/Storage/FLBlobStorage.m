//
//  FLStorage.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 4/21/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLBlobStorage.h"

@implementation FLBlobIdentifier 
@synthesize relativePathIdentifier = _relativePath;
@synthesize uniqueIdentifier = _uniqueIdentifier;


#if FL_MRC
- (void) dealloc {
	[_uniqueIdentifier release];
    [_relativePath release];
    [super dealloc];
}
#endif


@end
