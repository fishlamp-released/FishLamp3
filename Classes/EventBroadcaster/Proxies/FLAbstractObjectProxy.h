//
//  FLAbstractObjectProxy.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 6/24/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FishLampCore.h"
#import "FLObjectProxy.h"

/**
 *  This is an object (proxy) that represents another object (represented object).
 *  This is a base class.
 *
 *  The important takeaway here is the methods invoked on the proxy will be performed by the represented object IF and only IF the represented object responds to that protocol.
 */
@interface FLAbstractObjectProxy : NSProxy<FLObjectProxy, NSCopying>

/**
 *  Required override.
 *  
 *  @return represented object or another proxy.
 */
- (id) containedObject;

/**
 *  this finds the actual represented object - e.g. walks the chain through all the proxies unil it finds it.
 *
 *  @return actual represented object
 */
- (id) representedObject;

@end
