//
//  FLObjectProxy.h
//  FishLampCore
//
//  Created by Mike Fullerton on 6/24/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FishLampObjc.h"

/**
 *  A object proxy the protocol for defining objects that represents represents another object.
 */
@protocol FLObjectProxy <NSObject>

/**
 *  Returns the represented object (a real object) or another object proxy.
 *  
 *  @return represented object or another proxy
 */
- (id) representedObject;

- (BOOL) representsObject:(id) object;

@end

