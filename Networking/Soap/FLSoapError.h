//
//	FLSoapError.h
//	FishLamp
//
//	Created by Mike Fullerton on 12/20/09.
//	Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//
#import "FishLampMinimum.h"
#import "FLErrorCodes.h"
#import "FLSoapFault11.h"
#import "FLErrorDomainInfo.h"
#import "NSError+FLExtras.h"
#import "FLNetworkErrors.h"

#define FLUnderlyingSoapFaultKey @"FLUnderlyingSoapFaultKey"

@interface NSError (FLSoapExtras) 

@property (readonly, strong, nonatomic) FLSoapFault11* soapFault;

+ (id) errorWithSoapFault:(FLSoapFault11*) fault;
- (id) initWithSoapFault:(FLSoapFault11*) fault;

@end
