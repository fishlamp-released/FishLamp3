//
//  FLCodeObject+ObjcSetup.m
//  CodeGenerator
//
//  Created by Mike Fullerton on 2/5/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//
#if REFACTOR
#import "FLObjcCodeGenerator.h"
#import "FLObjcCodeGenerator+Types.h"

#import "NSString+Lists.h"
#import "FLCodeObjectModel.h"
#import "FLCodeBuilder.h"
#import "NSString+Lists.h"
#import "FLCodeObjectModel.h"
#import "FLGuid.h"
#import "FLDatabase.h"
#import "FLObjectDescriber.h"
#import "FLObjectInflator.h"
#import "FLCodeDataType+Objc.h"
#import "FLObjcUtilities.h"

#define kMemberDataPrefix @"_"

@implementation FLCodeProperty (Objc)

- (FLCodeVariable*) createVariableForProperty {
	
    FLConfirmStringIsNotEmptyWithComment(self.name, @"name missing");
    FLConfirmStringIsNotEmptyWithComment(self.type, @"type missing");

    if(FLStringIsEmpty(self.memberName)) {
        self.memberName = [NSString stringWithFormat:@"%@%@", kMemberDataPrefix, self.name];
    }

    FLCodeObjectMemberType* type = [FLCodeObjectMemberType objectMemberType];
    type.typeName = self.type;
    type.name = self.memberName;
    type.defaultValue = self.defaultValue;
    type.isStatic = self.isStatic;
    type.isWeak = self.isWeak;
    return type;
}

@end

@interface FLObjcCodeGenerator (PrivateSetup)
- (void) prepareToGenerateObject:(FLCodeObject*) property;
- (void) prepareToGenerateProperty:(FLCodeProperty*) property;
@end

@implementation FLObjcCodeGenerator (Setup)

//- (void) addIsEqualMethodToObject:(FLCodeObject*) object storageProperties:(NSMutableDictionary*) storageProperties {
//	NSMutableArray* equalityProperties = [NSMutableArray array];
//	
//	for(NSString* key in storageProperties) {
//		FLCodeProperty* prop = [storageProperties objectForKey:key];
//		if(prop.useForEquality) {
//			[equalityProperties addUniqueObject:prop];
//		}
//	}
//	
//	if(equalityProperties.count) {
//        FLCodeMethod* method = [FLCodeMethod method];
//        method.name = @"isEqual";
//        method.isPrivate = [NSNumber numberWithBool:YES];
//        method.returnType = @"BOOL";
//        [object.methods addUniqueObject:method];
//        
//        FLCodeVariable* parameter = [FLCodeVariable variable];
//        parameter.name = @"object";
//        parameter.typeName = @"id";
//        [method.parameters addUniqueObject:parameter];
//    
//        FLPrettyString* builder = [FLPrettyString prettyString];
//        [builder appendString:@"return [object isKindOfClass:[self class]]"]; 
//        
//        for(FLCodeProperty* prop in equalityProperties) {
//            [builder appendFormat:@" && [[((%@*)object) %@] isEqual:[self %@]]", object.typeName, prop.name, prop.name];
//        }
//        
//        [builder appendLine:@";"];
//        method.code.lines = [builder string];
//        
//        FLCodeMethod* hashMethod = [FLCodeMethod method];
//        hashMethod.name = @"hash";
//        hashMethod.isPrivate = [NSNumber numberWithBool:YES];
//        hashMethod.returnType = @"NSUInteger";
//        [object.methods addUniqueObject:hashMethod];
//        
//        FLPrettyString* builder2 = [FLPrettyString prettyString];
//        [builder2 appendString:@"return"]; 
//        int count = 0;
//        for(FLCodeProperty* prop in equalityProperties) {
//            [builder2 appendFormat:@" %@[[self %@] hash]", count++ > 0 ? @"+ " : @"", prop.name];
//        }
//        
//        [builder2 appendLine:@";"];
//        hashMethod.code.lines = [builder2 string];
//	}
//}


//- (void) addEncodeMethodToObject:(FLCodeObject*) object storageProperties:(NSMutableDictionary*) storageProperties {
//
//	FLCodeMethod* method = [FLCodeMethod method];
//	method.name = @"encodeWithCoder";
//	method.isPrivate = [NSNumber numberWithBool:YES];
//	[object.methods addUniqueObject:method];
//	
//	FLCodeVariable* parameter = [FLCodeVariable variable];
//	parameter.name = @"aCoder";
//	parameter.typeName = @"NSCoder";
//	[method.parameters addUniqueObject:parameter];
//
//	FLPrettyString* builder = [FLPrettyString prettyString];
//	for(FLCodeObjectMemberType* member in object.members) {
//		if(!member.isStatic) {
//			[builder appendLineWithFormat:@"if(%@) [aCoder encodeObject:%@ forKey:@\"%@\"];", member.name, member.name, member.name];
//		}
//	}
//	
//	if([self.superclass rangeOfString:@"NSObject"].length == 0) {
//		[builder appendLine:@"[super encodeWithCoder:aCoder];"];
//	}
//	
//	method.code.lines = [builder string];
//}

//- (void) addDecodeMethodToObject:(FLCodeObject*) object storageProperties:(NSMutableDictionary*) storageProperties {
//
//	FLCodeMethod* method = [FLCodeMethod method];
//	method.name = @"initWithCoder";
//	method.isPrivate = [NSNumber numberWithBool:YES];
//	method.returnType = @"id";
//	[object.methods addUniqueObject:method];
//	
//	FLCodeVariable* parameter = [FLCodeVariable variable];
//	parameter.name = @"aDecoder";
//	parameter.typeName = @"NSCoder";
//	[method.parameters addUniqueObject:parameter];
//	
//	FLPrettyString* builder = [FLPrettyString prettyString];
//	
//	if([self.superclass rangeOfString:@"NSObject"].length == 0) {
//		[builder appendLine:@"if((self = [super initWithCoder:aDecoder])) {"];
//	}
//	else {
//		[builder appendLine:@"if((self = [super init])) {"];
//	}
//	    
//    [builder indent: ^{
//        for(FLCodeObjectMemberType* member in object.members) {
//            if(!member.isStatic) {
//                if([member.typeName rangeOfString:@"Mutable"].length > 0) {
//                    [builder appendLineWithFormat:@"%@ = [[aDecoder decodeObjectForKey:@\"%@\"] mutableCopy];", member.name, member.name];
//                }
//                else {
//                    [builder appendLineWithFormat:@"%@ = FLRetain([aDecoder decodeObjectForKey:@\"%@\"]);", member.name, member.name];
//                }
//            
//            }
//        }
//    }];
//    
//	[builder appendLine:@"}"];
//	[builder appendLine:@"return self;"];
//	
//    method.code.lines = [builder string];
//}

