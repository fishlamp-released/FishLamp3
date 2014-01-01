/*
 *  FLObjcRuntime.c
 *  PackMule
 *
 *  Created by Mike Fullerton on 6/29/11.
 *  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
 *
 */

#import "FLObjcRuntime.h"
#import <stdlib.h>
#import <string.h>
#import <stdio.h>
#import "FishLampAssertions.h"
#import "FLPropertyAttributes.h"

void FLSwizzleInstanceMethod(Class c, SEL originalSelector, SEL newSelector) {
    Method origMethod = class_getInstanceMethod(c, originalSelector);
    Method newMethod = class_getInstanceMethod(c, newSelector);
    
    if(class_addMethod(c, originalSelector, method_getImplementation(newMethod), method_getTypeEncoding(newMethod))) {
        class_replaceMethod(c, newSelector, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    }
    else {
        method_exchangeImplementations(origMethod, newMethod);
    }
}

void FLSwizzleClassMethod(Class c, SEL originalSelector, SEL newSelector) {
    Method origMethod = class_getClassMethod(c, originalSelector);
    Method newMethod = class_getClassMethod(c, newSelector);
    
    if(class_addMethod(c, originalSelector, method_getImplementation(newMethod), method_getTypeEncoding(newMethod))) {
        class_replaceMethod(c, newSelector, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    }
    else {
        method_exchangeImplementations(origMethod, newMethod);
    }
}


BOOL FLRuntimeVisitEachSelectorInClass(Class aClass, FLRuntimeSelectorVisitor visitor) {

    BOOL stop = NO;
    FLRuntimeInfo info = { aClass, nil, 0, 0, class_isMetaClass(aClass) };
    
    Method* methods = class_copyMethodList(aClass, &info.total);

    for (info.index = 0; info.index < info.total; info.index++) {
        
        info.selector = method_getName(methods[info.index]);
        visitor(info, &stop);
        
        if(stop) {
            break;
        }
    }

    free(methods);
    
    return stop;
}

void FLRuntimeVisitEachSelectorInClassAndSuperclass(Class aClass, FLRuntimeSelectorVisitor visitor) {
    Class walker = aClass;
    while(walker) {
       
        BOOL stop = FLRuntimeVisitEachSelectorInClass(walker, visitor);
        if(stop) {
            walker = nil;
        }
        else {
            walker = [walker superclass];
            
            if( walker == [NSObject class]) {
                walker = nil;
            }
        }
    }
}

NSArray* FLRuntimeMethodsForClass(Class inClass, FLRuntimeFilterBlock filterOrNil) {
    __block NSMutableArray* array = nil;

    FLRuntimeSelectorVisitor selectorVisitor = ^(FLRuntimeInfo info, BOOL *stop) {
            
        BOOL passed = YES;
        if(filterOrNil) {
            passed = NO;
            filterOrNil(info, &passed, stop);
        }
        
        if(passed) {
            if(!array) {
                 array = [NSMutableArray array];
            }
        
            [array addObject:[FLSelectorInfo selectorInfoWithClass:info.class selector:info.selector]];
        }
    };

    Class walker = inClass;
    while(walker) {
       
        BOOL stop = FLRuntimeVisitEachSelectorInClass(walker, selectorVisitor);
        
        if(stop) {
            walker = nil;
        }
        else {
            walker = [walker superclass];
            
            if( walker == [NSObject class]) {
                walker = nil;
            }
        }
    }
 
    return array;

}

BOOL FLRuntimeVisitEveryClass(FLRuntimeClassVisitor visitor) {

    FLRuntimeInfo info = { nil, nil, 0, 0, NO };
    
    info.total = objc_getClassList(NULL, 0);
    
    Class *classes = (__unsafe_unretained Class*) malloc(sizeof(Class) * info.total);
    
    objc_getClassList(classes, info.total);
    
    BOOL stop = NO;
    for (info.index = 0; info.index < info.total; info.index++) {
        info.class = classes[info.index];
        info.isMetaClass = NO;
        visitor(info, &stop );
        if(stop) {
            break;
        }

        info.class = object_getClass(classes[info.index]);
        info.isMetaClass = YES;
        visitor(info, &stop );
        if(stop) {
            break;
        }
    }

    free(classes);
    
    return stop;
}


NSArray* FLRuntimeAllClassesMatchingFilter(FLRuntimeFilterBlock filter) {
    NSMutableArray* array = [NSMutableArray array];
    
    FLRuntimeSelectorVisitor selectorVisitor = ^(FLRuntimeInfo info, BOOL* stop) {
        BOOL match = NO;
        if(filter) {
            filter(info, &match, stop);
            
            if(match) {
                [array addObject:[FLSelectorInfo selectorInfoWithClass:info.class selector:info.selector]];
            }
        }
    };

    FLRuntimeVisitEveryClass(^(FLRuntimeInfo info, BOOL* stop) {
        *stop = FLRuntimeVisitEachSelectorInClass(info.class, selectorVisitor);
        });
    return array;
}

NSArray* FLRuntimeClassesImplementingInstanceMethod(SEL theMethod) {
    
    NSMutableArray* result = [NSMutableArray array];

    FLRuntimeVisitEveryClass(
        ^(FLRuntimeInfo info, BOOL* stop) {
            if(info.isMetaClass) {
                if(FLRuntimeClassRespondsToSelector(info.class, theMethod)) {
                    [result addObject:[FLSelectorInfo selectorInfoWithClass:info.class selector:theMethod]];
                }
            }
        });

    return result;
}

int FLArgumentCountForSelector(SEL sel) {

    if(!sel) return 0;

    const char* name = sel_getName(sel);
    int count = 0;
    while(*name) {
        if(*name++ == ':') {
            ++count;
        }
    }
    
    return count;
}

int FLArgumentCountForClassSelector(Class aClass, SEL selector) {

    Method method = class_getInstanceMethod(aClass, selector);
    if(!method) {
        method = class_getInstanceMethod(object_getClass(aClass), selector);
    }
    
    if(method) {
        return method_getNumberOfArguments(method) - 2;
    }
    
    FLAssertFailed(@"couldn't get argument count");
    
    return -1;
}

NSArray* FLRuntimeSubclassesForClass(Class theClass) {
	int count = objc_getClassList(NULL, 0);

    NSMutableArray* theClassNames = [NSMutableArray array];

    Class* classList = (__unsafe_unretained Class*) malloc(sizeof(Class) * count);
	
	objc_getClassList(classList, count);
 
//    const char* theClassName = class_getName(theClass);
    
	for(int i = 0; i < count; i++) {

        Class aClass = classList[i];

        if(FLRuntimeClassHasSubclass(theClass, aClass)) {
            [theClassNames addObject:aClass];
        }

//        // some things in the returned don't have classes - e.g. object_getClass returns nil
////        aClass = object_getClass(aClass);
////        if(!aClass) {
////            continue;
////        }
//    
//        // some objects don't have super classes - whatever Apple, whatever.
//        Class superClass = class_getSuperclass(aClass);
//        if(!superClass) {
//            continue;
//        }
//        
//        // okay now we have a class name for the current classes superclass - or do we?
//        const char* superClassName = class_getName(superClass);
//        if(!superClassName) {
//            continue;
//        }
//    
//        // okay fine, we do, see if the superclass is a the class we want, if so Yay. If not, whatever.
//        if(strcmp(superClassName, theClassName) == 0) {
//            [theClassNames addObject:aClass];
//        }
	}
	
	free(classList);
    
    return theClassNames;
}

BOOL FLClassConformsToProtocol(Class aClass, Protocol* aProtocol) {

    if(!aClass || !aProtocol) {
        return NO;
    }

    if(class_isMetaClass(aClass)) {
        return NO;
    }

    if(class_getSuperclass(aClass) == nil) {
        return NO;
    }

    return [aClass conformsToProtocol:aProtocol];
}

void FLRuntimeGetSelectorsInProtocol(Protocol* protocol, SEL** list, unsigned int* count) {

    objc_property_t* propertyList = protocol_copyPropertyList(protocol, count);

    *list = malloc(*count * sizeof(SEL));

    for(unsigned int i = 0; i < *count; i++) {
        FLPropertyAttributes_t attributes = FLPropertyAttributesParse(propertyList[i]);
        (*list)[i] = FLPropertyAttributesGetSelector(attributes);
    }

    if(propertyList) {
        free(propertyList);
    }
}

BOOL FLRuntimeClassHasSubclass(Class aSuperclass, Class aClass) {
    if(!aSuperclass || !aClass || aSuperclass == aClass) {
        return NO;
    }
    
    Class walker = aClass;
    while(walker) {
        walker = class_getSuperclass(walker);
        if(walker == aSuperclass) {
            return YES;
        }
    }
    return NO;
    
    
//    const char* theClassName = class_getName(aClass);
//    
//	for(int i = 0; i < count; i++) {
//
//        // some things in the returned don't have classes - e.g. object_getClass returns nil
////        aClass = object_getClass(aClass);
////        if(!aClass) {
////            continue;
////        }
//    
//        // some objects don't have super classes - whatever Apple, whatever.
//        Class superClass = class_getSuperclass(aClass);
//        if(!superClass) {
//            continue;
//        }
//        
//        // okay now we have a class name for the current classes superclass - or do we?
//        const char* superClassName = class_getName(superClass);
//        if(!superClassName) {
//            continue;
//        }
//    
//        // okay fine, we do, see if the superclass is a the class we want, if so Yay. If not, whatever.
//        if(strcmp(superClassName, theClassName) == 0) {
//            [theClassNames addObject:aClass];
//        }
//	}
//	
//	free(classList);

    
//    return [aClass isSubclassOfClass:aSuperclass];
}

BOOL FLRuntimeClassRespondsToSelector(Class aClass, SEL aSelector) {
    FLRuntimeSelectorVisitor visitor = ^(FLRuntimeInfo info, BOOL* stop) {
        if( FLSelectorsAreEqual(aSelector, info.selector)) {
            *stop = YES;
        }
    };

    Class walker = aClass;
    while(walker) {
        if(FLRuntimeVisitEachSelectorInClass(walker, visitor)) {
            return YES;
        }
        walker = class_getSuperclass(walker);
    }
  
    return NO;
}


#if DEBUG
void FLRuntimeLogMethodsForClass(Class aClass) {
    unsigned int count = 0;
    Method* methods = class_copyMethodList(aClass, &count);
    for(NSUInteger i = 0; i < count; i++) {
        NSLog(@"%@", NSStringFromSelector(method_getName(methods[i])));
    }
    NSLog(@"--- done: %@ (isMeta=%d)", NSStringFromClass(aClass), class_isMetaClass(aClass) ? 1 : 0);
    free(methods);
}
#endif


@implementation NSObject (FLObjcRuntime)

// Lookup the next implementation of the given selector after the
// default one. Returns nil if no alternate implementation is found.
- (IMP)getImplementationOf:(SEL)lookup after:(IMP)skip
{
    BOOL found = NO;
     
    Class currentClass = object_getClass(self);
    while (currentClass)
    {
        // Get the list of methods for this class
        unsigned int methodCount;
        Method *methodList = class_copyMethodList(currentClass, &methodCount);
         
        // Iterate over all methods
        unsigned int i;
        for (i = 0; i < methodCount; i++)
        {
            // Look for the selector
            if (method_getName(methodList[i]) != lookup)
            {
                continue;
            }
             
            IMP implementation = method_getImplementation(methodList[i]);
             
            // Check if this is the "skip" implementation
            if (implementation == skip)
            {
                found = YES;
            }
            else if (found)
            {
                // Return the match.
                free(methodList);
                return implementation;
            }
        }
     
        // No match found. Traverse up through super class' methods.
        free(methodList);
 
        currentClass = class_getSuperclass(currentClass);
    }
    return nil;
}
 


@end





//void FLRuntimeVisitEveryMetaClass(void (^visitor)(Class aClass, BOOL* stop)) {
//
////    NSMutableSet* processed = [NSMutableSet set];
////    __block int i = 0;
//    
//    FLRuntimeVisitEveryClass(^(Class inClass, BOOL* stop) {
//        
////        if(!class_isMetaClass(inClass)) {
////            inClass = object_getClass(inClass);
////        }
//        
//        if(!inClass) {
//            return;
//        }
//        
//        visitor(inClass, stop);
//        
////        NSString* name = NSStringFromClass(inClass);
////        if(FLStringIsNotEmpty(name)) {
////            if(![processed containsObject:name]) {
////                [processed addObject:name];
////                visitor(inClass, stop );
////            }
////            else {
////                i++;
////            }
////        }
//    });
//}

//void FLRuntimeVisitEveryInstanceClass(void (^visitor)(Class aClass, BOOL* stop)) {
//
//    FLRuntimeVisitEveryClass(^(Class inClass, BOOL* stop) {
//        if(!class_isMetaClass(inClass)) {
//            visitor(inClass, stop );
//        }
//    });
//}





//NSArray* FLRuntimeFindSubclassesForClass(Class theClass) {
//
//	int count = objc_getClassList(NULL, 0);
//
//    NSMutableArray* theClassNames = [NSMutableArray array];
//
//    Class* classList = (__unsafe_unretained Class*) malloc(sizeof(Class) * count);
//	
//	objc_getClassList(classList, count);
// 
//    const char* theClassName = class_getName(theClass);
//    
//	for(int i = 0; i < count; i++) {
//
//        Class aClass = classList[i];
//
//        // some things in the returned don't have classes - e.g. object_getClass returns nil
////        aClass = object_getClass(aClass);
////        if(!aClass) {
////            continue;
////        }
//    
//        // some objects don't have super classes - whatever Apple, whatever.
//        Class superClass = class_getSuperclass(aClass);
//        if(!superClass) {
//            continue;
//        }
//        
//        // okay now we have a class name for the current classes superclass - or do we?
//        const char* superClassName = class_getName(superClass);
//        if(!superClassName) {
//            continue;
//        }
//    
//        // okay fine, we do, see if the superclass is a the class we want, if so Yay. If not, whatever.
//        if(strcmp(superClassName, theClassName) == 0) {
//            [theClassNames addObject:aClass];
//        }
//	}
//	
//	free(classList);
//    
//    return theClassNames;
//}

//NSArray* FLRuntimeInstanceMethods(Class aClass, Class toSuperclassOrNil) {
//    
//    NSMutableArray* array = [NSMutableArray array];
//    Class walker = aClass;
//
//    while(walker) {
//       
//        FLRuntimeVisitEachSelectorInClass(walker, ^(SEL selector, BOOL *stop) {
//            [array addObject:[FLCallback callback:aClass action:selector]];
//        });
//       
//        if(!toSuperclassOrNil) {
//            walker = nil;
//        }
//        else {
//            walker = [walker superclass];
//            
//            if( walker == toSuperclassOrNil ||
//                walker == [NSObject class]) {
//                walker = nil;
//            }
//        }
//    }
// 
//    return array;
//}

//@implementation NSObject
//- (NSArray*) findInstanceMethodsByName:(BOOL (^)(NSString* name, BOOL* stop)) nameMatcher {
//    return [self findInstanceMethodsByNameStopAtSuperclass:nil
//                                               nameMatcher:nameMatcher];
//}
//
//- (NSArray*) findInstanceMethodsByNameStopAtSuperclass:(Class) superclass
//                                           nameMatcher:(BOOL (^)(NSString* name, BOOL* stop)) nameMatcher {
//
//    NSMutableArray* array = [NSMutableArray array];
//
//    NSArray* methods = FLRuntimeInstanceMethodNamesForClass([self class], superclass);
//
//    for(FLCallback* callback in methods) {
//        if(nameMatcher(NSStringFromSelector(callback.action)) {
//           [list addObject:[FLCallback callback:self action:NSSelectorFromString(methodName)]];
//        }
//    }
//    return array;
//}
//
//
//@end

// experimental

//id objc_getProperty(id self, SEL _cmd, ptrdiff_t offset, BOOL atomic);
//
//void objc_setProperty(id self, SEL _cmd, ptrdiff_t offset, id newValue, BOOL atomic, BOOL shouldCopy);
//
//void objc_copyStruct(void *dest, const void *src, ptrdiff_t size, BOOL atomic, BOOL hasStrong);
//extern NSArray* FLRuntimeFindSubclassesForClass(Class aClass);

//extern BOOL FLRuntimeClassIsSubclassOfClass(Class subclass, Class superclass);
//extern void FLRuntimeVisitEachInstanceMethodInClass(Class aClass, Class toSuperclassOrNil, FLRuntimeSelectorVisitor visitor);

/**
    @brief Copies type name from @encoded string
    for example NT@"NSMutableArray" results in NSMutableArray
    if this returns a string, call free on it.
 */
//extern char* copyTypeNameFromProperty(objc_property_t property);

//char* copyTypeNameFromProperty(objc_property_t property)
//{
//	const char* attr = property_getAttributes(property);
//	
////	printf("%s", attr);
//	
//	for(int i = 0; attr[i] != 0; i++)
//	{
//		if(attr[i] == '@')
//		{
//			if(attr[i + 1] == '\"')
//			{
//				i += 2;
//				
//				for(int j = i; attr[j] != 0; j++)
//				{
//					if(attr[j] == '\"')
//					{
//						int len = j - i;
//                        char* str = malloc(len + 1);
//                        memcpy(str, attr+i, len);
//						str[len] = 0;
//						return str;
//					}
//				}
//			}
//		}
//	
//	}
//
//	return nil;
//	
///*
//objc_property_attribute_t* attrList = property_copyAttributeList(properties[i], &attrCount);
//		for(unsigned int j = 0; j < attrCount; j++)
//		{
//			const char* value = attrList[j].value;
//			const char* name = attrList[j].name;
//
//			if(name[0] == 'T' && value[0] == '@')
//			{
//				int len = strlen(value);
//				char* className = malloc(len);
//				strncpy(className, value + 2, len - 3);
//				className[len-3] = 0;
//				
//				Class c = objc_getClass(className);
//					free(attrList);
//	
//*/
//}
//extern const char *getobjectDescriber(objc_property_t property);
//
//const char *getobjectDescriber(objc_property_t property) {
//    const char *attributes = property_getAttributes(property);
//    char buffer[1 + strlen(attributes)];
//    strcpy(buffer, attributes);
//    char *state = buffer, *attribute;
//    while ((attribute = strsep(&state, ",")) != NULL) {
//        if (attribute[0] == 'T') {
//            return (const char *)[[NSData dataWithBytes:(attribute + 3) length:strlen(attribute) - 4] bytes];
//        }
//    }
//    return "@";
//}
