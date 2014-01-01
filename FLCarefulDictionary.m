//
//  FLCarefulDictionary.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 6/1/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLCarefulDictionary.h"
#import "FLPrettyDescription.h"

@interface FLCarefulDictionary ()
@property (readwrite, copy, nonatomic) FLCarefulDictionaryKeyMutator keyMutator;
@end

@implementation FLCarefulDictionary
@synthesize keyMutator = _keyMutator;
@synthesize objects = _objects;

- (id) initWithKeyMutator:(FLCarefulDictionaryKeyMutator) keyMutator {	
	self = [super init];
	if(self) {
		_objects = [[NSMutableDictionary alloc] init];
        _keyMutator = [keyMutator copy];
	}
	return self;
}

- (id) init {	
	return [self initWithKeyMutator:nil];
}

#if FL_MRC
- (void) dealloc {
    [_aliases release];
    [_keyMutator release];
    [_objects release];
	[super dealloc];
}
#endif

+ (id) carefulDictionary {
    return FLAutorelease([[[self class] alloc] init]);
}

+ (id) carefulDictionary:(FLCarefulDictionaryKeyMutator) keyMutator {
    return FLAutorelease([[[self class] alloc] initWithKeyMutator:keyMutator]);
}

- (id) mutateKey:(id) key {
    return _keyMutator ? _keyMutator(key) : key;
}

- (id) resolveKey:(id) key {
    FLAssertNotNil(key);

    key = [self mutateKey:key];

    if([_objects objectForKey:key] != nil) { 
        return key;
    }
    
    if(_aliases) {
        id newKey = [_aliases objectForKey:key];
        if(newKey && [_objects objectForKey:newKey] != nil) {
            return newKey;
        }
    }

    return nil;
}

- (BOOL) hasKey:(id) key {
    return [self resolveKey:key] != nil;
}   

- (id) confirmedKey:(id) key {
    FLAssertNotNil(key);

    id outKey = [self resolveKey:key];
    FLConfirm(outKey != nil, @"object %@ does not exist", key);

    return outKey;
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state 
                                  objects:(id __unsafe_unretained [])buffer 
                                    count:(NSUInteger)len {
    return [_objects countByEnumeratingWithState:state objects:buffer count:len];
}

- (NSEnumerator *)keyEnumerator {
    return [_objects keyEnumerator];
}

- (NSEnumerator *)objectEnumerator {
    return [_objects objectEnumerator];
}

- (NSArray *)allKeys {
    return [_objects allKeys];
}

- (NSArray *)allValues {
    return [_objects allValues];
}

- (id) objectForKey:(id) key {
    FLAssertNotNil(key);

    key = [self confirmedKey:key];
    
    id object = [_objects objectForKey:key];

    FLConfirmNotNil(object, @"Object not in dictionary %@", key);
    return object;
}

- (void) addObject:(id) object forKey:(id) key {
    FLAssertNotNil(object);
    FLAssertNotNil(key);

    id newkey = [self mutateKey:key];

    FLConfirm([self resolveKey:newkey] == nil, @"key already exists (or is alias): \"%@\"", newkey);

    [_objects setObject:object forKey:newkey];
}

- (void) replaceObject:(id) object forKey:(id) key {
    FLAssertNotNil(object);
    FLAssertNotNil(key);

    [_objects setObject:object forKey:[self confirmedKey:key]];
}

- (void) removeObjectWithKey:(id) key {
    FLAssertNotNil(key);

    key = [self confirmedKey:key];
    [_objects removeObjectForKey:key];
    
    if(_aliases) {
        [_aliases removeObjectsForKeys:[_aliases allKeysForObject:key]];
    }
}

- (NSUInteger) count {
    return [_objects count];
}

- (void) addAlias:(NSString*) alias forKey:(id) key {
    FLAssertNotNil(alias);
    FLAssertNotNil(key);

    if(!_aliases) { 
        _aliases = [[NSMutableDictionary alloc] init];
    }
    alias = [self mutateKey:alias];

    FLConfirm([_aliases objectForKey:alias] == nil, @"alias already exists %@", key);

    [_aliases setObject:[self confirmedKey:key] forKey:alias];
}

- (NSString*) description {
    return [self prettyDescription];
}

- (void) prettyDescription:(id<FLStringFormatter>) string {

    for(id key in _objects) {
        [string appendLineWithFormat:@"%@ = %@", key, [_objects objectForKey:key]];
    }
        
    if(_aliases) {
        for(id key in _aliases) {
            [string appendLineWithFormat:@"%@ = %@ (alias)", key, [_aliases objectForKey:key]];
        }
    }
}


@end
