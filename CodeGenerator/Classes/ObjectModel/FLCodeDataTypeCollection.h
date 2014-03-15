//
//  FLObjcDataTypeRegistry.h
//  CodeGenerator
//
//  Created by Mike Fullerton on 2/6/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//
#import "FishLampCore.h"

@interface FLCodeDataTypeCollection : NSObject {
@private
    NSMutableDictionary* _types;
}

+ (id) codeDataTypeCollection;

// keys are stored as lowercase strings - incoming keys are converted to lowercase string
// so searches are case independent

- (void) setDataType:(id) type forKey:(NSString*) forKey;
- (id) dataTypeForKey:(NSString*) key;

@end
