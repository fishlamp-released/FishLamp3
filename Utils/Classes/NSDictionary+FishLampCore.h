//
//  NSDictionary+NSDictionary_FLAdditions.h
//  FishLamp
//
//  Created by Mike Fullerton on 9/3/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton.. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampCore.h"

// With the array api below, nils in the object arrays are acceptable and will
// either remove item from the dictionary (in setObjects) or not add the key/object
// pair in the first place (in the case of creating a new dictinary)

typedef struct {
    __unsafe_unretained id object;
    __unsafe_unretained id key;
} FLDictionaryEntry;

extern const FLDictionaryEntry FLDictionaryEntryNil;

NS_INLINE FLDictionaryEntry FLDictionaryEntryMake(id object, id key) {
    FLDictionaryEntry o = { object, key };
    return o;
}

@interface NSDictionary (FLAdditions)

- (id)initWithEntryArray:(const FLDictionaryEntry[]) objects;

+ (id)dictionaryWithEntryArray:(const FLDictionaryEntry[]) objects;
                      
// the object array sent in here "overrides" values in the otherDictionary if the keys/value pair is already there
// will return otherDictionary if there's nothing to add from object/key arrays. 
+ (id) combineDictionary:(NSDictionary *)dictionaryOrNil
          withEntryArray:(const FLDictionaryEntry[]) objectsWhereNilsAreRemoved;


@end

@interface NSMutableDictionary (FLAdditions)
- (void) setObjectsWithEntryArray:(const FLDictionaryEntry[]) objectsWhereNilsAreRemoved;
@end