//
//  FLToolArgument.h
//  FishLampCommandLineTool
//
//  Created by Mike Fullerton on 11/14/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

//#import "FishLampCore.h"
//#import "FLCommandLineTool.h"

//@class FLCommandLineTool;
//
//extern NSString* const FLToolDefaultKey;
//
//typedef void (^FLToolTaskBlock)(FLStringParser* argument);
//
//@interface FLToolTask : NSObject<FLSimpleInputParser> {
//@private
//    NSMutableSet* _argumentKeys;
//    NSString* _taskDescription; 
//    NSString* _taskName;
//    FLToolTaskBlock _taskBlock;
//    NSMutableDictionary* _tasks;
//    __unsafe_unretained id _parent;
//    __unsafe_unretained FLCommandLineTool* _tool;
//}
//
//@property (readonly, strong, nonatomic) FLStringFormatter* output;
//
//@property (readwrite, assign, nonatomic) id parent;
//@property (readonly, assign, nonatomic) FLCommandLineTool* tool;
//
//@property (readwrite, strong, nonatomic) NSString* taskDescription;
//
//@property (readwrite, copy, nonatomic) FLToolTaskBlock taskBlock;
//
//// by default, the name is the first key.
//@property (readwrite, strong, nonatomic) NSString* taskName;
//
//@property (readonly, strong, nonatomic) NSSet* argumentKeys;
//
//- (id) initWithKeys:(NSString*) name;
//+ (id) toolTask:(NSString*) keys;
//+ (id) toolTask;
//
//- (void) addKeys:(NSString*) keys; // space and/or comma delimited.
//
//
//// override this
//- (id) findArguments:(FLStringParser*) input;
//- (void) runWithArguments:(id) arguments;
//
//// optional overrides
//- (void) willRunWithArguments:(id) arguments;
//- (void) didRunWithArguments:(id) arguments;
//
//- (void) didFailWithError:(NSError*)error;
//
//- (NSString*) buildUsageString;
//- (void) printHelpToStringFormatter:(FLStringFormatter*) formatter;
//
//- (void) didMoveToParent:(id) parent;
//
//@end


// utils


//// do we own input parameters (this is case insensitive)
//- (BOOL) hasInputParameter:(NSString*) parm;
//
//// add required parameters
//- (void) addRequiredParameter:(NSString*) parm;

//
// help (shown when usage is invoked.
// 

//
// compatible parameters, by default not compatible with other argumentHandlers
//
// compatible parameters list
//@property (readonly, strong) NSArray* compatibleInputKeys;
//
//
//// use FLInputHandlerFLCompatibleWithAll to be compatabile with all, for example in a --verbose key
//- (void) addCompatibleParameter:(NSString*) parameter; 
//
//// check both for compatibility with each other
//- (BOOL) isCompatibleWithTask:(FLToolTask*) task;
//
//// just check if inputParameter (for another argumentHandler) is compatible with self
//- (BOOL) isCompatibleWithParameter:(NSString*) argument;
//

