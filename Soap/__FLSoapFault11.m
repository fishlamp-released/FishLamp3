// [Generated]
//
// This file was generated at 5/31/12 5:54 PM by Whittle ( http://whittle.greentongue.com/ ). DO NOT MODIFY!!
//
// __FLSoapFault11.m
// Project: FishLamp
// Schema: FLGeneratedCoreObject
//
// Copywrite (C) 2012 GreenTongue Software, LLC. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLSoapFault11.h"
#import "FLObjectDescriber.h"

#import "FLDatabaseTable.h"

@implementation FLSoapFault11
@synthesize detail = __detail;
@synthesize faultactor = __faultactor;
@synthesize faultcode = __faultcode;
@synthesize faultstring = __faultstring;

- (void) dealloc {
    FLRelease(__faultcode);
    FLRelease(__faultstring);
    FLRelease(__faultactor);
    FLRelease(__detail);
    FLSuperDealloc();
}

+ (FLSoapFault11*) soapFault11 {
    return FLAutorelease([[FLSoapFault11 alloc] init]);
}

@end

// [/Generated]
