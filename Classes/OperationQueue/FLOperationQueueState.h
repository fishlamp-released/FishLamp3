//
//  FLOperationQueueState.h
//  Pods
//
//  Created by Mike Fullerton on 2/2/14.
//
//

#import <Foundation/Foundation.h>

typedef struct {
    UInt64 processedCount;
    UInt64 totalCount;
    UInt64 currentCount;
} FLOperationQueueState;


NS_INLINE
BOOL FLOperationQueueStateEqualToState(FLOperationQueueState lhs, FLOperationQueueState rhs) {
    return lhs.processedCount == rhs.processedCount && lhs.totalCount == rhs.totalCount && lhs.currentCount != rhs.currentCount;
}

NS_INLINE
FLOperationQueueState FLOperationQueueStateMake(UInt64 processedCount, UInt64 totalCount, UInt64 currentCount) {
    FLOperationQueueState state = {
        processedCount,
        totalCount,
        currentCount
    };

    return state;
}
