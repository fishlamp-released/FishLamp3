//
//  FLStackTrace_t.m
//  FishLamp
//
//  Created by Mike Fullerton on 9/3/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton.. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLStackTrace.h"
//#import "FLPrettyDescription.h"



@implementation FLStackTrace

- (NSString*) fileName {
    FLFileLocationSetFileName(&(_stackTrace.location));
    return [NSString stringWithCString:_stackTrace.location.fileName encoding:NSASCIIStringEncoding];
}

- (NSString*) filePath {
    return [NSString stringWithCString:_stackTrace.location.filePath encoding:NSASCIIStringEncoding];
}

- (NSString*) function {
    return [NSString stringWithCString:_stackTrace.location.function encoding:NSASCIIStringEncoding];
}

- (int) lineNumber {
    return _stackTrace.location.line;
}

- (id) initWithStackTrace:(FLStackTrace_t) stackTrace {
    self = [super init];
    if(self) {
        _stackTrace = stackTrace;
    }
    return self;
}

+ (FLStackTrace*) stackTraceWithException:(NSException*) exception {
    return nil;
}

+ (FLStackTrace*) stackTrace:(FLStackTrace_t) stackTrace {
    return FLAutorelease([[FLStackTrace alloc] initWithStackTrace:stackTrace]);
}

- (void) dealloc {
    FLStackTraceFree(&_stackTrace);
#if FL_MRC
    [super dealloc];
#endif
}

- (const char*) stackEntryAtIndex:(int) idx {
    return FLStackEntryAtIndex(_stackTrace.stack, idx);
}

- (FLCallStack_t) callStack {
    return _stackTrace.stack;
}

- (int) stackDepth {
    return _stackTrace.stack.depth;
}

//- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state 
//                                  objects:(id __unsafe_unretained [])buffer 
//                                    count:(NSUInteger)len {
//	
//    unsigned long currentIndex = state->state;
//    if(currentIndex >= _stackTrace.depth) {
//		return 0;
//	}
//	
//    state->state = MIN(_stackTrace.depth - 1, currentIndex + len);
//
//    NSUInteger count = state->state - currentIndex;
//
//    int bufferIndex = 0;
//    for(int i = currentIndex; i < count; i++) {
//        buffer[bufferIndex] = FLStackEntryAtIndex(_stackTrace.stack, idx);
//    }
//
//    state->itemsPtr = buffer;
//    
//    // this is an immutable object, so it will never be mutated
//    static unsigned long s_mutations = 0;
//    
//	state->mutationsPtr = &s_mutations;
//	return count;
//}



@end
