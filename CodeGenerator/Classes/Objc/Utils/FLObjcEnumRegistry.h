//
//  FLObjcEnumRegistry.h
//  CodeGenerator
//
//  Created by Mike Fullerton on 6/1/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLObjcNamedObjectCollection.h"
@class FLObjcEnumCodeWriter;

@interface FLObjcEnumRegistry : FLObjcNamedObjectCollection

+ (id) objcEnumRegistry;

- (BOOL) hasEnum:(FLObjcEnumCodeWriter*) theEnum;
- (void) addEnum:(FLObjcEnumCodeWriter*) theEnum;
- (void) replaceEnum:(FLObjcEnumCodeWriter*) theEnum;
- (id) enumForKey:(NSString*) key;
- (id) enumForName:(FLObjcName*) name;

@end
