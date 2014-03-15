//
//  FLNetworkHostResolverStream.h
//  FLCore
//
//  Created by Mike Fullerton on 11/10/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLNetworkStream.h"
#import "FishLampAsync.h"
#import "FLPromisedResult.h"

@class FLNetworkHost;
@class FLFinisher;

@interface FLNetworkHostResolver : FLNetworkStream {
@private
    FLNetworkHost* _networkHost;
    FLFinisher* _finisher;
}

+ (id) networkHostResolver;

- (id) resolveHostSynchronously:(FLNetworkHost*) host;

- (FLPromise*) startResolvingHost:(FLNetworkHost*) host completion:(fl_completion_block_t) completion;

- (void) closeWithResult:(id) result;


@end
