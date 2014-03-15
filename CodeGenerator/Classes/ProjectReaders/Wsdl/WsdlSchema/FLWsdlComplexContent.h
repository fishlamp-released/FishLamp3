// 
// FLWsdlComplexContent.h
// 
// DO NOT MODIFY!! Modifications will be overwritten.
// Generated by: Mike Fullerton @ 6/2/13 5:36 PM with PackMule (3.0.0.100)
// 
// Project: FishLamp CodeWriter WSDL Interpreter
// Schema: FLWsdlObjects
// 
// Copyright 2013 (c) GreenTongue Software, LLC
// 

#import "FLModelObject.h"

@class FLWsdlRestrictionArray;
@class FLWsdlExtension;

@interface FLWsdlComplexContent : FLModelObject {
@private
    NSString* _mixed;
    FLWsdlExtension* _extension;
    FLWsdlRestrictionArray* _restriction;
}

@property (readwrite, strong, nonatomic) FLWsdlExtension* extension;
@property (readwrite, strong, nonatomic) NSString* mixed;
@property (readwrite, strong, nonatomic) FLWsdlRestrictionArray* restriction;

+ (FLWsdlComplexContent*) wsdlComplexContent;

@end
