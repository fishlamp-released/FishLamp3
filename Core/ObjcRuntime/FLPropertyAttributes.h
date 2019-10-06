//
//  FLPropertyAttributes.h
//  FishLampCore
//
//  Created by Mike Fullerton on 3/18/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

#import "FishLampStrings.h"

#ifndef FLPropertyAttributesBufferSize
#define FLPropertyAttributesBufferSize 256
#endif

typedef struct {
    char encodedAttributes[FLPropertyAttributesBufferSize];
    char propertyName[FLPropertyAttributesBufferSize];

    // these are pointers into the various strings
    FLCStringFragment className;
    FLCStringFragment structName;
    FLCStringFragment customGetter;
    FLCStringFragment customSetter;
    FLCStringFragment ivar;
    FLCStringFragment selector;
    FLCStringFragment unionName;
    
    unsigned int is_object: 1;
    unsigned int is_array: 1;
    unsigned int is_union: 1;
    unsigned int is_number: 1;
    unsigned int is_bool_number: 1;
    unsigned int is_float_number: 1;
    unsigned int retain:1;
    unsigned int readonly: 1;
    unsigned int copy: 1;
    unsigned int weak: 1;
    unsigned int nonatomic: 1;
    unsigned int dynamic: 1;
    unsigned int eligible_for_gc : 1;
    unsigned int indirect_count:8;
    unsigned int is_pointer:1;
    char type; // see runtime.h
} FLPropertyAttributes_t;

extern FLPropertyAttributes_t FLPropertyAttributesParse(objc_property_t property);

extern NSString* FLPropertyAttributesGetPropertyName(FLPropertyAttributes_t attributes);

extern NSString* FLPropertyAttributesGetClassName(FLPropertyAttributes_t attributes);

extern NSString* FLPropertyAttributesGetUnionName(FLPropertyAttributes_t attributes);

extern NSString* FLPropertyAttributesGetStructName(FLPropertyAttributes_t attributes);

extern SEL FLPropertyAttributesGetCustomGetter(FLPropertyAttributes_t attributes);

extern SEL FLPropertyAttributesGetCustomSetter(FLPropertyAttributes_t attributes);

extern NSString* FLPropertyAttributesGetIvarName(FLPropertyAttributes_t attributes);

extern SEL FLPropertyAttributesGetSelector(FLPropertyAttributes_t attributes);

extern void FLPropertyAttributesGetAttributesForProtocol(Protocol* protocol, FLPropertyAttributes_t** buffer, unsigned int* outSize);

extern void FLPropertyAttributesGetAttributesForClass(Class aClass, FLPropertyAttributes_t** buffer, unsigned int* outSize);