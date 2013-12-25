//
//  FLCompilerWarnings.h
//  FishLampFrameworks
//
//  Created by Mike Fullerton on 8/26/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton.. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

//#ifndef FIXME_WARNINGS
//    #define FIXME_WARNINGS 1
//#endif
//
//#ifndef NOT_IMPLEMENTED_WARNINGS
//    #define NOT_IMPLEMENTED_WARNINGS 1
//#endif
//
//#ifndef BUG_WARNINGS
//    #define BUG_WARNINGS 1
//#endif

#if ALL_CODE_WARNINGS

    #ifndef TODO_WARNINGS
    #define TODO_WARNINGS 1
    #endif

    #ifndef FIXME_WARNINGS
    #define FIXME_WARNINGS 1
    #endif

    #ifndef NOT_IMPLEMENTED_WARNINGS
    #define NOT_IMPLEMENTED_WARNINGS 1
    #endif

    #ifndef BUG_WARNINGS
    #define BUG_WARNINGS 1
    #endif

#endif


#define DO_PRAGMA(x) _Pragma (#x)

#if TODO_WARNINGS
    #define TODO(x) DO_PRAGMA(message ("[BUG]: TODO: " #x))
#else
    #define TODO(x)
#endif

#if FIXME_WARNINGS
    #define FIXME(x) DO_PRAGMA(message ("[BUG]: FIXME: " #x))
#else
    #define FIXME(x)
#endif   
    
#if NOT_IMPLEMENTED_WARNINGS    
    #define NOT_IMPLEMENTED(x) DO_PRAGMA(message ("[BUG]: NOT_IMPLEMENTED: " #x))
#else     
    #define NOT_IMPLEMENTED(x)
#endif    

#if BUG_WARNINGS
    #define BUG(x) DO_PRAGMA(message ("[BUG]: " #x))
#else
    #define BUG(x)
#endif    


//
// compiler warnings
//

// HOW to turn off warnings per file in GCC
// http://gcc.gnu.org/onlinedocs/gcc/Diagnostic-Pragmas.html

// GCC Warning in case they need to be turned off per file
// http://gcc.gnu.org/onlinedocs/gcc/Warning-Options.html

// MORE ON CLANG
// http://clang.llvm.org/docs/UsersManual.html

// turn off warnings we know break fishlamp compiling.

// this prevents adding a private readwrite synthesize for readonly properties
#pragma GCC diagnostic ignored "-Wreadonly-setter-attrs"

// this warning causes use of MIN/MAX to not compile. Tried all the different GNU types. No luck.
#pragma GCC diagnostic ignored "-Wgnu"

#pragma GCC diagnostic ignored "-Wswitch-enum"

// This dissallows not const strings as params. This might be a good this.
// TODO: revisit this
#pragma GCC diagnostic ignored "-Wformat-nonliteral"

// these generate too many warnings/errors

#pragma GCC diagnostic ignored "-Wunused-parameter"

#pragma GCC diagnostic ignored "-Wsign-conversion"

#pragma GCC diagnostic ignored "-Wsign-compare"

#pragma GCC diagnostic ignored "-Wconversion"

#pragma GCC diagnostic ignored "-Wfloat-equal"

#if __MAC_10_8
    // this basically makes default: in case cause an error. I don't understand this one at all.
    #pragma GCC diagnostic ignored "-Wcovered-switch-default"

    // on the fence about this one, we use this to essentially do a down cast in someplaces. Maybe that isn't a best practice
    // TODO: revisit this
    #pragma GCC diagnostic ignored "-Woverriding-method-mismatch"
#else 
    
    #pragma GCC diagnostic ignored "-Wfloat-equal"

#endif

#if DEBUG
#pragma GCC diagnostic ignored "-Wunused-variable"
#endif