//- (void) addDescriberMethodToObject:(FLCodeObject*) object {
//	[self addDependency:@"FLObjectDescriber" forObject:object];
//
//	FLCodeMethod* method = [FLCodeMethod method];
//	method.name = @"sharedObjectDescriber";
//	method.returnType = @"FLObjectDescriber";
//	method.isPrivate = YES;
//	method.isStatic = YES;
//	
//	FLPrettyString* builder = [FLPrettyString prettyString];
//	
//    [builder appendLine:@"static FLObjectDescriber* s_describer = nil;"];
//	[builder appendLine:@"static dispatch_once_t pred = 0;"];
//    [builder appendLine:@"dispatch_once(&pred, ^{"];
//    
//    [builder indent:^{
//        [builder appendLineWithFormat:@"s_describer = [[super sharedObjectDescriber] copy];"];
//        [builder appendLineWithFormat:@"if(!s_describer) {"];
//        
//        [builder indent:^{
//            [builder appendLine:@"s_describer = [[FLObjectDescriber alloc] init];"];
//        }];
//        
//        [builder appendLine:@"}"];
//
//        for(FLCodeProperty* prop in object.properties) {
//            if(	!prop.isStatic && 
//                !prop.isImmutable && 
//                !prop.isReadOnly) {
//                
//                FLCodeDataType* type = [self typeFromObjcString:prop.typeUnmodified];
//                
//                NSString* objectType = type.stringForValueType;
//                if(!objectType) {
//                    objectType = prop.type;
//                }
//
//
//// TODO: rewrite me
//
////                if(prop.arrayTypes.count) {
////                    NSMutableArray* arrayTypes = [NSMutableArray array];
////                    NSString* arrayTypesStr = @"nil";
////                
////                    for(FLCodeArrayType* arrayType in prop.arrayTypes) {
////                        [arrayTypes addObject:[NSString stringWithFormat:@"[FLPropertyType propertyType:@\"%@\" propertyClass:[%@ class] propertyType:%@ arrayTypes:nil]",
////                            arrayType.name,
////                            arrayType.typeName,
////                            FLConvertToKnownType(type.typeNameUnmodified)
////                            ]];
////
//////                            FLStringFromType(
//////                                FLDataTypeIDFromString(FLConvertToKnownType(type.typeNameUnmodified)))]];
////                    }
////                    
////                    if(arrayTypes.count) {
////                        [arrayTypes addObject:@"nil"];
////                        
////                        arrayTypesStr = [NSString stringWithFormat:@"[NSArray arrayWithObjects:%@]", [NSString concatStringArray:arrayTypes]];
////                    }
////                
////                    [builder appendLineWithFormat:
////                        @"[s_describer setPropertyDescriber:[FLPropertyType propertyType:@\"%@\" propertyClass:[%@ class] propertyType:%@ arrayTypes:%@ isUnboundedArray:%@] forPropertyName:@\"%@\"];", 
////                            prop.name,
////                            objectType,
////                            type.//FLDataTypeIDStringFromDataType(typeId),
////                            arrayTypesStr,
////                            prop.isWildcardArray ? @"YES" : @"NO",
////                            prop.name
////                            ];
////
////                
////                }
////                else {
////                    [builder appendLineWithFormat:
////                        @"[s_describer setPropertyDescriber:[FLPropertyType propertyType:@\"%@\" propertyClass:[%@ class] propertyType:%@] forPropertyName:@\"%@\"];", 
////                            prop.name,
////                            objectType,
////                            FLDataTypeIDStringFromDataType(typeId),
////                            prop.name];
////                }
//            }
//        }
//    }];
//    
//    [builder appendLine:@"});"];
//    
//	[builder appendLine:@"return s_describer;"];
//	
//	method.code.lines = [builder string];
//
//	[object.methods addObject:method];
//
//}

//- (void) addObjectInflatorMethodToObject:(FLCodeObject*) object {
//	[self addDependency:@"FLObjectInflator" forObject:object];
//
//	FLCodeMethod* method = [FLCodeMethod method];
//	method.name = @"sharedObjectInflator";
//	method.returnType = @"FLObjectInflator";
//	method.isPrivate = YES;
//	method.isStatic = YES;
//	
//	FLPrettyString* builder = [FLPrettyString prettyString];
//	[builder appendLine:@"static FLObjectInflator* s_inflator = nil;"];
//	[builder appendLine:@"static dispatch_once_t pred = 0;"];
//    [builder appendLine:@"dispatch_once(&pred, ^{"];
//    [builder indent:^{
//        [builder appendLine:@"s_inflator = [[FLObjectInflator alloc] initWithObjectDescriber:[[self class] sharedObjectDescriber]];"];
//    }];
//
//	[builder appendLine:@"});"];
//	[builder appendLine:@"return s_inflator;"];
//	
//	method.code.lines = [builder string];
//
//	[object.methods addObject:method];
//
//}

