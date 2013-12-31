//
//  NSObject+FLXmlObjectBuilder.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 5/7/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "NSObject+FLXmlObjectBuilder.h"
#import "FLParsedXmlElement.h"
#import "FLXmlObjectBuilder.h"
#import "FLObjectDescriber+FLXmlObjectBuilder.h"
#import "FLXmlParser.h"

@implementation NSObject (FLXmlObjectBuilder)       

+ (id) objectWithXmlFilePath:(NSString*) xmlFilePath {
    FLParsedXmlElement* xml = [[FLXmlParser xmlParser] parseFileAtPath:xmlFilePath];
    if(!xml) {
        return nil;
    }
    
    return [[FLXmlObjectBuilder xmlObjectBuilder] buildObjectOfClass:[self class] withXML:xml];
}

+ (id) objectWithXmlFile:(NSString*) xmlFileName inBundle:(NSBundle*) bundle {
    
    if(!bundle) {
        bundle = [NSBundle mainBundle];
    }
    
    NSString* pathToFile = [bundle pathForResource:[xmlFileName stringByDeletingPathExtension] ofType:[xmlFileName pathExtension]];
    
    FLConfirmNotNilWithComment(pathToFile, @"%@ not found in bundle", xmlFileName);
    
    return [self objectWithXmlFilePath:pathToFile];
}


@end
