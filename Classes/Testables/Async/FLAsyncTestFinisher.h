//
//  FLAsyncTestFinisher.h
//  Pods
//
//  Created by Mike Fullerton on 2/23/14.
//
//

#import <Foundation/Foundation.h>

typedef void (^FLAsyncTestFinisherBlock)(void);

@interface FLAsyncTestFinisher : NSObject 

- (void) setFinishedWithBlock:(FLAsyncTestFinisherBlock) finishBlock;
- (void) setFinished;
- (void) setFinishedWithError:(NSError*) error;

- (void) verifyAsyncResults:(FLAsyncTestFinisherBlock) block;

@end
