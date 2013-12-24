//
//  FLOSVersion.h
//  FishLamp
//
//  Created by Mike Fullerton on 7/11/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampObjc.h"
#import "FLVersion.h"

extern FLVersion FLGetOSVersion();

#if IOS
    #define OSVersionIsAtLeast3_2() FLVersionGreaterThanEqualToVersion(FLGetOSVersion(), FLVersionMake(3,2,0,0))
    #define OSVersionIsAtLeast4_0() FLVersionGreaterThanEqualToVersion(FLGetOSVersion(), FLVersionMake(4,0,0,0))
    #define OSVersionIsAtLeast4_1() FLVersionGreaterThanEqualToVersion(FLGetOSVersion(), FLVersionMake(4,1,0,0))
    #define OSVersionIsAtLeast5_0() FLVersionGreaterThanEqualToVersion(FLGetOSVersion(), FLVersionMake(5,0,0,0))
    #define OSVersionIsAtLeast5_1() FLVersionGreaterThanEqualToVersion(FLGetOSVersion(), FLVersionMake(5,1,0,0))
    #define OSVersionIsAtLeast6_0() FLVersionGreaterThanEqualToVersion(FLGetOSVersion(), FLVersionMake(6,0,0,0))
#else
    #define OSXVersionIsAtLeast10_6() FLVersionGreaterThanEqualToVersion(FLGetOSVersion(), FLVersionMake(10,6,0,0))
    #define OSXVersionIsAtLeast10_7() FLVersionGreaterThanEqualToVersion(FLGetOSVersion(), FLVersionMake(10,7,0,0))
    #define OSXVersionIsAtLeast10_8() FLVersionGreaterThanEqualToVersion(FLGetOSVersion(), FLVersionMake(10,8,0,0))

    #define OSXVersionIs10_6() FLVersionLessThanVersion(FLGetOSVersion(), FLVersionMake(10,7,0,0))
#endif