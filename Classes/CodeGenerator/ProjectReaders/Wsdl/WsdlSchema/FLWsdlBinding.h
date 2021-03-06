// 
// FLWsdlBinding.h
// 
// DO NOT MODIFY!! Modifications will be overwritten.
// Generated by: Mike Fullerton @ 6/5/13 2:54 PM with PackMule (3.0.0.29)
// 
// Project: FishLamp CodeWriter WSDL Interpreter
// Schema: FLWsdlObjects
// 
// Copyright 2013 (c) GreenTongue Software, LLC
// 

#import "FLModelObject.h"

@class FLWsdlBinding;
@class FLObjectDescriber;
@class FLWsdlOperation;

@interface FLWsdlBinding : FLModelObject {
@private
    FLWsdlBinding* _binding;
    NSString* _style;
    NSString* _verb;
    NSString* _transport;
    NSString* _type;
    NSString* _name;
    NSMutableArray* _operations;
}

@property (readwrite, strong, nonatomic) FLWsdlBinding* binding;
@property (readwrite, strong, nonatomic) NSString* name;
@property (readwrite, strong, nonatomic) NSMutableArray* operations;
@property (readwrite, strong, nonatomic) NSString* style;
@property (readwrite, strong, nonatomic) NSString* transport;
@property (readwrite, strong, nonatomic) NSString* type;
@property (readwrite, strong, nonatomic) NSString* verb;

+ (FLWsdlBinding*) wsdlBinding;

@end
