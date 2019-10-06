//
//	FLMutableArray.h
//	FishLamp
//
//	Created by Mike Fullerton on 7/27/10.
//	Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

/// @category NSArray(FishLamp)
/// @brief A Category for adding a couple of obvious methods to NSArray.

#import "FishLampCore.h"

@interface NSArray (FishLamp)

/// Returns index of last object

/// @returns Index of object or NSNotFound
- (NSUInteger) indexOfLastObject_fl;

// TODO: move these out of core??
+ (NSArray*) arrayOfLinesFromFile:(NSString*) path encoding:(NSStringEncoding)encoding error:(NSError **)error;

+ (NSArray*) arrayOfColumnArraysFromCSVFile:(NSString*) path encoding:(NSStringEncoding)encoding error:(NSError **)error;

@end

/// @category NSMutableArray(FishLamp)
/// A Category for adding a couple of obvious methods to NSMutableArray.

@interface NSMutableArray (FishLamp)

/// Move an object from one index to another index.

- (void) moveObjectToNewIndex_fl:(NSUInteger) fromIndex toIndex:(NSUInteger) toIndex;

/// Remove and return last object in list.

- (id) removeLastObject_fl;

/// Push object on front of the list. 

/// Same as [list insertObject:obj atIndex:0]
- (void) pushObject_fl:(id) object;

/// Remove and returns the first object in the list.

- (id) removeFirstObject_fl;

/// Adds an object as normal, but then calls the configureObject block.

/// The configureBlock block takes an id as an object. 
/// For example: 
/// `[myMutableArray addObject:[NSMutableString string] configureObject:^(id theString) { 
///     [theString appendString:@"I've been configured!!"]; 
/// }];`
/// @param object The object to add.
/// @param configureObject The block to run just after adding the object to the list.
- (void) addObject_fl:(id) object configureObject:(void (^)(id object)) configureObject;

@end

// for c style arrays
// int myArray[] = { 1, 2, 3, 4 };
// int size = FLArraySize(myArray, int);

#define FLArrayLength(__ARRAY__, __TYPE__) ((__ARRAY__) == nil ? 0 : (sizeof(__ARRAY__) / sizeof(__TYPE__)))
#define FLArrayCount FLArrayLength


@interface NSArray (FLThreadAndMutationSafe)
- (void) visitObjectsForward_fl:(void (^)(id object, BOOL* stop)) visitor;
- (BOOL) visitObjectsReverse_fl:(void (^)(id object, BOOL* stop)) visitor;
@end

@interface NSObject (FLLameWorkaroundForArrayRTTI)
// there are issues with isKindOfClass:[NSArray class] 
// this works around this.
- (BOOL) isArray_fl;
@end

