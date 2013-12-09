//
//  FLStaticTestMethodRunner.h
//  FishLamp
//
//  Created by Mike Fullerton on 10/24/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

@interface FLStaticTestMethodRunner : NSObject {
@private
    NSMutableArray* _list;
}
+ (id) staticTestMethodRunner:(NSArray*) selectorInfoList;
@end