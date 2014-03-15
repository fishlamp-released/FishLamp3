//
//  FLBitFlags.m
//  FishLampFrameworks
//
//  Created by Mike Fullerton on 9/2/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton.. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLBitFlags.h"

NSString* FLBitFlagsDescription(FLBitFlags_t flags) {
    
    int len = sizeof(flags);
    len += ((len / 8) - 1); // for delimiter periods
    unichar chars[len];
    int mask = 1;
    for(int i = 0; i < len; i++) {
        if(i > 0 && ((i % 8) == 0.0f)) {
            chars[i] = '.';
        }
        else {
            chars[i] = FLTestBits(flags, mask) ? '1' : '0';
            mask = (mask << 1);
        }
    }
    return [NSString stringWithCharacters:chars length:len];
}

//@implementation FLBitFlags
//
//@synthesize bitFlags = _bitFlags;
//
//- (id) initWithFlags:(FLBitFlags_t) flags {
//    self = [super init];
//    if(self) {
//        _bitFlags = flags;
//    }
//    
//    return self;
//}
//
//+ (FLBitFlags*) bitFlags:(FLBitFlags_t) flags {
//    return FLAutorelease([[FLBitFlags alloc] initWithFlags:flags]);
//}
//
//- (FLBitMask_t) testMask:(FLBitMask_t) mask {
//    return FLGetBits(_bitFlags, mask);
//}
//
//- (void) clearMask:(FLBitMask_t) mask {
//    FLClearBits(_bitFlags, mask);
//}
//
//- (void) setMask:(FLBitMask_t) mask {
//    FLSetBits(_bitFlags, mask);
//}
//
//- (void) setMask:(FLBitMask_t) mask to:(BOOL) setOrClear {
//    FLSetOrClearBits(_bitFlags, mask, value);
//}
//
//- (BOOL) testBit:(uint32_t) bitNumber {
//    return [self test:FLMaskFromBit(bitNumber)];
//}
//
//- (void) clearBit:(uint32_t) bitNumber {
//    FLClearBits(_bitFlags, FLMaskFromBit(bitNumber));
//}
//
//- (void) setBit:(uint32_t) bitNumber {
//    FLSetBits(_bitFlags, FLMaskFromBit(bitNumber));
//}
//
//- (void) setBit:(uint32_t) bitNumber to:(BOOL) setOrClear {
//    FLSetOrClearBits(FLMaskFromBit(bitNumber), setOrClear);
//}
//
//- (void)encodeWithCoder:(NSCoder *)aCoder {
//    [aCoder encodeInt32:_bitFlags forKey:@"flags"];
//}
//
//- (id)initWithCoder:(NSCoder *)aDecoder {
//    self = [super init];
//    if(self) {
//        _flags = [aDecoder decodeInt32ForKey:@"flags"];
//    }
//    return self;
//}
//
//- (id)copyWithZone:(NSZone *)zone {
//    return [FLBitFlags bitFlags:_bitFlags];
//}
//
//#define BIT_CHAR(__BIT__) (_bitFlags & (1 << (__BIT__))) ? '1' : '0'
//
//- (NSString*) debugString {
//    
//    int len = sizeof(_bitFlags);
//    len += ((len / 8) - 1); // for delimiter periods
//    unichar chars[len];
//    for(int i = 0; i < len; i++) {
//        if(i > 0 && ((i % 8) == 0.0f)) {
//            chars[i] = '.';
//        }
//        else {
//            chars[i] = BIT_CHAR(i);
//        }
//    }
//    return [NSString stringWithCharacters:chars length:len];
//}
//
//- (NSString*) description {
//    return [self toString];
//}
//
////+ (void)initialize
////{
////    if (!instance) {
////        instance = [[super allocWithZone:NULL] init];
////    }
////}
////
////+ (id)allocWithZone:(NSZone * const)notUsed
////{
////    return instance;
////}
//
//- (BOOL)isEqual:(id)object {
//    return [object bitFlags] == _bigFlags;
//}
//
//- (NSUInteger)hash {
//    return _bitFlags;
//}
//
//@end
