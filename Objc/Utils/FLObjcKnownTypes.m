//
//  FLObjcKnownTypes.m
//  CodeGenerator
//
//  Created by Mike Fullerton on 5/11/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLObjcKnownTypes.h"
#import "FLObjcType.h"
#import "FLObjcName.h"
#import "FLObjcCodeGeneratorHeaders.h"
#import "FLObjcRuntime.h"
#import "FLBase64Data.h"

// TODO: load these in from a file or something more configable than a .m file

@implementation FLObjcKnownTypes

+ (NSDictionary*) knownTypeAliases {
    return [NSDictionary dictionaryWithObjectsAndKeys:
         @"FLGuid",@"guid", 
         @"NSDate" ,@"date", 
         @"NSDate" ,@"datetime", 
         @"NSDate" ,@"time", 
         @"NSString" ,@"string", 
         @"NSNumber" ,@"number", 
         @"BOOL",@"boolean", 
         @"SDKPoint", @"point",
         @"SDKRect", @"rect", 
         @"SDKSize", @"size",
         @"NSMutableArray", @"array",
         @"NSMutableArray", @"mutablearray",
         @"NSMutableDictionary", @"dictionary",
         @"id", @"object",
         @"double", @"decimal",
         @"FLBase64Data", @"base64binary",
         @"FLBase64Data", @"base64",

         @"SInt32", @"integer",
		 @"UInt32", @"unsignedint",
		 @"UInt32", @"unsigned",
         @"SInt32", @"Int32",
         @"SInt64", @"long",
         @"UInt64", @"unsigned long",
         @"SInt32", @"int",
         @"UInt32", @"unsigned int",
         @"SInt64", @"long long",
         @"UInt64", @"unsigned long long",
         @"SInt16", @"short",
         @"UInt16", @"unsigned short",

         nil];
}

