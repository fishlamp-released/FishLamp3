//
//  FLPropertyAttributes.m
//  FishLampCore
//
//  Created by Mike Fullerton on 3/18/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLPropertyAttributes.h"
#import "FishLampAssertions.h"

// https://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtPropertyIntrospection.html

// https://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html

//typedef enum {
//    FLPropertyAttributeReadOnly = 'R',
//    FLPropertyAttributeCopy = 'C',
//    FLPropertyAttributeRetain = '&',
//    FLPropertyAttributeNonAtomic = 'N',
//    FLPropertyAttributeCustomGetter = 'G',
//    FLPropertyAttributeCustomSetter = 'S',
//    FLPropertyAttributeDynamic = 'D',
//    FLPropertyAttributeWeak = 'W',
//    FLPropertyAttributeEligibleForGarbageCollection = 'P',
//    FLPropertyAttributeOldStyleTypeEncoding = 't',
//    FLPropertyAttributeType = 'T',
//    FLPropertyAttributeTypeDelimeter = ',',
//    FLPropertyAttributeIVar = 'V',
//
//    FLPropertyAttributeTypeAbstractObject = '@',
//    FLPropertyAttributeStructOrObject = '{',
//    FLPropertyAttributeArray = '[',
//    FLPropertyAttributeUnion = '(',
//    
//    FLPropertyAttributeIndirect = '^'
//} FLPropertyAttribute;


const char* FLParsePropertyType(FLPropertyAttributes_t* attributes, const char* str, const char* end) {

    if(*str != 'T') {
        return str;
    }

    // i don't trust checking for trailing 0
    while(str < end) {
        char theChar = *str++;

        if(theChar == ',') {
            break;
        }

        switch(theChar) {
        // parse sub strings
        
            case 'T':
                // expecting this, skip it.
                break;
        
            case '@': // object
                attributes->type = _C_ID;
                attributes->is_object = 1;
                if(*str == '\"') {
                    attributes->className = FLParseFragmentFromCString(++str, '\"');
                    str += (attributes->className.length + 1);
                }
            break;
                        
            // enclosed encoded object or struct
            case '{': {
                attributes->type = _C_STRUCT_B;

                // TODO: parse nested structs?? T{CGRect={CGPoint=dd}{CGSize=dd}},N,V_frame
                // For now just eat the inner ones.
            
                
                attributes->structName = FLParseFragmentFromCString(str, '=');
                str += (attributes->structName.length);

                int bracket_count = 1;
                while(*str++ && bracket_count > 0) {
                    if(*str == '{') {
                        ++bracket_count;
                    }
                    else if(*str == '}') {
                        --bracket_count;
                    }
                }
            }
            break; 

            case '^': // pointer
                attributes->is_pointer = YES;
                attributes->indirect_count++;
            break;
                    
            case ':': // method selector
                attributes->type = _C_SEL;
            break;
            
            case 'c': // char
                attributes->is_number = YES;
                attributes->is_bool_number = YES;
                attributes->type = _C_CHR;
            break;
            
            case 'i': // int
                attributes->is_number = YES;
                attributes->type = _C_INT;
            break;
            
            case 's': // short
                attributes->is_number = YES;
                attributes->type = _C_SHT;
            break;
            
            case 'l': // long
                attributes->is_number = YES;
                attributes->type = _C_LNG;
            break;
            
            case 'q': // long long
                attributes->is_number = YES;
                attributes->type = _C_LNG_LNG;
            break;
            
            case 'C': // unsigned char
                attributes->is_number = YES;
                attributes->is_bool_number = YES;
                attributes->type = _C_UCHR;
            break;
            
            case 'I': // unsigned int
                attributes->is_number = YES;
                attributes->type = _C_UINT;
            break;
            
            case 'S': // unsigned short
                attributes->is_number = YES;
                attributes->type = _C_USHT;
            break;
            
            case 'L': // unsigned long
                attributes->is_number = YES;
                attributes->type = _C_ULNG;
            break;
            
            case 'Q': // unsigned long long
                attributes->is_number = YES;
                attributes->type = _C_ULNG_LNG;
            break;
            
            case 'f': // float
                attributes->is_number = YES;
                attributes->is_float_number = YES;
                attributes->type = _C_FLT;
            break;
            
            case 'd': // double
                attributes->is_number = YES;
                attributes->is_float_number = YES;
                attributes->type = _C_DBL;
            break;
            
            case 'B': // Bool
                attributes->is_number = YES;
                attributes->type = _C_BOOL;
            break;
            
            case 'v': // void
                attributes->type = _C_VOID;
            break;
            
            case '*': // char*
                attributes->type = _C_CHARPTR;
            break;
            
            case '#': // class object
                attributes->type = _C_CLASS;
            break;
            
            case 'b': // bit field
            // TODO: parse number
                attributes->type = _C_BFLD;
            break;
            
            case '?': // unknown type
                attributes->type = _C_UNDEF;
            break;


            case '[': { // array
                attributes->type = _C_ARY_B;
                
                // TODO parse array type and size.
                attributes->is_array = 1;
                
                FLCStringFragment ignore = FLParseFragmentFromCString(str, ']');
                str += (ignore.length + 1);
            }
            break;
            
            case '(': { // union
                attributes->type = _C_UNION_B;
                attributes->is_union = 1;

                attributes->unionName = FLParseFragmentFromCString(str, '=');
                str += (attributes->unionName.length);
                
                int bracket_count = 1;
                while(*str++) {
                    if(*str == '(') {
                        ++bracket_count;
                    }
                    if(*str == ')') {
                        --bracket_count;
                    }
                    
                    if(bracket_count == 0) {
                        break;
                    }
                }
            }
            
            default:
                FLCAssertFailed(@"unhandled type: %c", theChar);
            break;
        }
    }
    
    return str;
}

