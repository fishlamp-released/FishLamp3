//
//  FLStorageService.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 2/19/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLStorageService.h"


@interface FLStorageService ()
@end

@implementation FLStorageService 

- (id<FLObjectStorage>) objectStorage {
    return nil;
}

- (id<FLBlobStorage>) blobStorage {
    return nil;
}

- (void) writeObject:(id) object {
    FLAssert(self.isServiceOpen);
    FLAssertNotNil(self.objectStorage);
    [self.objectStorage writeObject:object];
}

- (id) readObject:(id) inputObject {
    FLAssert(self.isServiceOpen);
    FLAssertNotNil(self.objectStorage);
    return [self.objectStorage readObject:inputObject];
}

- (void) deleteObject:(id) object {
    FLAssert(self.isServiceOpen);
    FLAssertNotNil(self.objectStorage);
    [self.objectStorage deleteObject:object];
}

- (BOOL) containsObject:(id) object {
    FLAssert(self.isServiceOpen);
    FLAssertNotNil(self.objectStorage);
    return [self.objectStorage containsObject:object];
}

- (void) writeObjectsInArray:(NSArray*) array {
    FLAssert(self.isServiceOpen);
    FLAssertNotNil(self.objectStorage);
    [self.objectStorage writeObjectsInArray:array];
}

- (void) willStartProcessingObject:(id)object {
    if([object respondsToSelector:@selector(setStorageService:)]) {
        if([object storageService] == nil) {
            [object setStorageService:self];
        }
    }
}

@end

@implementation FLNoStorageService

+ (id) noStorageService {
    return FLAutorelease([[[self class] alloc] init]);
}

- (void) writeObject:(id) object {
}

- (id) readObject:(id) inputObject {
    return nil;
}

- (void) deleteObject:(id) object {
}

- (BOOL) containsObject:(id) object {
    return NO;
}

- (void) writeObjectsInArray:(NSArray*) array {
}

@end