- (void) addSqlTableMethodToObject:(FLCodeObject*) object {
	[self addDependency:@"FLDatabaseTable" forObject:object];
	
	FLCodeMethod* method = [FLCodeMethod method];
	method.name = @"sharedDatabaseTable";
	method.returnType = @"FLDatabaseTable";
	method.isPrivate = YES;
	method.isStatic = YES;
	
	FLPrettyString* builder = [FLPrettyString prettyString];

	[builder appendLine:@"static FLDatabaseTable* s_table = nil;"];
	[builder appendLine:@"static dispatch_once_t pred = 0;"];
    [builder appendLine:@"dispatch_once(&pred, ^{"];
    
    [builder indent:^{

        [builder appendLineWithFormat:@"FLDatabaseTable* superTable = [super sharedDatabaseTable];"];
        [builder appendLineWithFormat:@"if(superTable) {"];
        [builder indent: ^{
            [builder appendLineWithFormat:@"s_table = [superTable copy];"];
            [builder appendLineWithFormat:@"s_table.tableName = [self databaseTableName];"];
        }];
        
        [builder appendLine:@"}"];
        [builder appendLine:@"else {"];
        [builder indent:^{
            [builder appendLineWithFormat:@"s_table = [[FLDatabaseTable alloc] initWithTableName:[self databaseTableName]];"];
        }];
        
        [builder appendLine:@"}"];

        for(FLCodeProperty* prop in object.properties) {
        
            if(	!prop.isStatic && 
                !prop.isImmutable && 
                !prop.isReadOnly &&
                prop.storageOptions.isStorable) {

                NSString* type = @"FLDatabaseTypeText";
                NSString* constraintsStr = @"nil";
            
                if(prop.storageOptions.isPrimaryKey) {
                    constraintsStr = @"[NSArray arrayWithObject:[FLDatabaseColumn primaryKeyConstraint]]";
                }
                else {
                    NSMutableArray* array = [NSMutableArray array];
                
                    if(prop.storageOptions.isRequired) {
                        [array addObject:@"[FLDatabaseColumn notNullConstraint]"];
                    }
                    
                    if(prop.storageOptions.isUnique) {
                        [array addObject:@"[FLDatabaseColumn uniqueConstraint]"];
                    }

                    if(array.count){
                        [array addObject:@"nil"];
                    
                        NSMutableString* constraints = [NSMutableString stringWithString:@"[NSArray arrayWithObjects:"];
                        [constraints appendString:[NSString concatStringArray:array]];
                        [constraints appendString:@"]"];
                        constraintsStr = constraints;
                    }

                }
                
//                FLCodeDataType* typeId = FLDataTypeIDFromString(prop.typeUnmodified);
//                if(typeId.specificType) {
//                }
                
//                switch(typeId) {
//                    case FLDataTypeNSInteger:
//                    case FLDataTypeNSUInteger:
//                    case FLDataTypeEnum:
//                    case FLDataTypeBool:
//                    case FLDataTypeChar:
//                    case FLDataTypeUnsignedChar:
//                    case FLDataTypeInteger:
//                    case FLDataTypeUnsignedInteger:
//                    case FLDataTypeLong:
//                    case FLDataTypeUnsignedLong:
//                    case FLDataTypeShort:
//                    case FLDataTypeUnsignedShort:
//                    case FLDataTypeUnsignedLongLong:
//                    case FLDataTypeLongLong:
//                        type = @"FLDatabaseTypeInteger";
//                        break;
//                        
//                    case FLDataTypeFloat:
//                    case FLDataTypeDouble:
//                        type = @"FLDatabaseTypeFloat";
//                        break;
//
//                    case FLDataTypeColor:
//                    case FLDataTypeData:
//                    case FLDataTypeObject:
//                    case FLDataTypePoint:
//                    case FLDataTypeRect:
//                    case FLDataTypeSize:
//                    case FLDataTypeValue:					
//                        type = @"FLDatabaseTypeObject";
//                        break;
//                        
//                    case FLDataTypeURL:    
//                    case FLDataTypeString:
//                        type = @"FLDatabaseTypeText";
//                        break;
//                    
//                    case FLDataTypeDate:
//                        type = @"FLDatabaseTypeDate";
//                        break;	
//                        
//                    case FLDataTypeUnknown:
//                        FLAssertFailedWithComment(@"unknown type");
//                        break;
//                }
            
            
                [builder appendLineWithFormat:@"[s_table addColumn:[FLDatabaseColumn databaseColumnWithName:@\"%@\" columnType:%@ columnConstraints:%@]];",
                    prop.name,
                    type,
                    constraintsStr];
            
            
                if(prop.storageOptions.isIndexed) {
                    if(prop.storageOptions.isUnique) {
                        [builder appendLineWithFormat:@"[s_table addIndex:[FLDatabaseIndex databaseIndex:@\"%@\" indexProperties:FLDatabaseColumnIndexPropertyUnique]];",
                            prop.name];
                    }
                    else {
                        [builder appendLineWithFormat:@"[s_table addIndex:[FLDatabaseIndex databaseIndex:@\"%@\" indexProperties:FLDatabaseColumnIndexPropertyNone]];",
                            prop.name];
                    }
                }
            }
        }

    }]; // end of dispatch once block

	[builder appendLine:@"});"];
	[builder appendLine:@"return s_table;"];
	method.code.lines = [builder string];

	[object.methods addObject:method];
}

- (void) addClassInitializerToObject:(FLCodeObject*) object {
	
    FLCodeMethod* method = [FLCodeMethod method];
	
	NSString* prefix = self.project.generatorOptions.typePrefix;
	if(FLStringIsNotEmpty(prefix) && [object.typeName hasPrefix:prefix]) {
    
		method.name = [object.typeName substringFromIndex:prefix.length];
	}
	else {
		method.name = object.typeName;
        
	}

	method.name = [method.name stringWithLowercaseFirstLetter_fl];
	method.isPrivate = [NSNumber numberWithBool:NO];
	method.isStatic = [NSNumber numberWithBool:YES];
	method.returnType = object.typeName;
    
	[object.methods addUniqueObject:method];
	
	method.code.lines = @"return FLAutorelease([[[self class] alloc] init]);";
}

- (void) addObjectProperty:(FLCodeProperty*) property
                 forObject:(FLCodeObject*) object
             newProperties:(NSMutableArray*) newProperties
         storageProperties:(NSMutableDictionary*) storageProperties
                  {

//	if(	!property.isImmutable && 
//		![self willLazyCreate:property] &&
//		[self isValueProperty:property]) {
//		
//        FLConfirmStringIsNotEmpty(property.name);
//		FLConfirmStringIsNotEmpty(property.type);
//		FLConfirmStringIsNotEmpty(property.memberName);
//		FLConfirmStringIsNotEmpty(property.typeUnmodified);
//		
//		FLCodeProperty* newProp = [property copy];
//		newProp.getter = nil;
//		newProp.setter = nil;
//		newProp.name = [NSString stringWithFormat:@"%@Object", property.name];
//		newProp.canLazyCreate = [NSNumber numberWithBool:NO];
//		newProp.defaultValue = nil;
//		
//		[newProperties addUniqueObject:newProp];
//		[storageProperties setObjectOrFail:newProp forKey:property.name];
//		
//	}
//	else {
//		[storageProperties setObjectOrFail:property forKey:property.name];
//	}
}

