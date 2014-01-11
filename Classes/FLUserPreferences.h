//
//  FLUserPreferences.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 10/5/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FishLampCore.h"

@interface FLUserPreferences : NSObject {
@private
    BOOL _loaded;
}

- (NSString*) readAppVersion;
- (void) writeAppVersion;
- (void) deleteAll;
- (void) deleteAllIfVersionChanged;


- (id) objectForKey:(id) key;
- (void) setObject:(id) object forKey:(id) key;

- (BOOL)boolForKey:(NSString *)defaultName;
- (void)setBool:(BOOL)value forKey:(NSString *)defaultName;

- (void) synchronize;
- (void)removeObjectForKey:(id)aKey;

@end
