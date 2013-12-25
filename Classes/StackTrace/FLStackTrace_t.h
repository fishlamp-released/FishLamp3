//
//  FLStackTrace_t.h
//  FishLamp
//
//  Created by Mike Fullerton on 12/24/13.
//
//

#import "FishLampRequired.h"
#import "FLFileLocation_t.h"

typedef struct {
    const char** lines;
    int depth;
} FLCallStack_t;

typedef struct {
    FLFileLocation_t location;
    FLCallStack_t stack;
} FLStackTrace_t;


extern void FLStackTraceInit(FLStackTrace_t* stackTrace, void* callstack);

extern void FLStackTraceFree(FLStackTrace_t* trace);

extern FLStackTrace_t FLStackTraceMake( FLFileLocation_t loc, BOOL withCallStack);

NS_INLINE
const char* FLStackEntryAtIndex(FLCallStack_t stack, NSUInteger index) {
    return (index < stack.depth) ? stack.lines[index] : nil;
}

#define FLStackTraceToHere(__WITH_STACK_TRACE__) \
            FLStackTraceMake(FLCurrentFileLocation(), __WITH_STACK_TRACE__)
