//
//  FishLampDataTypeID.h
//  FishLamp
//
//  Created by Mike Fullerton on 6/23/12
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampMinimum.h"

@class FLBase64Data;
@class ISO8601DateFormatter;

@protocol FLStringToObjectConverting <NSObject>
- (NSString*) stringFromObject:(id) object;
- (id) objectFromString:(NSString*) string;
+ (NSArray*) typeNames;
@end

@interface NSObject (FLEncodingSelectors)
+ (NSString*) typeNameForStringSerialization;
@end

@interface FLStringToObjectConverter : NSObject<FLStringToObjectConverting>
+ (id) stringToObjectConverter;
@end

@interface FLISO8601StringToNSDateObjectConverter : FLStringToObjectConverter {
@private
    ISO8601DateFormatter* _formatter;
}
@end

@interface FLURLStringToNSURLObjectConverter : FLStringToObjectConverter
@end

@interface FLNumberStringToNSNumberObjectConverter : FLStringToObjectConverter {
@private
    NSNumberFormatter* _formatter;
}
@end

@interface FLCustomNumberStringToNSNumberObjectConverter : FLNumberStringToNSNumberObjectConverter
@end

@interface FLUTF8StringToNSDataObjectConverter : FLStringToObjectConverter
@end

@interface FLBoolStringToNSNumberObjectConverter : FLStringToObjectConverter
@end

@interface FLBase64StringToNSDataObjectConverter : FLStringToObjectConverter {
@private
    id<FLStringToObjectConverting> _stringEncoder;
}
+ (id) stringToObjectConverterWithStringConverter:(id<FLStringToObjectConverting>) stringToObjectConverter;
@end