//- (void) configureValueProperty:(FLCodeProperty*) prop forObject:(FLCodeObject*) object {
//	FLConfirmStringIsNotEmpty(prop.typeUnmodified);
//		
//	FLConfirmStringIsNotEmptyWithComment(prop.name, @"property needs a name");
//	FLConfirmStringIsNotEmptyWithComment(prop.type, @"property needs a type");
//
//	FLCodeDataType* type = [FLCodeDataType typeFromObjcString:prop.typeUnmodified];
//	prop.type = [type objcTypeString]; // FLObjCTypeStringFromDataType(typeId);
//	prop.hasCustomCode = [NSNumber numberWithBool:YES];
//
//	NSString* valueString = nil;
//	NSString* initString = nil; 
//
//// TODO: rewrite me
//
////	switch(typeId) {
////		case FLDataTypeURL:
////        case FLDataTypeColor:
////        case FLDataTypeObject:
////		case FLDataTypeString:
////		case FLDataTypeDate:
////		case FLDataTypeData:
////			FLConfirmationFailureWithComment(@"trying to generate object as value property");
////			break;
////	
////		case FLDataTypeBool:
////			valueString = @"boolValue";
////			initString = @"[NSNumber numberWithBool:value]";
////			break;
////		
////		case FLDataTypeShort:
////			valueString = @"shortValue";
////			initString = @"[NSNumber numberWithShort:value]";
////			break;
////		
////		case FLDataTypeUnsignedShort:
////			valueString = @"shortValue";
////			initString = @"[NSNumber numberWithUnsignedShort:value]";
////			break;
////		
////		case FLDataTypeNSInteger:
////			valueString = @"integerValue";
////			initString = @"[NSNumber numberWithInteger:value]";
////			break;
////		
////		case FLDataTypeNSUInteger:
////			valueString = @"unsignedIntegerValue";
////			initString = @"[NSNumber numberWithUnsignedInteger:value]";
////			break;
////							
////		case FLDataTypeEnum:
////			valueString = @"intValue";
////			initString = @"[NSNumber numberWithInt:value]";
////			break;
////		
////		case FLDataTypeInteger:
////			valueString = @"intValue";
////			initString = @"[NSNumber numberWithInt:value]";
////			break;
////		
////		case FLDataTypeUnsignedInteger:
////			valueString = @"unsignedIntValue";
////			initString = @"[NSNumber numberWithUnsignedInt:value]";
////			break;
////
////		case FLDataTypeChar:
////			valueString = @"charValue";
////			initString = @"[NSNumber numberWithChar:value]";
////			break;
////			
////		case FLDataTypeUnsignedChar:
////			valueString = @"unsignedCharValue";
////			initString = @"[NSNumber numberWithUnsignedChar:value]";
////			break;
////
////		case FLDataTypeLong:
////			valueString = @"longValue";
////			initString = @"[NSNumber numberWithLong:value]";
////			break;
////			
////		case FLDataTypeUnsignedLong:
////			 valueString = @"unsignedLongValue";
////			initString = @"[NSNumber numberWithUnsignedLong:value]";
////			break;
////	   case FLDataTypeFloat:
////			valueString = @"floatValue";
////			initString = @"[NSNumber numberWithFloat:value]";
////			break;
////		case FLDataTypeDouble:
////			 valueString = @"doubleValue";
////			initString = @"[NSNumber numberWithDouble:value]";
////			break;
////	   case FLDataTypeUnsignedLongLong:
////			valueString = @"unsignedLongLongValue";
////			initString = @"[NSNumber numberWithUnsignedLongLong:value]";
////			break;
////		case FLDataTypeLongLong:
////			valueString = @"longLongValue";
////			initString = @"[NSNumber numberWithLongLong:value]";
////			break;
////			
////		case FLDataTypePoint:
////			valueString = @"CGPointValue";
////			initString = @"[NSValue valueWithCGPoint:value]";
////			break;
////		case FLDataTypeRect:
////			valueString = @"CGRectValue";
////			initString = @"[NSValue valueWithCGRect:value]";
////			break;
////
////		case FLDataTypeSize:
////			valueString = @"CGSizeValue";
////			initString = @"[NSValue valueWithCGSize:value]";
////			break;
////
////        case FLDataTypeValue:
////			FLConfirmationFailureWithComment(@"not sure how to generate a NSValue for value property");
////			break;			  
////	
////		case FLDataTypeUnknown:
////			FLConfirmationFailureWithComment(@"unknown type");
////			break;
////
////	}
//	
//	prop.getter.code.lines = [NSString stringWithFormat:@"return [self.%@ %@];", prop.name, valueString];
//	
//	FLCodeVariable* p1 = [FLCodeVariable variable];
//	p1.name = @"value";
//	p1.typeName = prop.type; 
//	[prop.setter.parameters addUniqueObject:p1];
//
//	FLPrettyString* builder = [FLPrettyString prettyString];
//	[builder appendLineWithFormat:@"self.%@ = %@;", prop.name, initString];
//	prop.setter.code.lines = [builder string];
//	
//	prop.name = [NSString stringWithFormat:@"%@Value", prop.name];
//}

- (FLCodeProperty*) createEnumProperty:(FLCodeProperty*) prop
                             forObject:(FLCodeObject*) codeObject
                          withEnumType:(FLCodeEnumType*) enumType {

	FLCodeProperty* newProperty = [FLCodeProperty property];
	newProperty.name = [NSString stringWithFormat:@"%@Value", prop.name];
	newProperty.type = [self prefixedTypeName:prop.type];
	newProperty.comment = [NSString stringWithFormat:@"This sets/gets single enum (stored as string) as value. It uses [%@ instance] to lookup enum", [self enumLookupObjectName]];
    
// configure setter	   
	FLCodeVariable* parameter = [FLCodeVariable variable];
	parameter.name = @"inEnumValue";
	parameter.typeName = newProperty.type;
	[newProperty.setter.parameters addObject:parameter];
	
	NSString* typeName = [self prefixedTypeName:parameter.typeName];
		
	newProperty.setter.code.lines = [NSString stringWithFormat:@"self.%@ = [[%@ instance] %@:inEnumValue];", prop.name, 
		[self enumLookupObjectName],
		[self toStringFromEnumFunctionName:typeName]];
	
// configure getter	   
	newProperty.getter.code.lines = [NSString stringWithFormat:@"return [[%@ instance] %@:self.%@];", [self enumLookupObjectName],
		[self toEnumFromStringFunctionName:typeName], prop.name];
	
	return newProperty;
}

- (FLCodeProperty*) createEnumsProperty:(FLCodeProperty*) prop
                              forObject:(FLCodeObject*) object 
                           withEnumType:(FLCodeEnumType*) enumType {

	FLCodeProperty* newProperty = [FLCodeProperty property];
	newProperty.name = [NSString stringWithFormat:@"%@Values", prop.name];
	newProperty.type = @"NSSet";
	newProperty.comment = [NSString stringWithFormat:@"This sets/gets enum mask (stored/parsed as comma delimited string) as a NSSet. It uses [%@ instance] to lookup enums.", [self enumLookupObjectName]];
	
// configure setter	   
	FLCodeVariable* parameter = [FLCodeVariable variable];
	parameter.name = @"values";
	parameter.typeName = @"NSSet";
	[newProperty.setter.parameters addObject:parameter];
	
//	NSString* typeName = [self.self.project prefixedTypeName:parameter.typeName];
		
	newProperty.setter.code.lines = [NSString stringWithFormat:@"self.%@ = [[%@ instance] stringFromEnumSet:values];", prop.name, 
		[self enumLookupObjectName]];
	
// configure getter	   
	newProperty.getter.code.lines = [NSString stringWithFormat:@"return [[%@ instance] enumsFromString:self.%@];", 
        [self enumLookupObjectName],
		prop.name];
	
	return newProperty;
}

