//
//  FLDictionaryProperties.h
//  FishLamp
//
//  Created by Mike Fullerton on 12/26/13.
//
//

#import <Foundation/Foundation.h>

#define FLSynthesizeDictionaryGetterProperty(__GETTER__, __TYPE__, __KEY__, __DICTIONARY__) \
    - (__TYPE__) __GETTER__ { \
        return [__DICTIONARY__ objectForKey:__KEY__]; \
    } 

#define FLSynthesizeDictionaryProperty(__GETTER__, __SETTER__, __TYPE__, __KEY__, __DICTIONARY__) \
    - (__TYPE__) __GETTER__ { \
        return [__DICTIONARY__ objectForKey:__KEY__]; \
    } \
    - (void) __SETTER__:(__TYPE__) object { \
        if(object) [__DICTIONARY__ setObject:object forKey:__KEY__]; \
        else [__DICTIONARY__ removeObjectForKey:__KEY__]; \
    }


