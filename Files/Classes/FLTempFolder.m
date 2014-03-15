//
//  FLTempFolder.m
//  Fishlamp
//
//  Created by Mike Fullerton on 6/19/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLTempFolder.h"
#import "NSString+GUID.h"

@implementation FLTempFolder

- (id) init {
    NSString* tempFolder = NSTemporaryDirectory();
    self = [super initWithFolderPath:[tempFolder stringByAppendingPathComponent:[NSString guidString]]];
    if(self) {
    }
    return self;
}

+ (FLTempFolder*) tempFolder {
    return FLAutorelease([[[self class] alloc] init]);
}


@end