- (void) configIsEnumProperty:(FLCodeProperty*) prop {

// configure setter	 
	FLCodeVariable* parameter = [FLCodeVariable variable];
	parameter.name = @"inEnumValue";
	parameter.typeName = prop.typeUnmodified;
	[prop.setter.parameters addObject:parameter];
	
	FLPrettyString* builder = [FLPrettyString prettyString];
	[builder appendLineWithFormat:@"FLRelease(%@);", prop.memberName];
	[builder appendLineWithFormat:@"%@ = [NSNumber numberWithInt:inEnumValue];", prop.memberName];
	prop.setter.code.lines = [builder string];
	
// configure getter	   
	prop.getter.code.lines = [NSString stringWithFormat:@"return (%@) [%@ intValue];", prop.typeUnmodified, prop.memberName];
}


- (void) addCopySelfToMethodToObject:(FLCodeObject*) object 
                   storageProperties:(NSMutableDictionary*) storageProperties  {
                   
	FLCodeMethod* method = [FLCodeMethod method];
	method.name = @"copySelfTo";
	method.isPrivate = [NSNumber numberWithBool:YES];
	method.isStatic = [NSNumber numberWithBool:NO];
	[object.methods addUniqueObject:method];
    
	FLCodeVariable* parameter = [FLCodeVariable variable];
	parameter.name = @"object";
	parameter.typeName = @"id";
	[method.parameters addObject:parameter];

	FLPrettyString* builder = [FLPrettyString prettyString];
	[builder appendLine:@"[super copySelfTo:object];"];
	
	for(FLCodeProperty* prop in storageProperties.objectEnumerator) {	
		if(	!prop.isStatic && 
			!prop.isImmutable) {
			[builder appendLineWithFormat:@"((%@*)object).%@ = FLCopyOrRetainObject(%@);", object.typeName, [self getterNameForProperty:prop], prop.memberName];
		}
	}

	method.code.lines = [builder string];
}

- (void) addCopyMethodToObject:(FLCodeObject*) object {
	FLCodeMethod* method = [FLCodeMethod method];
	method.name = @"copyWithZone";
	method.isPrivate = [NSNumber numberWithBool:YES];
	method.isStatic = [NSNumber numberWithBool:NO];
	method.returnType = @"id";
	[object.methods addUniqueObject:method];
	
	FLCodeVariable* parameter = [FLCodeVariable variable];
	parameter.name = @"zone";
	parameter.typeName = @"NSZone";
	[method.parameters addObject:parameter];
	
	FLPrettyString* builder = [FLPrettyString prettyString];
	[builder appendLine:@"id outObject = [[[self class] alloc] init];"];
	[builder appendLine:@"[self copySelfTo:outObject];"];
	[builder appendLine:@"return outObject;"];
	method.code.lines = [builder string];
}

- (void) addMemberDataToObject:(FLCodeObject*) object forProperty:(FLCodeProperty*) property {
	if(!property.hasCustomCode && !property.isImmutable) {	
       	[object.members addObject:[property createVariableForProperty]];
    }
} 

//- (void) configureProperty:(FLCodeProperty*) prop
//                 forObject:(FLCodeObject*) object
//         storageProperties:(NSMutableDictionary*) storageProperties {
//	
//    FLCodeObjectCategory* category = [self categoryByName:@"ValueProperties" forObject:object];
//
////	FLMergeObjects(prop.options, self.propertyOptions, FLMergeModeSourceWins);
//	if(!prop.canLazyCreate) {
//		prop.canLazyCreate = object.canLazyCreate;
//	}
//	
//	if(!prop.isWildcardArray) {
//		prop.isWildcardArray = object.isWildcardArray;
//	}
//	//FLMergeObjects(prop.storageOptions, self.storageOptions, FLMergeModeSourceWins);
//	
//	FLConfirmStringIsNotEmpty(prop.type);
//	FLConfirmStringIsNotEmpty(prop.name);
//
//	// this wires array objects up as NSMutableArray's instead of the object type
//	for(FLCodeArray* array in self.project.arrays) {			
//		if([prop.type isEqualToString:array.name]) {
//			prop.type = @"NSMutableArray";
//			prop.arrayTypes = array.types;
//			break;
//		}
//	}
//
//	FLCodeEnumType* enumType = [self enumTypeForTypeName:prop.type];
//	if(enumType) {
//		[self addDependency:enumType.typeName forObject:object];
//		
//		[category.properties addObject:
//			[self createEnumProperty:prop forObject:object withEnumType:enumType]];
//
//		[category.properties addObject:
//			[self createEnumsProperty:prop forObject:object withEnumType:enumType]];
//		
//		prop.type = @"string";
//	    prop.enumType = enumType;
//	}
//	
//	prop.type = [FLCodeDataType convertToKnownTypeString:prop.type];
//	prop.typeUnmodified = prop.type;
//	
//	if(!prop.isImmutable) {
//		prop.type = FLObjcObjectTypeStringFromString(prop.type);
//	}
//	
//    if(FLStringIsEmpty(prop.type)) { 
//        FLThrowErrorCodeWithComment(FLErrorDomain, FLErrorCodeUnknownTypeErrorCode, @"Property %@ type can't be empty ", prop.name);
//    }
//    
//    prop.type = [self prefixedTypeNameForKnownType:prop.type];
//    
//	[self addDependency:prop.type forObject:object];
//    
//    [self addMemberDataToObject:object forProperty:prop];
//    
//	// update array types
//	for(FLCodeArrayType* type in prop.arrayTypes) {
//		if(FLStringIsEmpty(type.typeNameUnmodified)) {
//			type.typeNameUnmodified = type.typeName;
//			type.typeName = FLObjcObjectTypeStringFromString(FLConvertToKnownType(type.typeName));
//		}
//	}
//	
//	if(	!prop.isImmutable && 
//		![self isEnumProperty:prop] &&
//		[self isValueProperty:prop]) {
//		FLCodeProperty* newProp = [prop copy];
//		newProp.getter = nil;
//		newProp.setter = nil;
//		newProp.defaultValue = nil;
//		
//		[category.properties addObject:newProp];
//
////		[self configureValueProperty:newProp forObject:object];
//		
//        newProp.canLazyCreate = [NSNumber numberWithBool:NO];
//	}
//	
//	[storageProperties setObjectOrFail:prop forKey:prop.name];
//}

