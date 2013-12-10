//
//  FLBlockLinkedListElement.h
//  FLCore
//
//  Created by Mike Fullerton on 6/14/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//
#import "FishLampMinimum.h"

#import "FLLinkedListElement.h"


@interface FLBlockLinkedListElement : FLLinkedListElement {
@private
    dispatch_block_t _block;
}

+ (FLBlockLinkedListElement*) blockLinkedListElement;

@property (readwrite, copy, nonatomic) dispatch_block_t block;
@end

