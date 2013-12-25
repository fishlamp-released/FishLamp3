
// We have two defines so you can test either in the positive, e.g. #if FL_ARC or #if FL_MRC. 
// This is more readable than #if !FL_ARC, but either way works.
#undef FL_ARC 
#undef FL_MRC
#undef FL_DISPATCH_MRC
#undef FL_DISPATCH_ARC

#if __has_feature(objc_arc)
    #define FL_ARC 1
    #define FL_DISPATCH_ARC 1
    #import "FLObjcARC.h"
#else
    #define FL_MRC 1
    #define FL_DISPATCH_MRC 1
    #import "FLObjcMRC.h"

#endif

NS_INLINE
id _FLSetObjectWithCopy(id __strong * a, id b) {
    if(a && (*a != b)) { 
        id temp = FLAutorelease(*a);
        *a = [b copy]; 
        return temp;
    }
    
    return nil;
}

NS_INLINE
id _FLSetObjectWithMutableCopy(id __strong * a, id b) {
    if(a && (*a != b)) { 
        id temp = FLAutorelease(*a);
        *a = [b mutableCopy]; 
        return temp;
    }
    
    return nil;
}

NS_INLINE
id _FLSetObjectWithRetain(id __strong * a, id b) {
    if(a && (*a != b)) { 
        id temp = FLAutorelease(*a);
        *a = FLRetain(b); 
        return temp;
    }
    
    return nil;
}

NS_INLINE
id _FLSwap(id __strong * a, id __strong * b) {
    if(a && b) {
        id temp = *a;
        *a = *b;
        *b = temp;
        return FLAutorelease(FLRetain(temp));
    }
    
    return nil;
} 

NS_INLINE
id _FLReleaseWithNil(id __strong * obj) {
    if(obj && *obj) {
        id temp = FLAutorelease(*obj);
        *obj = nil;
        return temp;
    }
    
    return nil;
}

#define FLReleaseWithNil(__OBJ__) \
            _FLReleaseWithNil(&__OBJ__)

#define FLSetObjectWithRetain(a,b) \
            _FLSetObjectWithRetain((id*) &a, (id) b)

#define FLSetObjectWithCopy(a,b) \
            _FLSetObjectWithCopy((id*) &a, (id) b)

#define FLSetObjectWithMutableCopy(a,b) \
            _FLSetObjectWithMutableCopy((id*) &a, (id) b)

#define FLSwap(a, b) \
            _FLSwap(&a, &b)

// so you can do this:
// id oldFoo = FLSetProperty(obj.foo, newFoo);
// dupe use of __PROP__ is okay in this macro because first is getter, second is setter
#define FLSetProperty(__PROP__, __VALUE__) \
            FLRetainWithAutorelease(__PROP__); __PROP__ = __VALUE__

// remember these are PROPERTIES so each getter/setter is only called once.
// not sure how useful this actually is though.
#define FLSwapProperty(__PROP__, __VALUE__) \
        do { \
            id __PROP_TEMP__ = FLRetainWithAutorelease(__PROP__); \
            __PROP__ = __VALUE__; \
            __VALUE__ = __PROP_TEMP__; \
        } while(0)

//#define FLSafeguardBlock(__BLOCK__) do { __BLOCK__ = FLCopyWithAutorelease(__BLOCK__); } while(0)

//
// AutoreleasePool
//

#define FLAutoreleasePoolWithName(__NAME__, __VA_ARGS__) \
            FLAutoreleasePoolOpen(__NAME__) \
            __VA_ARGS__ \
            FLAutoreleasePoolClose(__NAME__)          

#define FLAutoreleasePool(__VA_ARGS__) \
            FLAutoreleasePoolOpen(pool) \
            __VA_ARGS__ \
            FLAutoreleasePoolClose(pool)

extern id FLCopyOrRetainObject(id src);

#ifndef NS_ENUM
#define NS_ENUM(_type, _name) _type _name; enum 
#endif

#if OS_OBJECT_USE_OBJC
#define FLDispatchRelease(__ITEM__)
#else
#define FLDispatchRelease(__ITEM__) \
            dispatch_release(__ITEM__)
#endif

