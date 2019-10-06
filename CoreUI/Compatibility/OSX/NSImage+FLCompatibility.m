//
//  SDKImage.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 12/13/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#if OSX
#import "NSImage+FLCompatibility.h"
#import "FLCompatibility.h"

@implementation NSImage (FLCompatibility)

- (id) initWithCGImage:(CGImageRef) image {
    NSSize size;
    size.height = CGImageGetHeight(image);
    size.width = CGImageGetWidth(image);
    return [self initWithCGImage:image size:size];
}

+ (SDKImage*) imageWithCGImage:(CGImageRef) image {
    return FLAutorelease([[[self class] alloc] initWithCGImage:image]);
}

- (CGImageRef) CGImage {
    return [self CGImageForProposedRect:nil context:nil hints:nil];
}

+ (id) imageWithData:(NSData*) data {
    return FLAutorelease([[[self class] alloc] initWithData:data]);
}

@end
#endif