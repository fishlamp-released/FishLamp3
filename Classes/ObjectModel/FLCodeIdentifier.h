//
//  FLCodeIdentifier.h
//  CodeGenerator
//
//  Created by Mike Fullerton on 5/11/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FishLampCore.h"
#import "FLGenerated.h"

@interface FLCodeIdentifier : NSObject<NSCopying, FLGenerated> {
@private
    NSString* _original;
    NSString* _prefix;
    NSString* _suffix;
}

@property (readonly, strong, nonatomic) NSString* original;
@property (readonly, strong, nonatomic) NSString* identifier;
@property (readonly, strong, nonatomic) NSString* prefix;
@property (readonly, strong, nonatomic) NSString* suffix;

- (id) initWithIdentifierName:(NSString*) name prefix:(NSString*) prefix suffix:(NSString*) suffix;


- (id) copyWithNewName:(NSString*) newName;

@end

