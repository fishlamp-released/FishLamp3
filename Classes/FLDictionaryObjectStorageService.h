//
//  FLDictionaryObjectStorageService.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 3/19/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLObjectStorage.h"
#import "FLStorageService.h"

@interface FLDictionaryObjectStorageService : FLStorageService {
@private
    NSMutableDictionary* _objectStorage;
}

+ (id) dictionaryObjectStorageService;
@end
