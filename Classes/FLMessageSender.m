//
//  FLMessageSender.m
//  Pods
//
//  Created by Mike Fullerton on 1/12/14.
//
//

#import "FLMessageSender.h"
#import "FLListener.h"

@implementation FLMessageSender

#define TRACEMSG(OBJ,SELECTOR) \

//do { \
//    id __LISTENER = [OBJ representedObject]; \
//    if([__LISTENER respondsToSelector:SELECTOR]) { \
//        FLTrace(@"%@: %@ receieved %@ FROM %@", \
//            [NSThread isMainThread] ? @"F" : @"B", \
//            NSStringFromClass([__LISTENER class]), \
//            NSStringFromSelector(SELECTOR), \
//            NSStringFromClass([self class])); \
//    } \
//    } while(0)

//    else { \
//        FLTrace(@"%@: %@ IGNORED %@ FROM %@", \
//            [NSThread isMainThread] ? @"F" : @"B", \
//            NSStringFromClass([__LISTENER class]), \
//            NSStringFromSelector(SELECTOR), \
//            NSStringFromClass([self class])); \
//    } \
} \
while(0)

- (void) sendMessage:(SEL) selector
         toListeners:(NSArray*) listeners {

    if(listeners) {
        for(FLListener* listener in listeners) {
            @try {
                TRACEMSG(listener, selector);

                [listener receiveMessage:selector];
            }
            @catch(NSException* ex) {
            }
        }
    }
}

- (void) sendMessage:(SEL) selector
          withObject:(id) object
         toListeners:(NSArray*) listeners {

    if(listeners) {
        for(FLListener* listener in listeners) {
            @try {
                TRACEMSG(listener, selector);

                [listener receiveMessage:selector
                              withObject:object];
            }
            @catch(NSException* ex) {
            }
        }
    }
}

- (void) sendMessage:(SEL) selector
          withObject:(id) object1
          withObject:(id) object2
         toListeners:(NSArray*) listeners {

    if(listeners) {
        for(FLListener* listener in listeners) {

            @try {
                TRACEMSG(listener, selector);

                [listener receiveMessage:selector
                              withObject:object1
                              withObject:object2];
            }
            @catch(NSException* ex) {
            }
        }
    }
}

- (void) sendMessage:(SEL) selector
          withObject:(id) object1
          withObject:(id) object2
          withObject:(id) object3
         toListeners:(NSArray*) listeners {

    if(listeners) {
        for(FLListener* listener in listeners) {
            @try {
                TRACEMSG(listener, selector);

                [listener receiveMessage:selector
                              withObject:object1
                              withObject:object2
                              withObject:object3];
            }
            @catch(NSException* ex) {
            }
        }
    }
}

- (void) sendMessage:(SEL) selector
          withObject:(id) object1
          withObject:(id) object2
          withObject:(id) object3
          withObject:(id) object4
         toListeners:(NSArray*) listeners {

    if(listeners) {
        for(FLListener* listener in listeners) {
            @try {
                TRACEMSG(listener, selector);

                [listener receiveMessage:selector
                              withObject:object1
                              withObject:object2
                              withObject:object3
                              withObject:object4];
            }
            @catch(NSException* ex) {
            }
        }
    }
}

@end
