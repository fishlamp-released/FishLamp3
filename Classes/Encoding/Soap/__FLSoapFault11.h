// [Generated]
//
// This file was generated at 5/31/12 5:54 PM by Whittle ( http://whittle.greentongue.com/ ). DO NOT MODIFY!!
//
// __FLSoapFault11.h
// Project: FishLamp
// Schema: FLGeneratedCoreObject
//
// Copywrite (C) 2012 GreenTongue Software, LLC. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLModelObject.h"

// --------------------------------------------------------------------
// FLSoapFault11
// --------------------------------------------------------------------
@interface FLSoapFault11 : FLModelObject { 
@private
    NSString* __faultcode;
    NSString* __faultstring;
    NSString* __faultactor;
    NSString* __detail;
} 

@property (readwrite, strong, nonatomic) NSString* detail;
@property (readwrite, strong, nonatomic) NSString* faultactor;
@property (readwrite, strong, nonatomic) NSString* faultcode;
@property (readwrite, strong, nonatomic) NSString* faultstring;

+ (FLSoapFault11*) soapFault11; 

@end


// [/Generated]
