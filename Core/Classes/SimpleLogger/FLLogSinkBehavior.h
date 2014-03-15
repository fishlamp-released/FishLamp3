//
//  FLLogSinkBehavior.h
//  Pods
//
//  Created by Mike Fullerton on 2/23/14.
//
//

#import "FishLampRequired.h"

@protocol FLLogSinkBehavior <NSObject>
@property (readonly, assign, nonatomic) BOOL outputLocation;
@property (readonly, assign, nonatomic) BOOL outputStackTrace;
@end


@interface FLLogSinkBehavior : NSObject<FLLogSinkBehavior> {
@private
    BOOL _outputLocation;
    BOOL _outputStackTrace;
}

@property (readwrite, assign, nonatomic) BOOL outputLocation;
@property (readwrite, assign, nonatomic) BOOL outputStackTrace;

+ (id) logSinkBehavior;

@end