- (NSMutableDictionary*) configureAllPropertiesAndReturnStoragePropertyListForObject:(FLCodeObject*) object  {
	
    NSMutableDictionary* storageProperties = [NSMutableDictionary dictionary];
	for(FLCodeProperty* prop in object.properties) {
        FLAssertFailed();
    
//		[self configureProperty:prop forObject:object storageProperties:storageProperties];
		
        if([self canCreateMemberDataForProperty:prop]) {
			FLCodeObjectCategory* category = [self categoryByName:@"ObjectMembers" forObject:object];
			FLPrettyString* builder = [FLPrettyString prettyString];
				
			[builder appendLineWithFormat:@"if(!%@) {", prop.memberName];

            [builder indent:^{
                [builder appendLineWithFormat:@"%@ = [[%@ alloc] init];", prop.memberName, FLRemovePointerSplat(prop.type)];
            }];

			[builder appendLine:@"}"];

			FLCodeMethod* method = [FLCodeMethod method];
			method.name = [NSString stringWithFormat:@"create%@IfNil", [[self getterNameForProperty:prop] stringWithUppercaseFirstLetter_fl]];
			method.isStatic = NO;
			method.isPrivate = NO;
			method.code.lines = [builder string];			
			[category.methods addObject:method];
		}
				
		if([self willLazyCreate:prop]) {
		
			FLCodeObjectCategory* category = [self categoryByName:@"ObjectMembers" forObject:object];

			FLPrettyString* builder = [FLPrettyString prettyString];
				
			[builder appendLineWithFormat:@"if(!%@) {", prop.memberName];

            [builder indent: ^{
                [builder appendLineWithFormat:@"%@ = [[%@ alloc] init];", prop.memberName, FLRemovePointerSplat(prop.type)];
            }];
            
            [builder appendLine:@"}"];
			[builder appendLineWithFormat:@"return %@;", prop.memberName];
			
			prop.comment = [NSString stringWithFormat:@"Getter will create %@ if nil. Alternately, use the %@Object property, which will not lazy create it.", prop.memberName, [self getterNameForProperty:prop]];
			prop.getter.code.lines = [builder string];
			
			FLCodeProperty* newProp = [prop copy];
			newProp.comment = [NSString stringWithFormat:@"This returns %@. It does NOT create it if it's NIL.", prop.memberName]; 
			newProp.getter.code.lines = [NSString stringWithFormat:@"return %@;", newProp.memberName];
			newProp.isReadOnly = YES;
			newProp.name = [NSString stringWithFormat:@"%@Object", prop.name];
			newProp.canLazyCreate = NO;
			newProp.defaultValue = nil;
			[category.properties addObject:newProp];
		}

//		if(FLStringIsNotEmpty(prop.comment)) {
//			FLCodeComment* comment = [FLCodeComment comment];
//			comment.object = self.typeName;
//			comment.commentID = prop.name;
//			comment.comment = prop.comment;
//			[[FLCodeCodeGenerator instance].comments addObject:comment];
//		}
	}
	
	return storageProperties;
}

- (BOOL) isPropertyArrayElementType:(NSMutableDictionary*) storageProperties
	name:(NSString*) name
{
	for(NSString* key in storageProperties) {
		FLCodeProperty* prop = [storageProperties objectForKey:key];
		if(prop.arrayTypes && prop.arrayTypes.count > 0) {
			for(FLCodeArrayType* propType in prop.arrayTypes) {
				if(FLStringsAreEqual(propType.name, name)) {
					return YES;
				}
			}
		}
	}

	return NO;
}

- (NSString*) superclassNoProtocolForObject:(FLCodeObject*) object {
	NSRange range = [self.superclass rangeOfString:@"<"];
	return range.length > 0 ? [object.superclass substringToIndex:range.location] : object.superclass;
}


- (BOOL) wantsInitInitializer:(FLCodeProperty*) prop {
	return FLStringIsNotEmpty(prop.defaultValue) && !prop.isImmutable && !prop.isStatic;
}

- (void) _configInitProperty:(FLCodeProperty*) prop
                     builder:(FLPrettyString*) builder
                    
{
    if(	!prop.isStatic && 
        !prop.isImmutable && 
        FLStringIsNotEmpty(prop.defaultValue)) {
        if([self isValueProperty:prop] || [self isEnumProperty:prop]) {
            [builder appendLineWithFormat:@"self.%@Value = %@;", prop.name, prop.defaultValue];
        }
        else if(FLStringsAreEqual(prop.type, @"NSString")) {
            [builder appendLineWithFormat:@"self.%@ = @\"%@\";", prop.name, prop.defaultValue];
        }
        else {
            [builder appendLineWithFormat:@"self.%@ = %@;", prop.name, prop.defaultValue];
        }
    }
}

- (void) addInitMethodToObject:(FLCodeObject*) object
{
    FLCodeMethod* method = [FLCodeMethod method];
    method.name = @"init";
    method.returnType = @"id";
    method.isPrivate = [NSNumber numberWithBool:YES];
    
    FLPrettyString* builder = [FLPrettyString prettyString];
    [builder appendLine:@"if((self = [super init])) {"];
    [builder indent: ^{
    
        for(NSString* line in object.linesForInitMethod) {
            [builder appendLine:line];
        }
        
        for(FLCodeProperty* prop in object.properties){	
            [self _configInitProperty:prop builder:builder];
        }
        
        for(FLCodeObjectCategory* cat in object.categories) {
            for(FLCodeProperty* prop in cat.properties) {	
                [self _configInitProperty:prop  builder:builder];
            }
        }
    
    }];
    
    [builder appendLine:@"}"];
    [builder appendLine:@"return self;"];

    method.code.lines = [builder string];
    [object.methods addUniqueObject:method];
}	

- (void) addDeallocMethodToObject:(FLCodeObject*) object
{
	BOOL hasDealloc = object.deallocLines.count > 0;

	if(hasDealloc) {

		FLCodeMethod* method = [FLCodeMethod method];
		method.name = @"dealloc";
		method.isPrivate = [NSNumber numberWithBool:YES];

		FLPrettyString* builder = [FLPrettyString prettyString];
		for(NSString* line in object.deallocLines) {
			[builder appendLine:line];
		}

		method.code.lines = [builder string];
		[object.methods addUniqueObject:method];
	}
}


- (void) updateTypeNamesForObject:(FLCodeObject*) object {

    
	for(FLCodeProperty* prop in object.properties) {
        prop.type = [self prefixedTypeNameForKnownType:prop.type];

		for(FLCodeArrayType* type in prop.arrayTypes) {
            type.typeName = [self prefixedTypeNameForKnownType:type.typeName];
		}
	}
	for(FLCodeObjectCategory* cat in object.categories) {
		for(FLCodeProperty* prop in cat.properties) {
            
            prop.type = [self prefixedTypeNameForKnownType:prop.type];

			for(FLCodeArrayType* type in prop.arrayTypes) {
                type.typeName = [self prefixedTypeNameForKnownType:type.typeName];
			}
		}
	}

	for(FLCodeTypeDefinition* def in self.project.dependencies) {
        def.typeName = [self prefixedTypeNameForKnownType:def.typeName];
	}
}


