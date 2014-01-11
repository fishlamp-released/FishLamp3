//
//  FLBlockLinkedListElement.m
//  FLCore
//
//  Created by Mike Fullerton on 6/14/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLBlockLinkedListElement.h"

@implementation FLBlockLinkedListElement

@synthesize block = _block; 

+ (FLBlockLinkedListElement*) blockLinkedListElement {
    return FLAutorelease([[[self class] alloc] init]);   
}

#if FL_MRC 
- (void) dealloc {
    FLRelease(_block);
    FLSuperDealloc();
}
#endif

@end
