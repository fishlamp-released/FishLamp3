//
//  FLBase64Data.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 7/4/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FLBase64Data : NSObject {
@private
    NSData* _decodedData;
    NSData* _encodedData;
}

@property (readonly, strong, nonatomic) NSData* decodedData;
@property (readonly, strong, nonatomic) NSData* encodedData;

- (id) initWithEncodedData:(NSData*) data;
- (id) initWithDecodedData:(NSData*) data;

+ (id) base64DataWithEncodedData:(NSData*) data;
+ (id) base64DataWithDecodedData:(NSData*) data;

@end