+ (NSArray*) loadKnownTypes {

// TODO: load these in in a file loaded at runtime.

    typedef struct {
        __unsafe_unretained NSString* objcType;
        __unsafe_unretained NSString* name;
        __unsafe_unretained NSString* include;
    } FLTypeHeader;

	static FLTypeHeader s_knownTypes[] = {
// objects
		{ @"FLObjcImmutableObjectType", @"NSObject", nil },
		{ @"FLObjcImmutableObjectType", @"NSValue", nil },
		{ @"FLObjcImmutableObjectType", @"NSDate", nil },
		{ @"FLObjcImmutableObjectType", @"NSData", nil },
		{ @"FLObjcStringType", @"NSString", nil },

		{ @"FLObjcProtocolType", @"NSCoder", nil },

		{ @"FLObjcNumberObjectType", nil, nil },

		{ @"FLObjcContainerType", @"NSMutableArray", nil },
		{ @"FLObjcContainerType", @"NSArray", nil },
		{ @"FLObjcContainerType", @"NSDictionary", nil },
		{ @"FLObjcContainerType", @"NSMutableDictionary", nil },
		{ @"FLObjcContainerType", @"NSSet", nil },
		{ @"FLObjcContainerType", @"NSMutableSet", nil },
		{ @"FLObjcContainerType", @"NSCountedSet", nil },

        { @"FLObjcImmutableObjectType", @"UIColor", nil },
        { @"FLObjcImmutableObjectType", @"NSColor", nil },
        { @"FLObjcImmutableObjectType", @"SDKColor", nil },
        { @"FLObjcImmutableObjectType", @"NSURL", nil },

		{ @"FLObjcImmutableObjectType", @"NSZone", nil },

// values
		{ @"FLObjcCharType", @"char", nil },
		{ @"FLObjcUnsignedCharType", @"unsigned char", nil },
		{ @"FLObjcNSIntegerType", @"NSInteger", nil },
		{ @"FLObjcNSUIntegerType", @"NSUInteger", nil },
		{ @"FLObjcUInt32Type", @"UInt32", nil },
		{ @"FLObjcSInt32Type", @"SInt32", nil },
		{ @"FLObjcSInt64Type", @"SInt64", nil },
		{ @"FLObjcUInt64Type", @"UInt64", nil },
		{ @"FLObjcSInt16Type", @"SInt16", nil },
		{ @"FLObjcUInt16Type", @"UInt16", nil },
		{ @"FLObjcFloatType", @"float", nil },
		{ @"FLObjcDoubleType", @"double", nil },

		{ @"FLObjcGeometryType", @"CGPoint", nil },
		{ @"FLObjcGeometryType", @"CGRect", nil },
		{ @"FLObjcGeometryType", @"CGSize", nil },
		{ @"FLObjcGeometryType", @"SDKPoint", nil },
		{ @"FLObjcGeometryType", @"SDKRect", nil },
		{ @"FLObjcGeometryType", @"SDKSize", nil },
        { @"FLObjcGeometryType", @"NSPoint", nil },
		{ @"FLObjcGeometryType", @"NSRect", nil },
		{ @"FLObjcGeometryType", @"NSSize", nil },
        
        { @"FLObjcBoolType", @"BOOL", nil },
        { @"FLObjcVoidType", @"void", nil },
		{ @"FLObjcAbstractObjectType", @"id", nil },
        
// fishlamp
        { @"FLObjcMutableObjectType", @"FLDatabaseTable", @"FLDatabaseTable.h" },
		{ @"FLObjcMutableObjectType", @"FLObjectDescriber", @"FLObjectDescriber.h" },
		{ @"FLObjcMutableObjectType", @"FLModelObject", @"FLModelObject.h" },
		{ @"FLObjcImmutableObjectType", @"FLGuid", @"FLGuid.h" },
		{ @"FLObjcImmutableObjectType", @"FLBase64Data", @"FLBase64Data.h" },

        { @"FLObjcObjectType", @"FLHttpRequest", @"FLHttpRequest.h" },
        { @"FLObjcObjectType", @"FLSoapHttpRequest", @"FLSoapHttpRequest.h" },
        { @"FLObjcObjectType", @"FLJsonHttpRequest", @"FLJsonHttpRequest.h" },
        { @"FLObjcObjectType", @"FLXmlHttpRequest", @"FLXmlHttpRequest.h" },
        
        { @"FLObjcProtocolType", @"NSCopying", nil },
        { @"FLObjcProtocolType", @"NSCoding", nil },

//		{ @"FLObjcImmutableObjectType", @"FLCodeElement", @"FLCodeElementsAll.h" },

        { nil, nil, nil }
	};
    
    NSMutableArray* array = [NSMutableArray array];
    for(int i = 0; s_knownTypes[i].objcType != nil; i++) {

        FLObjcType* type = nil;
        Class class = NSClassFromString(s_knownTypes[i].objcType);
        FLAssertNotNilWithComment(class, @"unable to load class %@", s_knownTypes[i].objcType);
        
        if(s_knownTypes[i].name) {
            FLObjcName* name = [FLObjcImportedName objcImportedName:s_knownTypes[i].name];
            
            type = FLAutorelease([[class alloc] initWithTypeName:name importFileName:s_knownTypes[i].include]);
        }
        else {
            type = FLAutorelease([[class alloc] init]);
        }
        
        FLAssertNotNilWithComment(class, @"unable to load class %@", s_knownTypes[i].objcType);
        
        
        [array addObject:type];
    }

//    NSArray* syntaxClasses = [NSObject subclassesForClass:[FLCodeElement class]];
//    for(Class class in syntaxClasses) {
//
//        FLObjcName* name = [FLObjcImportedName objcImportedName:NSStringFromClass(class)];
//
//        FLObjcType* type = FLAutorelease([[FLObjcImmutableObjectType alloc] initWithTypeName:name
//                                                                              importFileName:@"FLCodeElementsAll.h"]);
//        [array addObject:type];
//    }

    return array;
}




@end
