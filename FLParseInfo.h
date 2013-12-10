//
//  FLParseInfo.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 5/23/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampMinimum.h"

@interface FLParseInfo : NSObject {
@private
    NSUInteger _line;
    NSUInteger _column;
    NSString* _fileName;
    NSString* _hint;
}

@property (readonly, assign, nonatomic) NSUInteger line;
@property (readonly, assign, nonatomic) NSUInteger column;
@property (readonly, strong, nonatomic) NSString* fileName; 
@property (readonly, strong, nonatomic) NSString* hint;

- (id) initWithHint:(NSString*) hint
    file:(NSString*) file
    line:(NSUInteger) line 
    column:(NSUInteger) column;

+ (FLParseInfo*) parseInfo:(NSString*) hint 
                      file:(NSString*) fileName 
                      line:(NSUInteger) line 
                    column:(NSUInteger) column;

@end

@interface NSObject (FLParseInfo)
@property (readwrite, strong, nonatomic) FLParseInfo* parseInfo;
@end
