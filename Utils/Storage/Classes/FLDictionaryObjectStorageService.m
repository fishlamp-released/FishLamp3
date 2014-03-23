//
//  FLDictionaryObjectStorageService.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 3/19/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLDictionaryObjectStorageService.h"

@interface FLDictionaryObjectStorageService ()
@property (readwrite, strong) NSMutableDictionary* objectStorage;
@end

@implementation FLDictionaryObjectStorageService
@synthesize objectStorage = _objectStorage;

- (id) init {	
	self = [super init];
	if(self) {
	}
	return self;
}

#if FL_MRC
- (void) dealloc {
	[_objectStorage release];
	[super dealloc];
}
#endif

+ (id) dictionaryObjectStorageService {
    return FLAutorelease([[[self class] alloc] init]);
}

- (void) writeObject:(id) object {
    FLAssert(self.isServiceOpen);
    FLAssertNotNil(self.objectStorage);
    
    id key = [object objectStorageKey_fl];
    
    id previous = FLRetainWithAutorelease([self.objectStorage objectForKey:key]);
    if(previous != object) {
        [self.objectStorage setObject:object forKey:key];
    }
}

- (id) readObject:(id) inputObject {
    FLAssert(self.isServiceOpen);
    FLAssertNotNil(self.objectStorage);
    
    id key = [inputObject objectStorageKey_fl];
    
    return FLRetainWithAutorelease([self.objectStorage objectForKey:key]);
}

- (void) deleteObject:(id) inputObject {
    FLAssert(self.isServiceOpen);
    FLAssertNotNil(self.objectStorage);
    id key = [inputObject objectStorageKey_fl];
    id previous = FLRetainWithAutorelease([self.objectStorage objectForKey:key]);
    if(previous) {
        [self.objectStorage removeObjectForKey:key];
    }
}

- (BOOL) containsObject:(id) inputObject {
    FLAssert(self.isServiceOpen);
    FLAssertNotNil(self.objectStorage);
    return [self.objectStorage objectForKey:[inputObject objectStorageKey_fl]] != nil;
}

- (void) openService {
    [super openService];
	self.objectStorage = [NSMutableDictionary dictionary];
}

- (void) closeService {
    [super closeService];
    self.objectStorage = nil;
}

@end
