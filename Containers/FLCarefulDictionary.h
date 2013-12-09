//
//  FLCarefulDictionary.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 6/1/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FishLampMinimum.h"

typedef id (^FLCarefulDictionaryKeyMutator)(id key);

@interface FLCarefulDictionary : NSObject<NSFastEnumeration> {
@private
    NSMutableDictionary* _objects;
    NSMutableDictionary* _aliases;
    FLCarefulDictionaryKeyMutator _keyMutator;
}


@property (readonly, copy, nonatomic) FLCarefulDictionaryKeyMutator keyMutator;
@property (readonly, strong, nonatomic) NSDictionary* objects;
@property (readonly, assign, nonatomic) NSUInteger count;

- (id) initWithKeyMutator:(FLCarefulDictionaryKeyMutator) keyMutator;
+ (id) carefulDictionary;
+ (id) carefulDictionary:(FLCarefulDictionaryKeyMutator) keyMutator;

- (id) mutateKey:(id) key;

- (NSEnumerator *)keyEnumerator;
- (NSEnumerator *)objectEnumerator;
- (NSArray *)allKeys;
- (NSArray *)allValues;

- (BOOL) hasKey:(id) key;
- (id) objectForKey:(id) key;

- (void) addObject:(id) object forKey:(id) key;
- (void) replaceObject:(id) object forKey:(id) key;
- (void) removeObjectWithKey:(NSString*) name;

- (void) addAlias:(NSString*) alias forKey:(id) key;

@end
