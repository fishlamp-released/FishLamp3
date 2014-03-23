//
//	FLMutableArray.m
//	FishLamp
//
//	Created by Mike Fullerton on 7/27/10.
//	Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "NSArray+FishLampCore.h"
#import "NSString+FishLamp.h"
#import "FishLampAssertions.h"
#import "NSString+FishLamp.h"

@implementation NSObject (FLLameWorkaroundForArrayRTTI)
- (BOOL) isArray_fl {
    return NO;
}
@end

@implementation NSArray (FishLamp)
- (BOOL) isArray_fl {
    return YES;
}

- (NSUInteger) indexOfLastObject_fl {
	return self.count > 0 ? self.count - 1 : NSNotFound;
}

+ (NSArray*) arrayOfLinesFromFile:(NSString*) path 
                         encoding:(NSStringEncoding)encoding 
                            error:(NSError **)error {
    
    NSError* err = nil;
    NSString* file = [NSString stringWithContentsOfFile:path encoding:encoding error:&err];
    
    if(err) {
        if(error) {
            *error = err;
        }
        else {
            FLRelease(err);
        }
    
        return nil;
    }

    NSMutableArray* lines = [NSMutableArray array];
    [file enumerateLinesUsingBlock:^(NSString* string, BOOL* stop) {
        [lines addObject:string];
    }];

    return lines;
}

+ (NSArray*) arrayOfColumnArraysFromCSVFile:(NSString*) path encoding:(NSStringEncoding)encoding error:(NSError **)error {

    NSError* err = nil;
    NSString* file = [NSString stringWithContentsOfFile:path encoding:encoding error:&err];
    if(err) {
        if(error) {
            *error = err;
        }
        else {
            FLRelease(err);
        }
    
        return nil;
    }
    
    NSMutableArray* lines = [NSMutableArray array];
    [file enumerateLinesUsingBlock:^(NSString* string, BOOL* stop) {
        
        string = [string trimmedString_fl];
    
        [lines addObject:[string componentsSeparatedByString:@","]];
    }];

    return lines;
}
@end

@implementation NSArray (FLThreadAndMutationSafe)

- (BOOL) visitObjectsReverse_fl:(void (^)(id object, BOOL* stop)) visitor {
    
    NSInteger idx = 0;
    BOOL started = NO;
    BOOL stop = NO;
    
    while(YES) {
    
        id object = nil;
        @synchronized(self) {
        
            NSUInteger count = self.count;
            if(count == 0) {
                break;
            }
            
            if(!started || idx > count) {
                idx = count - 1;
                started = YES;
            }
            
            if(idx-- >= 0) {
                object = [self objectAtIndex:idx];
            }
        }
    
        if(!object) {
            break;
        }

        visitor(object, &stop);
    }

    return stop;
}

- (void) visitObjectsForward_fl:(void (^)(id object, BOOL* stop)) visitor {

    BOOL stop = NO;
    NSUInteger idx = 0;
    while(YES) {

// this is so objects can other objects to the queue during execution.
        id object = nil;
        @synchronized(self) {
            if(idx < self.count) {
                object = [self objectAtIndex:idx];
            }
        }
        if(!object){
            break;
        }

        visitor(object, &stop);
        
        if(stop) {
            break;
        }

        ++idx;
    }
}


@end


@implementation NSMutableArray (FishLamp)

- (void) moveObjectToNewIndex_fl:(NSUInteger) fromIndex toIndex:(NSUInteger) toIndex {
	FLAssert(fromIndex < (NSUInteger)self.count, @"bad from idx");
	FLAssert(toIndex < (NSUInteger)self.count, @"bad from idx");

	if(fromIndex != toIndex) {
		id object = FLAutorelease(FLRetain([self objectAtIndex:fromIndex]));
        
        [self removeObjectAtIndex:fromIndex];
		
		if(toIndex == self.count) {
			[self addObject:object];
		}
		else {
			[self insertObject:object atIndex:toIndex];
		}
	}
	
}

- (void) addObject_fl:(id) object configureObject:(void (^)(id object)) configureObject {
    if(configureObject) {
        configureObject(object);
    }
    
    [self addObject:object];
}

- (id) removeLastObject_fl {
    if(self.count) {
        id object = FLAutorelease(FLRetain([self lastObject]));
        [self removeLastObject];
        return object;
    }
    
    return nil;
}

- (void) pushObject_fl:(id) object {
	[self insertObject:object atIndex:0];
}

- (id) removeFirstObject_fl {
    if(self.count) {
        id object = FLAutorelease(FLRetain([self objectAtIndex:0]));
        [self removeObjectAtIndex:0];
        return object;
    }
    
    return nil;
}
	


@end
