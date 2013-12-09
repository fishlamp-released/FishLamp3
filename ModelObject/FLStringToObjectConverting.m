//
//  FLDataTypeID.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 2/8/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLStringToObjectConverting.h"
#import "ISO8601DateFormatter.h"
#import "FLBase64Data.h"

@implementation NSObject (FLEncodingSelectors)
+ (NSString*) typeNameForStringSerialization {
    return NSStringFromClass([self class]);
}
@end

@implementation FLStringToObjectConverter

+ (id) stringToObjectConverter {
    return FLAutorelease([[[self class] alloc] init]);
}

- (NSString*) stringFromObject:(id) object {
    FLAssert([object isKindOfClass:[NSString class]]);
    return object;
}

- (id) objectFromString:(NSString*) string {
    return string;
}

+ (NSArray*) typeNames {
    return [NSArray arrayWithObject:[NSString typeNameForStringSerialization]];
}

@end

@implementation FLISO8601StringToNSDateObjectConverter

- (id) init {	
	self = [super init];
	if(self) {
        _formatter = [[ISO8601DateFormatter alloc] init];
        _formatter.parsesStrictly = NO;
	}
	return self;
}

#if FL_MRC
- (void)dealloc {
	[_formatter release];
	[super dealloc];
}
#endif

- (NSString*) stringFromObject:(id) object {
    return [_formatter stringFromDate:object];
}

- (id) objectFromString:(NSString*) string {
    return [_formatter dateFromString:string];
}

+ (NSArray*) typeNames {
    return [NSArray arrayWithObject:[NSDate typeNameForStringSerialization]];
}

@end

@implementation FLBase64StringToNSDataObjectConverter

- (id) initWithStringConverter:(id<FLStringToObjectConverting>) stringToObjectConverter {
	self = [super init];
	if(self) {
		_stringEncoder = FLRetain(stringToObjectConverter);
	}
	return self;
}

+ (id) stringToObjectConverterWithStringConverter:(id<FLStringToObjectConverting>) stringToObjectConverter {
    return FLAutorelease([[[self class] alloc] initWithStringConverter:stringToObjectConverter]);
}

#if FL_MRC
- (void)dealloc {
	[_stringEncoder release];
	[super dealloc];
}
#endif

- (NSString*) stringFromObject:(id) object {
    return [_stringEncoder stringFromObject:[object encodedData]];
}

- (id) objectFromString:(NSString*) string {
    return [FLBase64Data base64DataWithEncodedData:[_stringEncoder objectFromString:string]]; // [self dateFromString:string];
}

+ (NSArray*) typeNames {
    return [NSArray arrayWithObject:[FLBase64Data typeNameForStringSerialization]];
}


@end

@implementation FLURLStringToNSURLObjectConverter

- (NSString*) stringFromObject:(id) object {
    return [object absoluteString];
}

- (id) objectFromString:(NSString*) string {
    return [NSURL URLWithString:string];
}

+ (NSArray*) typeNames {
    return [NSArray arrayWithObject:[NSURL typeNameForStringSerialization]];
}

@end

@interface FLNumberStringToNSNumberObjectConverter ()
@property (readonly, strong, nonatomic) NSNumberFormatter* numberFormatter;
@end

@implementation FLNumberStringToNSNumberObjectConverter

@synthesize numberFormatter = _formatter;

- (id) init {	
	self = [super init];
	if(self) {
        _formatter = [[NSNumberFormatter alloc] init];
        [_formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        [_formatter setGeneratesDecimalNumbers:NO];
        [_formatter setUsesGroupingSeparator:NO];
	}
	return self;
}

#if FL_MRC
- (void)dealloc {
	[_formatter release];
	[super dealloc];
}
#endif


#if DEBUG
- (void) testRoundTripToNumber:(NSString*) string number:(NSNumber*) number {

    if([string rangeOfString:@"."].length == 0) {
        NSString* test = [_formatter stringFromNumber:number];
        FLAssertWithComment(FLStringsAreEqual(test, string), @"round trip failed for number formatter: %@ should be %@", test, string);
    }
}

- (void) testRoundTripToString:(NSString*) string number:(NSNumber*) number {
    NSNumber* test = [_formatter numberFromString:string];

    FLAssertWithComment([test isEqual:number], @"round trip failed for number formatter: %@ should be %@", test, number);
}

#endif


- (NSString*) stringFromObject:(id) object {
    NSString* string = [_formatter stringFromNumber:object];
    
#if DEBUG
    [self testRoundTripToString:string number:object];
#endif

    return string;
}

- (id) objectFromString:(NSString*) string {
    NSNumber* number = [_formatter numberFromString:string];
    
#if DEBUG
    [self testRoundTripToNumber:string number:number];
#endif

    return number;
}

+ (NSArray*) typeNames {
    return [NSArray arrayWithObjects:   @"SInt16", @"UInt16",
                                        @"SInt32", @"UInt32",
                                        @"SInt64", @"UInt64",
                                        @"char",
                                        @"unsigned char",
                                        @"int",
                                        @"integer",
                                        @"unsigned",
                                        @"unsigned long",
                                        @"long",
                                        @"double",
                                        @"float",
                                        @"short",
                                        @"unsigned short",
                                        @"NSInteger",
                                        @"NSUInteger",
                                        [NSNumber typeNameForStringSerialization],
                                        nil];
}



@end

@implementation FLCustomNumberStringToNSNumberObjectConverter

- (id) objectFromString:(NSString*) string {
    NSNumber* number = nil;
    
    if(string.length > 9) {

        NSScanner *theScanner = [NSScanner scannerWithString:string];

        if([string rangeOfString:@"."].length > 0) {
            double doubleValue = 0.0;
            [theScanner scanDouble:&doubleValue];
            number = [NSNumber numberWithDouble:doubleValue];
        }
        else {
            long long longLong = 0;
            [theScanner scanLongLong:&longLong];
            number = [NSNumber numberWithLongLong:longLong];
        }

#if DEBUG
        [self testRoundTripToNumber:string number:number];
#endif
    }
    else {
        number = [super objectFromString:string];
    }
    
    return number;
}

@end

@implementation FLUTF8StringToNSDataObjectConverter

- (NSString*) stringFromObject:(id) object {
    return FLAutorelease([[NSString alloc] initWithBytes:[object bytes] 
                                    length:[object length] 
                                    encoding:NSUTF8StringEncoding]);
}
- (id) objectFromString:(NSString*) string {
    return [string dataUsingEncoding:NSUTF8StringEncoding];;
}

+ (NSArray*) typeNames {
    return [NSArray arrayWithObject:[NSData typeNameForStringSerialization]];
}

@end

@implementation FLBoolStringToNSNumberObjectConverter

- (NSString*) stringFromObject:(id) object {
    return [object boolValue] ? @"true" : @"false";
}

- (id) objectFromString:(NSString*) string {
    return [NSNumber numberWithBool:[string boolValue]];
}

+ (NSArray*) typeNames {
    return [NSArray arrayWithObjects:   @"bool",
                                        @"boolean",
                                        [FLBoolStringToNSNumberObjectConverter typeNameForStringSerialization],
                                        nil];
}

@end