- (void) addDependeciesToObject:(FLCodeObject*) object {
	
    for(FLCodeProperty* prop in object.properties) {
		[self addDependency:prop.type forObject:object];
		
		for(FLCodeArrayType* type in prop.arrayTypes) {
			[self addDependency:type.typeName forObject:object];
		}
	}
	for(FLCodeObjectCategory* cat in object.categories) {
		for(FLCodeProperty* prop in cat.properties) {
			[self addDependency:prop.type forObject:object];
			
			for(FLCodeArrayType* type in prop.arrayTypes) {
				[self addDependency:type.typeName forObject:object];
			}
		}
	}

	for(FLCodeTypeDefinition* projectDependency in self.project.dependencies) {
		[self addDependency:projectDependency.typeName forObject:object];
	}
}

NSInteger FLSortCodeProperties(FLCodeProperty* lhs, FLCodeProperty* rhs, void* state)
{
	if(lhs.isStatic && !rhs.isStatic) {
		return 1;
	}
	if(!lhs.isStatic && rhs.isStatic) {
		return -1;
	}

	return [[lhs name] compare:[rhs name]];
}

- (void) prepareToGenerateObject:(FLCodeObject*) object {

	FLConfirmStringIsNotEmptyWithComment(object.typeName, @"Object type is required");

	if(FLStringIsEmpty(object.name)) {
		object.name = object.typeName;
	}
	
	if(object.isSingleton) {
		FLCodeCodeSnippet* singleton = [FLCodeCodeSnippet codeSnippet];
		singleton.lines = [NSString stringWithFormat:@"FLSynthesizeSingleton(%@);", object.typeName];
		[object.sourceSnippets addObject:singleton];
	}
	
	if(FLStringIsEmpty(object.superclass)) {
		object.superclass = @"NSObject";
	}
	
	// configure properties
	
	NSMutableDictionary* storageProperties = [self configureAllPropertiesAndReturnStoragePropertyListForObject:object];
	for(NSString* key in storageProperties) {
		FLCodeProperty* prop = [storageProperties objectForKey:key];
	
		FLConfirmStringIsNotEmpty(key);
		FLConfirmStringIsNotEmpty(prop.name);
		FLConfirmStringIsNotEmpty(prop.type);
	   
//		if(!prop.isStatic && !prop.isImmutable ) {
//			FLConfirmStringIsNotEmptyWithComment(prop.name, @"name missing");
//			FLConfirmStringIsNotEmptyWithComment(prop.type, @"type missing");	
//			
//			// add the static key property
//			FLCodeProperty* newProp = [FLCodeProperty property];
//			newProp.name = [NSString stringWithFormat:@"%@Key", key];
//			newProp.isImmutable = [NSNumber numberWithBool:YES];
//			newProp.defaultValue = [NSString stringWithFormat:@"@\"%@\"", key];
//			newProp.type = @"NSString";
//			newProp.isStatic = [NSNumber numberWithBool:YES];
//            [object.properties addUniqueObject:newProp];
//        }
    }
	
	[self addInitMethodToObject:object];
	[self addClassInitializerToObject:object];
	[self addDeallocMethodToObject:object];

//	if([object.protocols rangeOfString:@"NSCopying"].length > 0) {
//		[self addCopyMethodToObject:object];
//		[self addCopySelfToMethodToObject:object storageProperties:storageProperties];
//	}
//
//	if([object.protocols rangeOfString:@"NSCoding"].length > 0) {
//		[self addDecodeMethodToObject:object storageProperties:storageProperties];
//		[self addEncodeMethodToObject:object storageProperties:storageProperties];
//	}
	
//	[self addIsEqualMethodToObject:object storageProperties:storageProperties];
	
//	[self addDescriberMethodToObject:object];
//	[self addObjectInflatorMethodToObject:object];
//	[self addSqlTableMethodToObject:object];
	
    for(FLCodeProperty* prop in object.properties) {
        [self prepareToGenerateProperty:prop];
    }
   
//	[object.properties sortUsingFunction:FLSortCodeProperties context:nil];
//	[object.methods sortUsingComparator:^NSComparisonResult(id lhs, id rhs) {
//    	return [[((FLCodeMethod*)lhs) name] compare:[((FLCodeMethod*)rhs) name]];
//    }];
//    

// Not sure why this is commented out.
//	  [self.members sortUsingFunction:compareNamedItems context:nil];
	
    [self updateTypeNamesForObject:object];
	[self addDependeciesToObject:object];
}

#pragma mark project

typedef struct {
    FLCodeTypeID type;
    Class class;
    __unsafe_unretained NSString* name;
    __unsafe_unretained NSString* include;
} FLTypeHeader;

- (void) addTypeHeader:(FLTypeHeader) decl {

    FLCodeTypeDefinition* type = [FLCodeTypeDefinition typeDefinition];
    type.dataTypeAsEnum = decl.type;
    
    if(FLStringIsNotEmpty(decl.name)) {
        type.typeName = decl.name;
    }
    else if(decl.class != nil) {
        type.typeName = NSStringFromClass(decl.class);
    }
    
    if(FLStringIsNotEmpty(decl.include)) {
        type.import = decl.include;
        type.importIsPrivate = NO;
    }
    
    FLConfirmStringIsNotEmptyWithComment(type.typeName, @"type is empty");

    [self addTypeDefinition:type];

}

