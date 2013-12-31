//
//	FLSoapError.h
//	FishLamp
//
//	Created by Mike Fullerton on 12/20/09.
//	Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//
#import "FishLampCore.h"
#import "FishLampCoreErrorDomain.h"
#import "FLSoapFault11.h"
#import "FLErrorDomainInfo.h"
#import "NSError+FishLamp.h"

#define FLSoapFaultErrorDomain @"com.fishlamp.soap"
#define FLUnderlyingSoapFaultKey @"FLUnderlyingSoapFaultKey"

enum {
    FLSoapFaultErrorCode = 1
};

@interface NSError (FLSoapExtras) 

@property (readonly, strong, nonatomic) FLSoapFault11* soapFault;

+ (id) errorWithSoapFault:(FLSoapFault11*) fault;
- (id) initWithSoapFault:(FLSoapFault11*) fault;

@end
