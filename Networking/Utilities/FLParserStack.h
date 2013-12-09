/*
 *  FLParserStack.h
 *  FishLamp
 *
 *  Created by Mike Fullerton on 5/17/11.
 *  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton.
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
 *
 */
/*
#import "FishLampMinimum.h"

#define FLParserStackMaxDepth 128

extern NSString *const FLParserStackErrorDomain;

typedef enum {
	FLParserStackErrorCodeStackOverflow = 1
} FLParserStackErrorCode;

typedef struct {	
	__unsafe_unretained NSString* key;
	__unsafe_unretained id object;
} FLParserStackNode;

typedef struct {
	NSInteger top;
    FLParserStackNode stack[FLParserStackMaxDepth];
} FLParserStack;

extern FLParserStack* FLParserStackAlloc();
extern void FLParserStackFree(FLParserStack** stack);

NS_INLINE
void FLParserStackSetNodeObject(FLParserStackNode* node, id object) {
    FLSetObjectWithRetain((node->object), object);
}

NS_INLINE
void FLParserStackPush(FLParserStack* stack, id key, id object) {
	if(stack->top + 1 >= FLParserStackMaxDepth) {
		FLCThrowError_([NSError errorWithDomain:FLParserStackErrorDomain code:FLParserStackErrorCodeStackOverflow userInfo:nil]);
	}

	++stack->top;
	stack->stack[stack->top].key = FLRetain(key);
	stack->stack[stack->top].object = FLRetain(object);
}

NS_INLINE
BOOL FLParserStackPop(FLParserStack* stack)
{
	if(stack->top >= 0)
	{
		FLReleaseWithNil((stack->stack[stack->top].key));
		FLReleaseWithNil((stack->stack[stack->top].object));
		--stack->top;
		return YES;
	}
	
	return NO;
}

NS_INLINE
FLParserStackNode* FLParserStackTop(FLParserStack* stack)
{
	return stack->top >= 0 ? &(stack->stack[stack->top]) : nil;
}

NS_INLINE
NSString* FLParserStackTopKey(FLParserStack* stack)
{
	return stack->top >= 0 ? stack->stack[stack->top].key : nil;
}

NS_INLINE
BOOL FLParserStackIsEmpty(FLParserStack* stack)
{
	return stack->top < 0;
}

NS_INLINE
BOOL FLParserStackIsFull(FLParserStack* stack)
{
	return stack->top + 1 >= FLParserStackMaxDepth;
}

NS_INLINE
NSInteger FLParserStackDepth(FLParserStack* stack)
{
	return stack->top + 1;
}

#if DEBUG
extern void FLParserStackLogState(FLParserStack* stack, NSString* why);
#endif 

*/
