//
//  FLXmlEncodingTests.m
//  FishLampCore
//
//  Created by Mike Fullerton on 10/27/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLXmlEncodingTests.h"
#import "FLXmlStringBuilder.h"

@implementation FLXmlEncodingTests

- (void) testBasicXml {
    NSString* xml = @"<tag>hello</tag>";

    FLXmlStringBuilder* builder = [FLXmlStringBuilder xmlStringBuilder];
    [builder openSection:[FLXmlElement xmlElement:@"tag"]];
    [builder appendString:@"hello"];
    [builder closeSection];

    FLConfirmStringsAreEqual([builder buildStringWithNoWhitespace], xml);
}


@end
