//
//  FLStackTrace_t.m
//  FishLamp
//
//  Created by Mike Fullerton on 9/3/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton.. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLStackTrace.h"
#import "NSObject+FLPrettyDescribe.h"

const FLStackTrace_t FLStaceTraceEmpty = { { 0, 0, 0, 0 }, {0, 0}};

void FLStackTraceFree(FLStackTrace_t* trace) {
    if(trace) {
        if(trace->stack.lines) free((void*)trace->stack.lines);
//        if(trace->location.filePath) free((void*)trace->location.filePath);
//        if(trace->location.function) free((void*)trace->location.function);
        
        trace->location.filePath = nil;
        trace->location.function = nil;
        trace->location.fileName = nil;
        trace->stack.lines = nil;
        trace->stack.depth = 0;
    }
}


NS_INLINE
const char* __copy_str(const char* str, int* len) {
    if(str != nil) {
        *len = strlen(str);
        char* outStr = malloc(*len + 1);
        strncpy(outStr, str, *len);
        return outStr;
    }
    
    return nil;
}

// [NSThread callStackSymbols]



FLStackTrace_t FLStackTraceMake(FLLocationInSourceFile_t loc, BOOL withCallStack) {
    void* callstack[128];
    
    FLStackTrace_t trace = { loc, { nil, 0 } };
    
//    int len = 0;
//    trace.function = __copy_str(function, &len);
//    trace.filePath = __copy_str(filePath, &len);
//    trace.lineNumber = lineNumber;
//    trace.fileName = nil;
    
//    trace.fileName = trace.filePath;
//    if(trace.fileName) {
//        trace.fileName += len;
//        
//        while(trace.fileName > trace.filePath) {
//            if(*(trace.fileName-1) == '/') {
//                break;
//            } 
//            --trace.fileName;
//        }
//    }
    
    if(withCallStack) {
        trace.stack.depth = backtrace(callstack, 128) - 1; // minus 1 because we don't want _FLStackTraceMake on the stack.
        trace.stack.lines = (const char**) backtrace_symbols(callstack, trace.stack.depth);
    }
    else {
        trace.stack.depth = 0;
        trace.stack.lines = nil;
    }

    return trace;
}

@implementation FLStackTrace

- (const char*) fileName {
    return FLFileNameFromLocation(&(_stackTrace.location));
}

- (const char*) filePath {
    return _stackTrace.location.filePath;
}

- (const char*) function {
    return _stackTrace.location.function;
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

- (void) appendToStringFormatter:(id<FLStringFormatter>) string {
    [string appendLineWithFormat:@"%s:%d, %s",
                            FLFileNameFromLocation(&_stackTrace.location),
                            _stackTrace.location.line, 
                            _stackTrace.location.function];

    [string indentLinesInBlock:^{
        for(int i = 0; i < self.stackDepth; i++) {
            [string appendLineWithFormat:@"%s", [self stackEntryAtIndex:i]];
        }
    }];
}

- (void) prettyDescription:(id<FLStringFormatter>) string {
    [self appendToStringFormatter:string];
}

- (NSString*) description {
    return [self prettyDescription];
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