const char* FLParseTrailingAttributes(FLPropertyAttributes_t* attributes, const char* str, const char* end) {
    // i don't trust checking for trailing 0
    while(str < end) {
        char theChar = *str++;
                
        switch(theChar) {
        // parse sub strings

            case 'C':       
                attributes->copy = 1;        
                break;
            
            case 'R': // readonly   
                attributes->readonly = 1;    
                break;
            
            case ',': 
                // skip, this is the delimeter
                break;
            
            case 'N': // nonatomic
                attributes->nonatomic = 1;
                break;
            
            case '&': // retain
             
                // set by reference? 
                // only seems to be on readwrite properties that have a setter for an object?
                attributes->retain = 1;
            break;
            
            case 'P': // eligible for GC 
                attributes->eligible_for_gc = 1;
                break;
                            
            case 'W': // weak
                attributes->weak = 1;
                break;
                
            case 'D': // dynamic
                attributes->dynamic = 1;
                break;
        
            case 'G': // custom getter
                    // Ti,GintGetFoo,SintSetFoo:,VintSetterGetter
                attributes->customGetter = FLParseFragmentFromCString(str, ',');
                str += (attributes->customGetter.length);
                break;
                
            case 'S': // custom setter
                    // Ti,GintGetFoo,SintSetFoo:,VintSetterGetter
                attributes->customSetter = FLParseFragmentFromCString(str, ',');
                str += (attributes->customSetter.length);
                break;
            
            case 'V': // iVar
                attributes->ivar = FLParseFragmentFromCString(str, 0);
                str += (attributes->ivar.length);
            break;
                
            default:
                FLCAssertFailed(@"unhandled char: %c", theChar);
            break;
        }
    }
    
    return str;
}

