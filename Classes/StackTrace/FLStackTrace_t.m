//
//  FLStackTrace_t.m
//  FishLamp
//
//  Created by Mike Fullerton on 12/24/13.
//
//

#import "FLStackTrace_t.h"

#import <execinfo.h>
#import <objc/runtime.h>

const FLStackTrace_t FLStaceTraceEmpty = { { 0, 0, 0, 0 }, {0, 0}};


void FLStackTraceFree(FLStackTrace_t* trace) {
    if(trace) {
        if(trace->stack.lines) {
            free((void*)trace->stack.lines);
            trace->stack.lines = nil;
        }
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



FLStackTrace_t FLStackTraceMake(FLFileLocation_t loc, BOOL withCallStack) {
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