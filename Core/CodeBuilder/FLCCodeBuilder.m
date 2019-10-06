//
//  FLCCodeBuilder.m
//  AssertWritingTool
//
//  Created by Mike Fullerton on 9/13/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLCCodeBuilder.h"

@implementation FLCMacro


//- (void) willAppendToString:(NSMutableString*) destString
//                       tabs:(NSString*) tabs 
//                     string:(NSString*) string  
//                        eol:(NSString*) eol
//                   lineInfo:(FLLineInfo) lineInfo {
//    
//    if(lineInfo.closeLine) {
//        [destString appendFormat:@"%@%@ \\%@", tabs, string, eol];
//    }
//    else {
//        [super willAppendToString:destString tabs:tabs string:string eol:eol lineInfo:lineInfo];
//    }
//    
//}

@end



@implementation FLCComment


//- (void) willAppendToString:(NSMutableString*) destString
//                       tabs:(NSString*) tabs 
//                     string:(NSString*) string  
//                        eol:(NSString*) eol
//                 lineInfo:(FLLineInfo) lineInfo{
//    
//    if(lineInfo.openLine) {
//        [destString appendFormat:@"%@// %@%@", tabs, string, eol];
//    }
//    else {
//        [super willAppendToString:destString tabs:tabs string:string eol:eol lineInfo:lineInfo];
//    }
//    
//}

@end

@implementation FLCDocumentationComment

//
//- (void) willAppendToString:(NSMutableString*) destString
//                       tabs:(NSString*) tabs 
//                     string:(NSString*) string  
//                        eol:(NSString*) eol
//                 lineInfo:(FLLineInfo) lineInfo{
//    
//    if(lineInfo.openLine) {
//        [destString appendFormat:@"%@/// %@%@", tabs, string, eol];
//    }
//    else {
//        [super willAppendToString:destString tabs:tabs string:string eol:eol lineInfo:lineInfo];
//    }
//    
//}

@end

@implementation FLCCodeBuilder

- (void) appendMacroDefine:(NSString*) name parameters:(NSArray*) parameters {

    [self appendFormat:@"#define %@(", name];

    BOOL first = YES;
    for(NSString* parm in parameters) {
        if(first) {
            first = NO;
            [self appendString:parm];
        }
        else {
            [self appendFormat:@", %@", parm];
        }
    }
    
    [self appendLine:@")"];
}

- (void) appendMacroCall:(NSString*) name parameters:(NSArray*) parameters {

    [self appendFormat:@"%@(", name];

    BOOL first = YES;
    for(NSString* parm in parameters) {
    
        NSString* newParm = parm;
    
        if(FLStringsAreEqual(parm, @"...")) {
            newParm = @"##__VA_ARGS__";
        }
    
        if(first) {
            first = NO;
            [self appendString:newParm];
        }
        else {
            [self appendFormat:@", %@", newParm];
        }
    }
    
    [self appendLine:@")"];
}

@end
