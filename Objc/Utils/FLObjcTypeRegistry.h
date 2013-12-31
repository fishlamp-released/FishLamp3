//
//  FLObjcTypeRegistry.h
//  CodeGenerator
//
//  Created by Mike Fullerton on 5/13/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FishLampCore.h"
#import "FLObjcNamedObjectCollection.h"

@class FLCodeProject;
@class FLObjcType;
@class FLObjcName;
@class FLObjcEnumCodeWriter;
@class FLCodeProject;

@interface FLObjcTypeRegistry : FLObjcNamedObjectCollection {
}

+ (id) objcTypeRegistry;

- (BOOL) hasType:(FLObjcType*) type;
- (void) addType:(FLObjcType*) type;
- (void) replaceType:(FLObjcType*) type;

- (id) typeForClass:(Class) aClass;
- (id) typeForKey:(NSString*) key;
- (id) typeForName:(FLObjcName*) name;

@end