FLPropertyAttributes_t FLPropertyAttributesParse(objc_property_t property) {   
    
    FLCAssertNonNilPointer(property);
    
    FLPropertyAttributes_t attributes;
    memset(&attributes, 0, sizeof(FLPropertyAttributes_t));
    
    if(property) {
    
        const char* propertyName = property_getName(property);
        const char* encoded = property_getAttributes(property);
        
        FLCAssert(strlen(propertyName) < FLPropertyAttributesBufferSize, @"FLPropertyAttributesBufferSize is too small");
    
        FLCAssert(strlen(encoded) < FLPropertyAttributesBufferSize, @"FLPropertyAttributesBufferSize is too small");
    
        strncpy(attributes.propertyName, propertyName, FLPropertyAttributesBufferSize);
        strncpy(attributes.encodedAttributes, encoded, FLPropertyAttributesBufferSize);
       
        NSUInteger len = strlen(encoded);
        
        const char* end = encoded + len;
        
        const char* walker = FLParsePropertyType(&attributes, encoded, end);
        
        walker = FLParseTrailingAttributes(&attributes, walker, end);
        
        FLCAssert(walker >= end, @"didn't parse all of %s", encoded);
    }
    
    return attributes;
}

//void FLPropertyAttributesDecodeWithCopy(objc_property_t property, FLPropertyAttributes_t* attributes) {
//    FLPropertyAttributesDecode(property, attributes, YES);
//}

//void FLPropertyAttributesParse(objc_property_t property, FLPropertyAttributes_t* attributes) {
//    FLPropertyAttributesDecode(property, attributes, NO);
//}

//void FLPropertyAttributesFree(FLPropertyAttributes_t* attributes) {
//    if(attributes && attributes->needs_free) {
//        if(attributes->encodedAttributes) {
//            free((void*)attributes->encodedAttributes);
//        }
//        if(attributes->propertyName) {
//            free((void*)attributes->propertyName);
//        }
//        memset(attributes, 0, sizeof(FLPropertyAttributes_t));
//    }
//}

NSString* FLPropertyAttributesGetPropertyName(FLPropertyAttributes_t attributes) {
    return [NSString stringWithCString:attributes.propertyName encoding:NSASCIIStringEncoding];
}

NSString* FLPropertyAttributesGetClassName(FLPropertyAttributes_t attributes) {
    return attributes.className.string ? [NSString stringWithCStringFragment:attributes.className] : nil;
}

SEL FLPropertyAttributesGetSelector(FLPropertyAttributes_t attributes) {
    return attributes.selector.string ? NSSelectorFromString([NSString stringWithCStringFragment:attributes.selector]) : nil;
}

NSString* FLPropertyAttributesGetUnionName(FLPropertyAttributes_t attributes) {
    return attributes.unionName.string ? [NSString stringWithCStringFragment:attributes.unionName] : nil;
}

NSString* FLPropertyAttributesGetStructName(FLPropertyAttributes_t attributes) {
    return attributes.structName.string ? [NSString stringWithCStringFragment:attributes.structName] : nil;
}

SEL FLPropertyAttributesGetCustomGetter(FLPropertyAttributes_t attributes) {
    return attributes.customGetter.string ? NSSelectorFromString([NSString stringWithCStringFragment:attributes.customGetter]) : nil;
}

SEL FLPropertyAttributesGetCustomSetter(FLPropertyAttributes_t attributes) {
    return attributes.customSetter.string ? NSSelectorFromString([NSString stringWithCStringFragment:attributes.customSetter]) : nil;
}

NSString* FLPropertyAttributesGetIvarName(FLPropertyAttributes_t attributes) {
    return attributes.ivar.string ? [NSString stringWithCStringFragment:attributes.ivar] : nil;
}

void FLPropertyAttributesGetAttributesForProtocol(Protocol* protocol, FLPropertyAttributes_t** buffer, unsigned int* outCount) {

    unsigned int count = 0;
    objc_property_t* propertyList = protocol_copyPropertyList(protocol, &count);

    FLPropertyAttributes_t* outBuffer = malloc(sizeof(FLPropertyAttributes_t) * count);
    *buffer = outBuffer;
    *outCount = count;

    for(unsigned int i = 0; i < count; i++) {
        outBuffer[i] = FLPropertyAttributesParse(propertyList[i]);
    }

    if(propertyList) {
        free(propertyList);
    }
}

