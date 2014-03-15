//
//  FLXmlStringEncoding.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 5/11/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLXmlStringEncoding.h"


@implementation FLXmlStringEncoder

+ (id) xmlStringEncoder {
    return FLAutorelease([[[self class] alloc] init]);
}

- (NSString*) stringFromObject:(id) object {
    return [object xmlEncode];
}

- (id) objectFromString:(NSString*) string {
    return [string xmlDecode];
}

@end


@implementation FLXmlURLStringEncoder
+ (id) xmlURLStringEncoder {
    return FLAutorelease([[[self class] alloc] init]);
}

- (NSString*) stringFromObject:(id) object  {
    return [[super stringFromObject:object] xmlEncode];
}

- (id) objectFromString:(NSString*) string {
    return [super objectFromString:[string xmlDecode]];
}

@end
