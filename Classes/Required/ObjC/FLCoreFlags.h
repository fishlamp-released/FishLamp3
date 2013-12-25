//
//	FLCoreFlags.h
//	FishLamp
//
//	Created by Mike Fullerton on 9/15/10.
//	Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

// WARNING: don't import anything here. This file is imported by FishLamp.  This is imported by everything.

/// this sets the IOS or the MAC define

#ifdef IOS
#undef IOS
#endif

#ifdef MAC
#undef MAC
#endif

#ifdef OSX
#undef OSX
#endif

#ifdef __IPHONE_OS_VERSION_MIN_REQUIRED
    #define IOS 1
#else
    #define MAC 1
    #define OSX 1
#endif

#if DEBUG
    #define FL_SHIP_ONLY_INLINE 
#else
    #define FL_SHIP_ONLY_INLINE NS_INLINE
#endif

#ifndef DEBUG
#define RELEASE 1
#endif

#ifndef TEST
#define TEST DEBUG
#endif

#ifdef TRACE
#error TRACE is meant per file and should not be defined globally
#endif

// from NSObjectCRuntime.h
#undef FL_INT64

#if __LP64__ || (TARGET_OS_EMBEDDED && !TARGET_OS_IPHONE) || TARGET_OS_WIN32 || NS_BUILD_32_LIKE_64


#define FL_INT64 1

#endif

#if DEBUG
    #define FL_SHIP_ONLY_INLINE 
#else
    #define FL_SHIP_ONLY_INLINE NS_INLINE
#endif

#ifndef EXPERIMENTAL
#define EXPERIMENTAL DEBUG
#endif