- (void) addKnownObjCTypesToTypeDefinitions {

// TODO: load these in in a file loaded at runtime.


	FLTypeHeader s_knownTypes[] = {
// objects
		{ FLCodeDataTypeObject, [FLGuid class], nil, @"FLGuid.h" },
		{ FLCodeDataTypeObject, [NSValue class], nil, nil },
		{ FLCodeDataTypeObject, [NSDate class], nil, nil },
		{ FLCodeDataTypeObject, [NSData class], nil, nil },
		{ FLCodeDataTypeObject, [NSString class], nil, nil },
		{ FLCodeDataTypeObject, [NSNumber class], nil, nil },
		{ FLCodeDataTypeObject, [NSMutableArray class], nil, nil },
		{ FLCodeDataTypeObject, [NSArray class], nil, nil },
		{ FLCodeDataTypeObject, [NSDictionary class], nil, nil },
		{ FLCodeDataTypeObject, [NSMutableDictionary class], nil, nil },
		{ FLCodeDataTypeObject, [NSSet class], nil, nil },
		{ FLCodeDataTypeObject, [NSMutableSet class], nil, nil },
		{ FLCodeDataTypeObject, [NSCountedSet class], nil, nil },
		{ FLCodeDataTypeObject, [NSCoder class], nil, nil },
//        { FLCodeDataTypeObject, [UIColor class], nil, nil },
        { FLCodeDataTypeObject, [NSColor class], nil, nil },
        { FLCodeDataTypeObject, [NSURL class], nil, nil },

        { FLCodeDataTypeObject, [FLDatabaseTable class], nil, @"FLDatabaseTable.h" },
		{ FLCodeDataTypeObject, [FLObjectDescriber class], nil, @"FLObjectDescriber.h" },
		{ FLCodeDataTypeObject, [FLObjectInflator class], nil, @"FLObjectInflator.h" },
		{ FLCodeDataTypeObject, nil, @"NSZone", nil },

// values
		{ FLCodeDataTypeValue, nil, @"char", nil },
		{ FLCodeDataTypeValue, nil, @"unsigned char", nil },
		{ FLCodeDataTypeValue, nil, @"int",nil },
		{ FLCodeDataTypeValue, nil, @"integer", nil },
		{ FLCodeDataTypeValue, nil, @"NSInteger", nil },
		{ FLCodeDataTypeValue, nil, @"NSUInteger", nil },
		{ FLCodeDataTypeValue, nil, @"unsigned int", nil },
		{ FLCodeDataTypeValue, nil, @"UInt32", nil },
		{ FLCodeDataTypeValue, nil, @"Int32", nil },
		{ FLCodeDataTypeValue, nil, @"SInt32", nil },
		{ FLCodeDataTypeValue, nil, @"long", nil },
		{ FLCodeDataTypeValue, nil, @"unsigned long", nil },
		{ FLCodeDataTypeValue, nil, @"long long", nil },
		{ FLCodeDataTypeValue, nil, @"unsigned long long", nil },
		{ FLCodeDataTypeValue, nil, @"short", nil },
		{ FLCodeDataTypeValue, nil, @"unsigned short", nil },
		{ FLCodeDataTypeValue, nil, @"float", nil },
		{ FLCodeDataTypeValue, nil, @"decimal", nil },
		{ FLCodeDataTypeValue, nil, @"double", nil },
		{ FLCodeDataTypeValue, nil, @"BOOL", nil },
		{ FLCodeDataTypeValue, nil, @"void", nil },
		{ FLCodeDataTypeValue, nil, @"id", nil },
        { FLCodeDataTypeValue, nil, @"color", nil },
		{ FLCodeDataTypeValue, nil, @"CGPoint", nil },
		{ FLCodeDataTypeValue, nil, @"CGRect", nil },
		{ FLCodeDataTypeValue, nil, @"CGSize", nil },
        { FLCodeDataTypeValue, nil, @"NSPoint", nil },
		{ FLCodeDataTypeValue, nil, @"NSRect", nil },
		{ FLCodeDataTypeValue, nil, @"NSSize", nil },
        { FLCodeDataTypeValue, nil, @"CGPoint", nil },
        { FLCodeDataTypeValue, nil, @"CGSize", nil },
        { FLCodeDataTypeValue, nil, @"CGRect", nil },
	};
    
    
    for(int i = 0; i < FLArrayLength(s_knownTypes, FLTypeHeader); i++) {
        [self addTypeHeader:s_knownTypes[i]];
    }

//	for(int i = 0; types[i] != nil; i++) {
//		FLCodeTypeDefinition* type = [FLCodeTypeDefinition typeDefinition];
//		type.typeName = types[i];
//        type.dataTypeValue = FLCodeDataTypeValue;
//		[self.project addTypeDefinition:type];
//	}
//
//    for(int i = 0; objects[i] != nil; i++) {
//		FLCodeTypeDefinition* type = [FLCodeTypeDefinition typeDefinition];
//		
//		NSArray* split = [objects[i] componentsSeparatedByString:@","];
//		
//		type.typeName = [split objectAtIndex:0];
//		if(split.count == 2)
//		{
//			type.import = [split objectAtIndex:1];
//			type.importIsPrivateValue = YES;
//		}
//		type.dataTypeValue = FLCodeDataTypeObject;
//		[self.project addTypeDefinition:type];
//	}
}

- (void) prepareToGenerate {

    [self addPrefixToObjects:self.project.objects];

    [self addKnownObjCTypesToTypeDefinitions];

    for(FLCodeObject* obj in self.project.objects) {
        [self prepareToGenerateObject:obj];
    }

}

#pragma mark property


- (NSString*) objcInitializerForProperty:(FLCodeProperty*) property {

//    FLCodeDataType* type = [FLCodeDataType typeFromObjcString:property.type];
//    
//	if(type.isString && ![property.defaultValue hasPrefix:@"@\""]) {
//		return [NSString stringWithFormat:@"@\"%@\"", property.defaultValue];
//	}

	return property.defaultValue;
}

- (void) configureObjcSetterForProperty:(FLCodeProperty*) property {
	FLCodeVariable* parameter = [FLCodeVariable variable];
	parameter.name = @"value";
	parameter.typeName = property.type;
	[property.setter.parameters addObject:parameter];

	property.setter.code.lines = [NSString stringWithFormat:@"%@ = value;", property.memberName];
} 
  


- (void) willGenerateProperty:(FLCodeProperty*) property {
	
    FLConfirmStringIsNotEmptyWithComment(property.name, @"property has no name");
	FLConfirmStringIsNotEmptyWithComment(property.type, @"property has no type");
	
	NSString* typeString = property.type; 
   
	if(property.isImmutable) {
		if(!property.getter.hasLines) {
			property.getter.code.lines = [NSString stringWithFormat:@"return %@;", [self objcInitializerForProperty:property]];	   
		}
	}
	else if(property.isStatic) {
		BOOL setGetter = property.getter.hasLines;
		BOOL setSetter = property.setter.hasLines;
	   
		if(!setGetter && !setSetter && !property.isReadOnly) {
			FLConfirmStringIsNotEmptyWithComment(property.memberName, @"property has no member name");

			property.getter.code.lines = [NSString stringWithFormat:@"return %@;", property.memberName];
			
			[self configureObjcSetterForProperty:property]; 
		
			setGetter = YES;
			setSetter = YES;
		}
		
		if(!setGetter) {
			FLConfirmStringIsNotEmptyWithComment(property.memberName, @"property has no member name");
			property.getter.code.lines = [NSString stringWithFormat:@"return %@;", property.memberName];
		}
		
		if(!setSetter && !property.isReadOnly) {
			FLConfirmStringIsNotEmptyWithComment(property.memberName, @"property has no member name");
			[self configureObjcSetterForProperty:property]; 
		}
	}
	
	property.getter.name = [self getterNameForProperty:property];
	property.getter.isPrivate = [NSNumber numberWithBool:property.isPrivate || property.isImmutable];
	property.getter.returnType = typeString;
	property.getter.isStatic = property.isStatic;
	property.getter.comment = property.comment;

    property.setter.name = [self setterNameForProperty:property];
    property.setter.isPrivate = [NSNumber numberWithBool:property.isPrivate || property.isImmutable];
    property.setter.isStatic = property.isStatic;
}


@end


#endif