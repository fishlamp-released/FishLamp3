//
//  FLObjectDatabaseTests.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 5/9/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLObjectDatabaseTests.h"
#import "FLObjectDatabase.h"
#import "FLModelObject.h"

@interface FLDatabaseTestObject : FLModelObject {
@private
    NSString* _string;
    int _int;
    unsigned int _unsignedInt;
    float _theFloat;
    double _theDouble;
    long _long;
    unsigned long _unsignedLong;
    long long _theLongLong;
    unsigned long long _theUnsignedLongLong;
    BOOL _bool;
    short _short;
    unsigned short _unsignedShort;
    NSDate* _date;
    NSInteger _NSInteger;
    NSUInteger _NSUInteger;
    FLDatabaseTestObject* _childObject;
    unsigned int _identifier;
}
@property (readwrite, strong, nonatomic) NSString* string;
@property (readwrite, strong, nonatomic) NSDate* date;
@property (readwrite, strong, nonatomic) FLDatabaseTestObject* childObject;

@property (readwrite, assign, nonatomic) unsigned int identifier;

@property (readwrite, assign, nonatomic) int theInt;
@property (readwrite, assign, nonatomic) unsigned int theUnsignedInt;
@property (readwrite, assign, nonatomic) short theShort;
@property (readwrite, assign, nonatomic) unsigned short theUnsignedShort;
@property (readwrite, assign, nonatomic) long theLong;
@property (readwrite, assign, nonatomic) unsigned long theUnsignedLong;
@property (readwrite, assign, nonatomic) BOOL theBool;
@property (readwrite, assign, nonatomic) NSInteger theNSInteger;
@property (readwrite, assign, nonatomic) NSUInteger theNSUInteger;
@property (readwrite, assign, nonatomic) float theFloat;
@property (readwrite, assign, nonatomic) double theDouble;
@property (readwrite, assign, nonatomic) long long theLongLong;
@property (readwrite, assign, nonatomic) unsigned long long theUnsignedLongLong;
@end

@implementation FLDatabaseTestObject

+ (id) testObject {
    return FLAutorelease([[[self class] alloc] init]);
}

@synthesize identifier = _identifier;
@synthesize string = _string;
@synthesize date = _date;
@synthesize theInt = _int;
@synthesize theUnsignedInt = _unsignedInt;
@synthesize theShort = _short;
@synthesize theUnsignedShort = _unsignedShort;
@synthesize theNSInteger = _NSInteger;
@synthesize theNSUInteger = _NSUInteger;
@synthesize theLong = _long;
@synthesize theUnsignedLong = _unsignedLong;
@synthesize theBool = _bool;
@synthesize theFloat = _theFloat;
@synthesize theDouble = _theDouble;
@synthesize theLongLong = _theLongLong;
@synthesize theUnsignedLongLong = _theUnsignedLongLong;
@synthesize childObject = _childObject;

- (void) setToDefaults {
    self.string = @"Hello world";
    self.date = [NSDate date];
    self.theInt = INT32_MAX;
    self.theUnsignedInt = UINT32_MAX;
    self.theShort = INT16_MAX;
    self.theUnsignedShort = UINT16_MAX;
    self.theNSInteger = NSIntegerMax;
    self.theNSUInteger = NSUIntegerMax;
    self.theLong = INT64_MAX;
    self.theUnsignedLong = UINT64_MAX;
    self.theBool = YES;
    self.theFloat = FLT_MAX;
    self.theDouble = DBL_MAX;
    self.theLongLong = UINT64_MAX;
    self.theUnsignedLongLong = UINT64_MAX;
    self.childObject = FLCopyWithAutorelease(self);
    self.childObject.childObject = FLCopyWithAutorelease(self);
}

#if FL_MRC
- (void) dealloc {
    [_childObject release];
	[_string release];
    [_date release];
    [super dealloc];
}
#endif

+ (SEL) databasePrimaryKeyColumn {
    return @selector(identifier);
}

- (void) testEquality:(FLDatabaseTestObject*) testObject {
    FLAssert(testObject.identifier == self.identifier);
    FLAssert(testObject.theInt == self.theInt);
    FLAssert(testObject.theUnsignedInt == self.theUnsignedInt);
    FLAssert(testObject.theShort == self.theShort);
    FLAssert(testObject.theUnsignedShort == self.theUnsignedShort);
    FLAssert(testObject.theNSInteger== self.theNSInteger);
    FLAssert(testObject.theNSUInteger == self.theNSUInteger);
    FLAssert(testObject.theLong == self.theLong);
    FLAssert(testObject.theUnsignedLong == self.theUnsignedLong);
    FLAssert(testObject.theBool == self.theBool);
    FLAssert(testObject.theFloat == self.theFloat);
    FLAssert(testObject.theDouble == self.theDouble);
    FLAssert(testObject.theLongLong == self.theLongLong);
    FLAssert(testObject.theUnsignedLongLong == self.theUnsignedLongLong);
    FLAssert(FLStringsAreEqual(testObject.string, self.string));
    FLAssert([testObject.date isEqual:self.date]);

    if(self.childObject) {
        [self.childObject testEquality:testObject.childObject];
    }

}

@end


@implementation FLObjectDatabaseTests


- (id) createDatabase:(NSString*) filePath {
    return FLAutorelease([[FLObjectDatabase alloc] initWithFilePath:filePath]);
}

- (void) testValueRoundTrip {
    FLDatabaseTestObject* testObject = [FLDatabaseTestObject testObject];
    testObject.identifier = 1;
    [testObject setToDefaults];
    
    [self.database writeObject:testObject];

    FLDatabaseTestObject* testObject2 = [FLDatabaseTestObject testObject];
    testObject2.identifier = 1;
    
    FLDatabaseTestObject* readObject = [self.database readObject:testObject2];
    FLAssertNotNil(readObject);
    
    [testObject testEquality:readObject];
}


@end
