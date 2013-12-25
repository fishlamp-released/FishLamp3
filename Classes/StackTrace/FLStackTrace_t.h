//
//  FLStackTrace_t.h
//  FishLamp
//
//  Created by Mike Fullerton on 12/24/13.
//
//

#import "FishLampRequired.h"

typedef struct {
    const char* filePath;
    const char* fileName;
    const char* function;
    int line;
} FLLocationInSourceFile_t;

typedef struct {
    const char** lines;
    int depth;
} FLCallStack_t;

typedef struct {
    FLLocationInSourceFile_t location;
    FLCallStack_t stack;
} FLStackTrace_t;

NS_INLINE
FLLocationInSourceFile_t FLLocationInSourceFileMake(const char* filePath, const char* function, int line) {
    FLLocationInSourceFile_t loc = { filePath, nil, function, line };
    return loc;
}

extern const char* FLFileNameFromLocation(FLLocationInSourceFile_t* loc);

extern void FLStackTraceInit(FLStackTrace_t* stackTrace, void* callstack);

extern void FLStackTraceFree(FLStackTrace_t* trace);

extern FLStackTrace_t FLStackTraceMake( FLLocationInSourceFile_t loc, BOOL withCallStack);

NS_INLINE
const char* FLStackEntryAtIndex(FLCallStack_t stack, NSUInteger index) {
    return (index < stack.depth) ? stack.lines[index] : nil;
}

#define FLSourceFileLocation() \
            FLLocationInSourceFileMake(__FILE__, __PRETTY_FUNCTION__, __LINE__)