void FLPropertyAttributesGetAttributesForClass(Class aClass, FLPropertyAttributes_t** buffer, unsigned int* outCount) {

    unsigned int count = 0;
    objc_property_t* propertyList = class_copyPropertyList(aClass, &count);

    FLPropertyAttributes_t* outBuffer = malloc(sizeof(FLPropertyAttributes_t) * count);
    *buffer = outBuffer;
    *outCount = count;

    for(unsigned int i = 0; i < count; i++) {
        outBuffer[i] = FLPropertyAttributesParse(propertyList[i]);
    }

    if(propertyList) {
        free(propertyList);
    }
}


/*
 NSString* propertyName = FLAutorelease([[NSString alloc] initWithCString:attributes.propertyName encoding:NSASCIIStringEncoding]);
    FLAssertStringIsNotEmpty(propertyName);

    if(attributes.is_object) {

        Class objectClass = nil;
        if(attributes.className.string) {
            objectClass = NSClassFromString([NSString stringWithCStringFragment:attributes.className]);
        }
        else {
            objectClass = [FLAbstractObjectType class];
        }

        FLAssertNotNil(objectClass,
                                  @"Can't find class for: \"%@\"",
                                  [NSString stringWithCStringFragment:attributes.className] );

        return [[objectClass propertyDescriberClass] propertyDescriber:propertyName
                                                       objectDescriber:[objectClass objectDescriber]
                                                            attributes:attributes];

    }
    else {
        if(attributes.is_bool_number) {
            return [FLBoolNumberPropertyDescriber propertyDescriber:propertyName objectDescriber:nil attributes:attributes];
        }
        else if(attributes.is_number) {
            return [FLNumberPropertyDescriber propertyDescriber:propertyName objectDescriber:nil attributes:attributes];
        }
    }
*/


//@interface FLPropertyAttributes ()
//@property (readwrite, strong, nonatomic) NSString* className;
//@property (readwrite, strong, nonatomic) NSString* propertyName;
//@property (readwrite, strong, nonatomic) NSString* structName;
//@property (readwrite, strong, nonatomic) NSString* ivarName;
//@property (readwrite, strong, nonatomic) NSString* unionName;
//
//@property (readwrite, assign, nonatomic) SEL customGetter;
//@property (readwrite, assign, nonatomic) SEL customSetter;
//@property (readwrite, assign, nonatomic) SEL selector;
//@end
//
//#define MakeSelector(str) str.length == 0 ? nil : NSSelectorFromString([NSString withCharString:str])
//

//
//@implementation FLPropertyAttributes
//
//@synthesize className = _className;
//@synthesize propertyName = _propertyName;
//@synthesize structName = _structName;
//@synthesize ivarName = _ivarName;
//@synthesize unionName = _unionName;
//@synthesize customGetter = _customGetter;
//@synthesize customSetter = _customSetter;
//@synthesize selector = _selector;
//
//LazyStringGetter(propertyName, _propertyName, _attributes.propertyName)
//LazyStringGetter(structName, _structName, _attributes.structName)
//LazyStringGetter(unionName, _unionName, _attributes.unionName)
//LazyStringGetter(ivarName, _ivarName, _attributes.ivar)
//
//
//- (id) initWithParsedAttributes:(FLPropertyAttributes_t) parsed 
//	self = [super init];
//	if(self) {
//		if(parsed.propertyName) {
//            self.propertyName = [NSString stringWithCString:attributes.propertyName encoding:NSASCIIStringEncoding];
//        }
//        
//        self.className = [NSString stringWithCStringFragment:attributes.className];
//        self.structName = [NSString stringWithCStringFragment:attributes.structName];
//        self.ivalName = [NSString stringWithCStringFragment:attributes.ivar];
//        self.unionName = [NSString stringWithCStringFragment:attributes.ivar];
//        self.customSetter = MakeSelector(attributes.customSetter);
//        self.customSetter = MakeSelector(attributes.customSetter);
//	}
//	return self;
//}
//+ (id) propertyAttributes:(FLPropertyAttributes_t) parsed {
//    return FLAutorelease([[[self class] alloc] initWithParsedAttributes:parsed]);
//}
//
//@end

