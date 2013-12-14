//
//  FLStackTrace_t.h
//  FishLamp
//
//  Created by Mike Fullerton on 9/3/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton.. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampObjc.h"

#import <execinfo.h>
#import <objc/runtime.h>

#import "FLStringFormatter.h"

NS_INLINE
const char* FLFileNameFromPathNoCopy(const char* filePath) {
    if(filePath) {
        const char* lastComponent = nil;

        while(*filePath) {
            if(*filePath++ == '/') {
                lastComponent = filePath;
            }
        }
        
        return lastComponent;
    }
    return nil;
}

typedef struct {
    const char* filePath;
    const char* fileName;
    const char* function;
    int line;
} FLLocationInSourceFile_t;

NS_INLINE
const char* FLFileNameFromLocation(FLLocationInSourceFile_t* loc) {
    if(!loc->fileName) {
        loc->fileName = FLFileNameFromPathNoCopy(loc->filePath);
    }
    return loc->fileName;
}


NS_INLINE
FLLocationInSourceFile_t FLLocationInSourceFileMake(const char* filePath, const char* function, int line) {
    FLLocationInSourceFile_t loc = { filePath, nil, function, line };
    return loc;
}

#define FLSourceFileLocation() FLLocationInSourceFileMake(__FILE__, __PRETTY_FUNCTION__, __LINE__)

typedef struct {
    const char** lines;
    int depth;
} FLCallStack_t;

typedef struct {
    FLLocationInSourceFile_t location;
    FLCallStack_t stack;
} FLStackTrace_t;

extern void FLStackTraceInit(FLStackTrace_t* stackTrace, void* callstack);
extern void FLStackTraceFree(FLStackTrace_t* trace);

extern FLStackTrace_t FLStackTraceMake( FLLocationInSourceFile_t loc, BOOL withCallStack);

NS_INLINE
const char* FLStackEntryAtIndex(FLCallStack_t stack, NSUInteger index) {
    return (index < stack.depth) ? stack.lines[index] : nil;
}

// OBJECT

@interface FLStackTrace : NSObject<FLStringFormatting> {
@private
    FLStackTrace_t _stackTrace;
}

// use FLCreateStackTrace instead of this method
+ (FLStackTrace*) stackTrace:(FLStackTrace_t) willTakeOwnershipOfTrace;
+ (FLStackTrace*) stackTraceWithException:(NSException*) ex;

// where the stack trace was made
@property (readonly, assign, nonatomic) const char* fileName;
@property (readonly, assign, nonatomic) const char* filePath;
@property (readonly, assign, nonatomic) const char* function;
@property (readonly, assign, nonatomic) int lineNumber;

@property (readonly, assign, nonatomic) FLCallStack_t callStack;

@property (readonly, assign, nonatomic) int stackDepth;
- (const char*) stackEntryAtIndex:(int) idx;
@end


#define FLStackTraceToHere(__WITH_STACK_TRACE__) \
            FLStackTraceMake(FLSourceFileLocation(), __WITH_STACK_TRACE__)

#define FLCreateStackTrace(__WITH_STACK_TRACE__) \
            [FLStackTrace stackTrace:FLStackTraceToHere(__WITH_STACK_TRACE__)]



