//
//  NSMutableString+FishLamp.h
//  Pods
//
//  Created by Mike Fullerton on 2/18/14.
//
//

#import "FishLampRequired.h"

@interface NSMutableString (FishLamp)
- (BOOL) insertString_fl:(NSString*) substring
            beforeString:(NSString*) beforeString
     withBackwardsSearch:(BOOL) searchBackwards;

- (BOOL) insertString_fl:(NSString*) substring
             afterString:(NSString*) afterString
     withBackwardsSearch:(BOOL) searchBackwards;
@end


