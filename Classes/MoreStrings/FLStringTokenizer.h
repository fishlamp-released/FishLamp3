//
//  FLStringParser.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 1/9/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLStringFormatter.h"

@protocol FLStringTokenizer <NSObject>
- (NSRange) rangeOfNextTokenInString:(NSString*) unparsedString;
@end

@interface FLStringTokenizer : NSObject<FLStringTokenizer> {
@private
    NSCharacterSet* _delimeters;
}

@property (readwrite, strong, nonatomic) NSCharacterSet* delimeters;

+ (id) stringTokenizer;

// optional override
- (BOOL) isDelimeterChar:(unichar) aChar;

@end


