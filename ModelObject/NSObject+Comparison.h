//
//	NSObject+Comparison.h
//	FishLamp
//
//	Created by Mike Fullerton on 3/14/11.
//	Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton.
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampMinimum.h"
#import "FLCoreFlags.h"
#import "FLCoreRequired.h"

/// @category NSObject(FLComparison)
///  An extension to NSObject to help with copying objects

@interface NSObject (FLComparison)
+ (BOOL) objectIsEqualToObject:(id) object toObject:(id) anotherObject;
@end

NS_INLINE
BOOL FLObjectsAreEqual(id lhs, id rhs) {
    return lhs == rhs || (lhs && rhs && [lhs isEqual:rhs]);
}