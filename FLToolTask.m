////
////  FLToolArgument.m
////  FishLampCommandLineTool
////
////  Created by Mike Fullerton on 11/14/12.
////  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
////
//
//#import "FLToolTask.h"
//#import "FLCommandLineTool.h"
//#import "NSString+Lists.h"
//
//NSString* const FLToolDefaultKey = @"--default-task";
//
//@implementation FLCommandLineTool (FLToolTask)
//- (id) parent {
//    return nil;
//}
//
//- (FLCommandLineTool*) tool {
//    return self;
//}
//
//- (NSString*) taskName {
//    return self.toolName;
//}
//@end
//
//@implementation FLToolTask
//
//@synthesize taskName = _taskName;
//@synthesize taskDescription = _taskDescription;
//@synthesize taskBlock = _taskBlock;
//@synthesize argumentKeys = _argumentKeys;
//@synthesize parent = _parent;
//@synthesize tool = _tool;
//
//- (FLStringFormatter*) output {
//    return [self.parent output];
//}
//
//- (void) setParent:(id) parent {
//    _parent = parent;
//    _tool = [parent tool];
//    [self didMoveToParent:parent];
//}
//
//- (void) didMoveToParent:(id) parent {
//}
//
//- (id) initWithKeys:(NSString*) keys {
//    self = [super init];
//    if(self) {
//        _argumentKeys = [[NSMutableSet alloc] init];
//    
//        if(keys) {
//            [self addKeys:keys];
//        }
//        
//        self.taskDescription = @"";
//
//    }
//    return self;
//}
//
//- (id) init {
//    return [self initWithKeys:nil];
//}
//
//+ (id) toolTask {
//    return FLAutorelease([[[self class] alloc] init]);
//}
//
//+ (id) toolTask:(NSString*) name {
//    return FLAutorelease([[[self class] alloc] initWithKeys:name]);
//}
//
//#if FL_MRC
//- (void) dealloc {
//    [_toolTaskBlock release];
//    [_taskDescription release];
//    [_name release];
//    [_argumentKeys release];
//    [super dealloc];
//}
//#endif
//
//- (void) setName:(NSString*) name {
//    FLSetObjectWithRetain(_taskName, [name lowercaseString]);
//}
//
//
//- (NSString*) buildUsageString {
//    return [NSString concatStringArray:self.argumentKeys.allObjects];
//}
//
//- (void) printHelpToStringFormatter:(FLStringFormatter*) output {
//
//    [output appendLineWithFormat:@"  %@ %@: %@",    [self.taskName stringWithPadding_fl:20], 
//                                                        [[NSString concatStringArray:self.argumentKeys.allObjects] stringWithPadding_fl:20], 
//                                                        [self taskDescription]];
//
//
//}
//
//- (void) willRunWithArguments:(NSArray*) commandLineArgumentArray {
//}
//
//- (void) didRunWithArguments:(NSArray*) commandLineArgumentArray {
//}
//
//- (void) didFailWithError:(NSError*)error {
//}
//
//- (void) runWithArgument:(FLStringParser*) input {
//    if(_taskBlock) {
//        _taskBlock(input);
//    }
//}
//
//- (NSArray*) parseParameters:(FLStringParser*) input {
//
//    return nil;
//}
//
//- (void) runWithArguments:(id) args {
//}
//
//- (id) findArguments:(FLStringParser*) input {
//    return nil;
//}
//
//- (void) run:(id) args {
//    @try {
//        [self willRunWithArguments:args];
//        [self runWithArguments:args];
//        [self didRunWithArguments:args];
//    }
//    @catch(NSException* ex) { 
//        [self didFailWithError:ex.error];
//    }
//}
//
//// make list of tasks + input, then execute once parsing is done
//
//@end
//
//@implementation FLToolTaskGroup 
//
//@synthesize tasks = _tasks;
//
//- (id) initWithKeys:(NSString*) keys {
//    self = [super init];
//    if(self) {
//        _tasks = [[NSMutableDictionary alloc] init];
//    }
//    
//    return self;
//}
//
//#if FL_MRC
//- (void) dealloc {
//    [_tasks release];
//    [super dealloc];
//}
//#endif
//
//- (FLToolTask*) toolTaskForKey:(NSString*) key {
//    return [_tasks objectForKey:key];
//}
//
//- (void) setDefaultToolTask:(FLToolTask*) task {
//    [task addKeys:FLToolDefaultKey];
//    [self addToolTask:task];
//}
//
//- (void) addToolTask:(FLToolTask*) task {
//    for(NSString* key in task.argumentKeys) {
//        if(FLStringIsNotEmpty(key)) {
//            id existing = [_tasks objectForKey:[key lowercaseString]];
//            FLConfirmIsNilWithComment(existing, @"task already installed for key: %@", key);
//            [_tasks setObject:task forKey:key];
//        }
//    }
//    task.parent = self;
//}
//
//- (void) handleInput:(FLStringParser*) input {
//
//   @try {
//
//        NSMutableArray* tasks = [NSMutableArray array];
//        
//        if([self.argumentKeys containsObject:key]) {
//            [self pushTask:self withArgs:[self findArguments:input] ontoArray:tasks];
//        }
//        
//        while(input.hasMore) {
//            key = [[input next] lowercase];
//            
//            FLToolTask* task = [_tasks objectForKey:key];
//            if(task) {
//                [array addObject:[FLKeyValuePair keyValuePair:task value:args]];
//            }
//            else {
//                break;
//            }   
//        }
////                else {
////                
////                    [tasks removeAllObjects];
////                    
////                    FLToolTask* defaultTask = [self toolTaskForKey:FLToolDefaultKey];
////                    if(defaultTask) {
////                        [defaultTask runWithArgument:arg ];
////                    }
////                    else {
////                        [self.output appendLineWithFormat:@"Unknown task: %@", arg.key];
////                    }
////                    
////                    break;
////                }
////            }
////            
////            if(tasks && tasks.count) {
////                for(dispatch_block_t block in tasks) {
////                    block();
////                }
////            }
//    }
//    @catch(NSException* ex) {
//        
//        [self didFailWithError:ex.error];
//        @throw;
//    }}
//}
//
//@end
//
//
////- (void) addCompatibleParameter:(NSString*) parameter {
////    
////    FLAssertIsNotNil(parameter);
////
////    if(!_compatibleParameters) {
////        _compatibleParameters = [[NSMutableArray alloc] init];
////    }
////    
////    [_compatibleParameters addObject:parameter];
////}
////
////- (void) addRequiredParameter:(NSString*) parm {
////
////}
////
////- (void) addInputKey:(NSString*) parm {
////    [_inputKeys addObject:parm];
////}
////
////- (BOOL) hasInputParameter:(NSString*) parm {
////    for(NSString* p in self.inputKeys) {
////        if(FLStringsAreEqualCaseInsensitive(p, parm)) {
////            return YES;
////        }
////    }
////
////    return NO;
////}
////
////- (BOOL) isCompatibleWithParameter:(NSString*) argument {
////    
////    if(FLStringsAreEqual(@"*", argument) || self.compatibleInputKeys.count == 0) {
////        return YES;
////    }
////
////    for(NSString* p in self.compatibleInputKeys) {
////        if(FLStringsAreEqualCaseInsensitive(p, argument) || FLStringsAreEqual(p, @"*")) {
////            return YES;
////        }
////    }
////    
////    return NO;
////}
////
////- (BOOL) isCompatibleWithTask:(FLToolTask*) task {
////    
////    for(NSString* p in self.inputKeys) {
////        if([task isCompatibleWithParameter:p]) {
////            return YES;
////        }
////    }
////    
////    for(NSString* p in task.inputKeys) {
////        if([self isCompatibleWithParameter:p]) {
////            return YES;
////        }
////    }
////    
////    return NO;
////}
//
//
