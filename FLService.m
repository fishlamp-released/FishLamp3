//
//  FLService.m
//  FLCore
//
//  Created by Mike Fullerton on 11/2/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLService.h"

//NSString* const FLServiceDidCloseNotificationKey = @"FLServiceDidCloseNotificationKey";
//NSString* const FLServiceDidOpenNotificationKey = @"FLServiceDidOpenNotificationKey";;

@interface FLService ()
@property (readwrite, assign, nonatomic) BOOL isServiceOpen;
@end

@implementation FLService

@synthesize isServiceOpen = _isServiceOpen;

+ (id) service {
    return FLAutorelease([[[self class] alloc] init]);
}

- (BOOL) canOpenService {
    return YES;
}

- (void) openService {
    FLConfirmWithComment(!self.isServiceOpen, @"%@ service is already open", [self description]);
    self.isServiceOpen = YES;
}

- (void) closeService {
    FLConfirmWithComment(self.isServiceOpen, @"%@ service is already open", [self description]);
    self.isServiceOpen = NO;
}


//- (void) didMoveToSuperService:(id) superService {
//
//}

//- (id) rootService {
//    id superService = self.superService;
//    return superService == nil ? self : [superService rootService];
//}
//
//- (void) setSuperService:(id) superService {
//    _superService = superService;
//    [self didMoveToSuperService:_superService];
//}


@end

//void FLAtomicAddServiceToService(__strong id* ivar, FLService* newService, FLService* parentService) {
//    FLAtomicPropertySet(ivar, newService, ^{ 
//        if(*ivar) {
//            [parentService removeService:*ivar];
//        }
//        if(newService) {
//            [parentService addService:newService];
//        }
//    });
//}


