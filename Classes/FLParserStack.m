/*
 *  FLParserStack.c
 *  FishLamp
 *
 *  Created by Mike Fullerton on 5/17/11.
 *  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton.
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
 *
 */
/*
#import "FLParserStack.h"
#import "FLPrettyString.h"

NSString *const FLParserStackErrorDomain = @"FLParserStackErrorDomain";

FLParserStack* FLParserStackAlloc()
{
	FLParserStack* stack = malloc(sizeof(FLParserStack));
	stack->top = -1;
	return stack;
}

void FLParserStackFree(FLParserStack** stack)
{
	while(FLParserStackPop(*stack))
	{
	}
	
	free(*stack);
	*stack = nil;
}

#if DEBUG
void FLParserStackLogState(FLParserStack* stack, NSString* why)
{
	FLPrettyString* prettyString = [FLPrettyString prettyString];
    [prettyString appendLineWithFormat:@"Logging parser stack: %@", why];
    [prettyString appendLineWithFormat:@"depth: %d", stack->top];
    
    if(stack->top >= 0)
    {
        for(int i = 0; i <= stack->top; i++)
        {
            FLParserStackNode* node = &(stack->stack[i]);
            [prettyString appendLineWithFormat:@"%i: key: %@, class: %@",i, node->key, NSStringFromClass([node->object class])];
        }
    }

	FLLog([prettyString string]);
}
#endif 
*/
