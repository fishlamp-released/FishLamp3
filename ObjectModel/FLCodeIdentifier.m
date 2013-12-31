//
//  FLCodeIdentifier.m
//  CodeGenerator
//
//  Created by Mike Fullerton on 5/11/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLCodeIdentifier.h"

@interface FLCodeIdentifier ()
@property (readwrite, strong, nonatomic) NSString* original;
@property (readwrite, strong, nonatomic) NSString* prefix;
@property (readwrite, strong, nonatomic) NSString* suffix;
@end

@implementation FLCodeIdentifier

@synthesize original = _original;
@synthesize prefix = _prefix;
@synthesize suffix = _suffix;

//- (id) init {	
//    return [self initWithName:@""];
//}

- (id) initWithIdentifierName:(NSString*) name  
                       prefix:(NSString*) prefix 
                       suffix:(NSString*) suffix {	
	self = [super init];
	if(self) {

        FLAssertStringIsNotEmpty(name);
        
        if(!prefix) {
            prefix = @"";
        }
        if(!suffix) {
            suffix = @"";
        }        
//        name = [name stringByDeletingPrefix_fl:prefix];
//        name = [name stringByDeletingSuffix_fl:suffix];
        self.prefix = prefix;
        self.suffix = suffix;
        self.original = name;
	}
	return self;
}

- (NSString*) identifier {
    NSString* baseName = _original;
    if(FLStringIsNotEmpty(_prefix)) {
        baseName = [baseName stringByDeletingPrefix_fl:_prefix];
    }
    if(FLStringIsNotEmpty(_suffix)) {
        baseName = [baseName stringByDeletingSuffix_fl:_suffix];
    }
    return baseName; 
    
}

- (NSString*) generatedName {
    return [NSString stringWithFormat:@"%@%@%@", _prefix, self.identifier, _suffix];
}

- (NSString*) generatedReference {
    return [self generatedName];
}

- (id) copyWithZone:(NSZone *)zone {
    FLCodeIdentifier* name = [[[self class] alloc] initWithIdentifierName:FLCopyWithAutorelease(self.original)
                                                                   prefix:FLCopyWithAutorelease(self.prefix)
                                                                   suffix:FLCopyWithAutorelease(self.suffix)];
    return name;
}

- (BOOL)isEqual:(FLCodeIdentifier*)object {
    return FLStringsAreEqual(self.generatedName, [object generatedName]);
}

- (NSUInteger)hash {
    return [self.generatedName hash];
}

#if FL_MRC
- (void) dealloc {
	[_original release];
    [_prefix release];
    [_suffix release];
    [super dealloc];
}
#endif

- (void) describeSelf:(FLPrettyString *)string {
    [string appendLineWithFormat:@"original=%@", self.original];
    [string appendLineWithFormat:@"generated=%@", self.generatedName];
}

- (NSString*) description {
    return [self prettyDescription];
}

- (id) copyWithNewName:(NSString*) newName {
    return [[[self class] alloc] initWithIdentifierName:newName prefix:self.prefix suffix:self.suffix];
}

@end
