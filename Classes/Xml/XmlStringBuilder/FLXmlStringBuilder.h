//
//	FLXmlStringBuilder.h
//	FishLamp
//
//	Created by Mike Fullerton on 6/11/09.
//	Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLStringBuilder.h"
#import "FLXmlElement.h"

// xml
#define FLXmlVersion1_0                         @"1.0"
#define FLXmlEncodingUtf8                       @"utf-8"
#define FMXmlEncodingUtf16                      @"UTF-16"

@class FLStringToObjectConversionManager;

@interface FLXmlStringBuilder : FLStringBuilder {
@private
    FLStringToObjectConversionManager* _dataEncoder;
}

@property (readwrite, strong, nonatomic) FLStringToObjectConversionManager* dataEncoder;

+ (FLXmlStringBuilder*) xmlStringBuilder;

- (void) appendXmlVersionHeader:(NSString*) version
              andEncodingHeader:(NSString*) encoding
                     standalone:(BOOL) standalone;

- (void) appendDefaultXmlHeader; 

- (void) openXmlDocument;

@end

