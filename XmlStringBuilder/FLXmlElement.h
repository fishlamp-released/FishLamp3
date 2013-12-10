//
//  FLXmlElement.h
//  FishLamp
//
//  Created by Mike Fullerton on 9/6/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLStringBuilderSection.h"

@class FLStringToObjectConversionManager;
@class FLXmlComment;

// This is for WRITING Xml Elements only with the FLXmlStringBuilder.
@interface FLXmlElement : FLStringBuilderSection {
@private
	NSMutableDictionary* _attributes;
    NSString* _openTag;
    NSString* _closeTag;
    FLStringToObjectConversionManager* _dataEncoder;
    FLXmlComment* _comments;
}

@property (readwrite, strong, nonatomic) FLStringToObjectConversionManager* dataEncoder;
@property (readonly, strong, nonatomic) FLXmlComment* comments;

@property (readonly, strong, nonatomic) NSString* xmlElementTag;
@property (readonly, strong, nonatomic) NSString* xmlElementCloseTag;

@property (readonly, strong, nonatomic) NSString* fullPath;

- (id) initWithXmlElementTag:(NSString*) tag 
          xmlElementCloseTag:(NSString*) xmlElementCloseTag;
          
- (id) initWithXmlElementTag:(NSString*) tag;

+ (id) xmlElement:(NSString*) xmlElementTag 
xmlElementCloseTag:(NSString*) xmlElementCloseTag;

+ (id) xmlElement:(NSString*) name;

- (void) setAttribute:(NSString*) attributeValue forKey:(NSString*) key;
- (void) appendAttribute:(NSString*) attributeValue forKey:(NSString*) key;


@end


