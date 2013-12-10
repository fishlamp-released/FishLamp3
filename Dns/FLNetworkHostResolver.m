//
//  FLNetworkHostResolverStream.m
//  FLCore
//
//  Created by Mike Fullerton on 11/10/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLNetworkHostResolver.h"
#import "FLNetworkHost.h"
#import "FLFinisher.h"
#import "FLNetworkHost.h"
#import "NSError+FLNetworkStream.h"
#import "FLNetworkStream_Internal.h"

@interface FLNetworkHostResolver ()
@property (readwrite, strong) FLNetworkHost* networkHost;
@property (readwrite, strong) FLFinisher* finisher;
- (void) cancelRunLoop;
@end

@implementation FLNetworkHostResolver

@synthesize networkHost = _networkHost;
@synthesize finisher = _finisher;

- (id) init {
    self = [super init];
    if(self) {
    }
    
    return self;
}

- (void) dealloc {
    [self cancelRunLoop];
    
#if FL_MRC
    [_finisher release];
    [_networkHost release];
    [super dealloc];
#endif
}

+ (id) networkHostResolver {
    return FLAutorelease([[[self class] alloc] init]);
}

- (void) resolutionCallback:(CFHostRef) theHost
                   typeInfo:(CFHostInfoType) typeInfo
                      error:(const CFStreamError*) error {
    
    [self touchTimeoutTimestamp];
    
    FLAssert(self.networkHost.hostRef == theHost);
    FLAssert(self.networkHost.hostInfoType == typeInfo);
    
    if(error && error->domain != 0 && error->error != 0) {
        [self closeWithResult:FLCreateErrorFromStreamError(error)];
    }
    else {
        self.networkHost.resolved = YES;
        [self closeWithResult:self.networkHost];
    }
    
}

static void HostResolutionCallback(CFHostRef theHost, CFHostInfoType typeInfo, const CFStreamError *error, void *info) {
    FLNetworkHostResolver* resolver = FLBridge(id, info);

    FLAssertIsKindOfClass(resolver, FLNetworkHostResolver);
    [resolver resolutionCallback:theHost typeInfo:typeInfo error:error];
}

- (void) cancelRunLoop {
    if(self.isOpen) {
        CFHostRef host = self.networkHost.hostRef;
        if(host) {
            /*BOOL success = */ CFHostSetClient(host, NULL, NULL);
            CFHostUnscheduleFromRunLoop(host, [[self.eventHandler runLoop] getCFRunLoop], FLBridge(void*,self.eventHandler.runLoopMode));
            CFHostCancelInfoResolution(host, self.networkHost.hostInfoType);
        }
    }
}

- (void) closeWithResult:(id) result {
    [self cancelRunLoop];
    [self.finisher setFinishedWithResult:result];
    self.finisher = nil;
    self.networkHost = nil;
}

- (id) resolveHostSynchronously:(FLNetworkHost*) host {
    id result = [[self startResolvingHost:host completion:nil] waitUntilFinished];
    FLThrowIfError(result);
    return result;
}

- (FLPromise*) startResolvingHost:(FLNetworkHost*) host completion:(fl_completion_block_t) completion {

    self.finisher = [FLFinisher finisherWithBlock:completion];
    
    FLAssertWithComment(!self.isOpen, @"already running");
    
    self.networkHost = host;
    
    CFHostClientContext context = { 0, FLBridge(void*, self), NULL, NULL, NULL };
  
    CFHostRef cfhost = self.networkHost.hostRef;
    FLAssertIsNotNilWithComment(cfhost, nil);

    if (!CFHostSetClient(cfhost, HostResolutionCallback, &context)) {
        [self closeWithResult:[NSError errorWithDomain:NSPOSIXErrorDomain code:EINVAL userInfo:nil]];
        
    }
    else {
        CFHostScheduleWithRunLoop(cfhost, [[self.eventHandler runLoop] getCFRunLoop], FLBridge(void*,self.eventHandler.runLoopMode));
        CFStreamError streamError = { 0, 0 };
        if (!CFHostStartInfoResolution(cfhost, self.networkHost.hostInfoType, &streamError) ) {
            [self closeWithResult:FLCreateErrorFromStreamError(&streamError)];
        }
    }
    return self.finisher;
}

@end
