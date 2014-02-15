//
//  FLTestCase_Internal.h
//  Pods
//
//  Created by Mike Fullerton on 2/15/14.
//
//

#import "FLTestCase.h"

@interface FLTestCase ()

// optional overrides
- (void) prepareTestCase;
- (void) finishTestCase;

// actually run the test, this calls prepareTestCase then finishTestCase
- (void) performTestCase;

@end
