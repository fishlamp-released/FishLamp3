//
//  FLModelObject.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 4/21/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLModelObject.h"
#import "FLObjectDescriber.h"
#import "FLObjectChangeTracker.h"

@implementation NSObject (FLModelObject) 

+ (BOOL) isModelObject {
    return NO;
}

- (BOOL) isModelObject {
    return [[self class] isModelObject];
}

- (FLObjectChangeTracker*) changeTracker {
    return nil;
}

@end

@implementation FLModelObject 
FLSynthesizeModelObjectMethods();

- (void)dealloc {
    _changeTracker.modelObject = nil;
    
#if FL_MRC
	[_changeTracker release];
	[super dealloc];
#endif
}

- (void) prettyDescription:(id<FLStringFormatter>) string {
    FLObjectDescriber* typeDesc = [self objectDescriber];
    FLAssertNotNil(typeDesc);
    
    for(FLPropertyDescriber* property in [typeDesc.properties objectEnumerator]) {
        id value = [self valueForKey:property.propertyName];
        
        if(value) {
            [string appendLineWithFormat:@"%@ = %@", property.propertyName, [value description]];
        }
    }
}

- (NSString*) description {
    return [self prettyDescription];
}

- (void) setChangeTracker:(FLObjectChangeTracker*) changeTracker {
    FLSetObjectWithRetain(_changeTracker, changeTracker);
}

- (FLObjectChangeTracker*) changeTracker {
    return _changeTracker;
}


@end

id FLModelObjectCopy(id object, Class classOrNil) {
    Class theClass = classOrNil ? classOrNil : [object class];

    FLObjectDescriber* typeDesc = [theClass objectDescriber];
    FLAssertNotNil(typeDesc);
    
    id copy = [[theClass alloc] init];
    for(FLPropertyDescriber* type in [[typeDesc properties] objectEnumerator]) {
        [copy setValue:FLCopyOrRetainObject([object valueForKey:type.propertyName]) forKey:type.propertyName];
    }
    return copy;
}

void FLModelObjectDecode(id object, NSCoder* aCoder) {
    FLObjectDescriber* typeDesc = [[object class] objectDescriber];
    FLAssertNotNil(typeDesc);
    
    for(FLPropertyDescriber* type in [[typeDesc properties] objectEnumerator]) {
        [object setValue:[aCoder decodeObjectForKey:type.propertyName] forKey:type.propertyName];
    }
}

void FLModelObjectEncode(id object, NSCoder* aCoder) {
    FLObjectDescriber* typeDesc = [[object class] objectDescriber];
    FLAssertNotNil(typeDesc);
    
    for(FLPropertyDescriber* type in [[typeDesc properties] objectEnumerator]) {
        id value = [object valueForKey:type.propertyName];
        if(value) {
            [aCoder encodeObject:value forKey:type.propertyName];
        }
    }
}


//typedef void (*CompareCallback) (id, id, FLMergeMode, NSArray* arrayItemTypes); 
//
//void _FLMergeListsOfObjects(NSMutableArray* dest, 
//                            NSArray* src, 
//                            FLMergeMode mergeMode, 
//                            NSArray* arrayItemTypes,
//                            CompareCallback handleEqual) {
//	
//    for(NSInteger i = (NSInteger) src.count - 1; i >= 0; i--) {	
//		id outer = [src objectAtIndex:i];
//		bool foundIt = NO;
//		for(NSInteger j = (NSInteger) dest.count - 1; j >= 0; j--) {
//			id inner = [dest objectAtIndex:j];
//			if([inner isEqual:outer]) {	
//				handleEqual(inner, outer, mergeMode, arrayItemTypes);
//				foundIt = YES;
//				break;
//			}
//		}
//		if(!foundIt) {
//			[dest addObject:outer];
//		}
//	}
//}
//
//void FLEqualObjectHandler(id inner, id outer, FLMergeMode mergeMode, NSArray* arrayItemTypes) {
//	FLMergeObjects(inner, outer, mergeMode); 
//}
//
//void FLEqualValueHandler(id inner, id outer, FLMergeMode mergeMode, NSArray* arrayItemTypes) {
//	// already equal, so nothing to do.
//}
//
//void FLEqualMultiObjectHandler(id inner, id outer, FLMergeMode mergeMode, NSArray* arrayItemTypes) {
//	for(FLObjectDescriber* desc in arrayItemTypes) {
//		if([outer isKindOfClass:desc.actualClass]) {
//			FLMergeObjects(inner, outer, mergeMode); 
//			break;
//		}
//	}
//	
//
////	FLDataTypeStruct* itemType = FLGetTypeForClass(arrayItemTypes, [outer class]);
////	if(itemType && itemType->typeID == FLDataTypeObject)
////	{
////		FLMergeObjects(inner, outer, mergeMode); 
////	}
//}

void FLMergeObjectArrays(NSMutableArray* dest, 
                         NSArray* src, 
                         FLMergeMode mergeMode, 
                         NSArray* arrayItemTypes){

    for(NSInteger i = (NSInteger) src.count - 1; i >= 0; i--) {	
		id outer = [src objectAtIndex:i];
		bool foundIt = NO;
		for(NSInteger j = (NSInteger) dest.count - 1; j >= 0; j--) {
			id inner = [dest objectAtIndex:j];
			if([inner isEqual:outer]) {	
                
                for(FLObjectDescriber* desc in arrayItemTypes) {
                    if([outer isKindOfClass:desc.objectClass]) {
                        FLMergeObjects(inner, outer, mergeMode); 
                        foundIt = YES;
				        break;
                    }
                }
                
                break;
			}
		}
		if(!foundIt) {
			[dest addObject:outer];
		}
	}



//	if(arrayItemTypes.count) {
//		if([[arrayItemTypes firstObject] objectDescriber].isObjectWithObjectsubtypes) {
//			_FLMergeListsOfObjects(dest, src, mergeMode, arrayItemTypes, FLEqualObjectHandler);
//		}
//		else {
//			_FLMergeListsOfObjects(dest, src, mergeMode, arrayItemTypes, FLEqualValueHandler);
//		}
//	}
//	else {
//		_FLMergeListsOfObjects(dest, src, mergeMode, arrayItemTypes, FLEqualMultiObjectHandler);
//	}
}

void FLMergeObjects(id dest, id src, FLMergeMode mergeMode) {
	if(dest && src) {
		FLAssertWithComment([dest isKindOfClass:[src class]], @"objects are different classes");

        if(![dest isModelObject] || ![src isModelObject]) {
            return;
        }

		FLObjectDescriber* srcDescriber = [[src class] objectDescriber];
        
        for(FLPropertyDescriber* property in [[srcDescriber properties] objectEnumerator]) {
            
            NSString* srcPropName = property.propertyName;
            
			id srcObject = [src valueForKey:srcPropName];
			
            if(srcObject) {
				id destObject =	[dest valueForKey:srcPropName];
				if(!destObject) {
					[dest setValue:srcObject forKey:srcPropName];
				}
				else {
					FLPropertyDescriber* srcProp = [srcDescriber propertyForName:srcPropName];
                    
                    if(srcProp.containedTypes.count > 0) {
						FLMergeObjectArrays(destObject, srcObject, mergeMode, [srcProp containedTypes]);
					}
                    else if(![srcProp representsModelObject]) {
					   if(mergeMode == FLMergeModeSourceWins) {
							[dest setValue:srcObject forKey:srcPropName];
					   }
					}
					else {
						FLMergeObjects(destObject, srcObject, mergeMode);
					}
				}
			}
		}
	}
}