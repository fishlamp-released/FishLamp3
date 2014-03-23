//
//  FLObjcCodeBuilder.m
//  CodeGenerator
//
//  Created by Mike Fullerton on 2/1/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLObjcCodeBuilder.h"
#import "FLObjcCodeGeneratorHeaders.h"

#import "NSString+Lists.h"

@implementation FLObjcCodeBuilder

+ (id) objcCodeBuilder {
    return FLAutorelease([[[self class] alloc] init]);
}

- (void) appendComment:(NSString*) aComment {
    FLObjcComment* comment = [FLObjcComment objcComment];
    [comment appendLine:aComment];
    [self appendString:comment];
}

- (void) appendPreprocessorIf:(NSString*) condition {
    [self appendLineWithFormat:@"#if %@", condition];
}

- (void) appendPreprocessorEndIf {
    [self appendLine:@"#endif"];
}

- (void) appendImport:(NSString*) fileName {
    if(![fileName hasSuffix:@".h"]) {
        fileName = [fileName stringByAppendingString:@".h"];
    }

    [self appendLineWithFormat:@"#import \"%@\"", fileName];
}

- (void) appendClassDeclaration:(NSString*) className {
    [self appendLineWithFormat:@"@class %@;", className];
}

- (void) appendProtocolDeclaration:(NSString*) protocol {
    [self appendLineWithFormat:@"@protocol %@;", protocol];
}

- (void) appendInterfaceDeclaration:(NSString*) className 
                         superClass:(NSString*) superClass 
                          protocols:(NSArray*) protocols
           appendMemberDeclarations:(dispatch_block_t) appendMembers {

    [self appendFormat:@"@interface %@ : %@", className, superClass];
    
    if(protocols && protocols.count) {
        [self appendFormat:@"<%@>", [NSString concatStringArray:protocols]];
    }
    
    if(appendMembers) {
        [self appendLine:@" {"];
        [self appendString:@"@private"];
        [self indent:^{
            if(appendMembers) {
                appendMembers();
            }
        }];
        [self appendString:@"}"];
        [self appendBlankLine];
    }
    else {
        [self closeLine];
    }
}           

- (void) appendImplementation:(NSString*) className {
    [self appendLineWithFormat:@"@implementation %@", className];
}
           
- (void) appendEnd {
    [self appendLine:@"@end"];
}

- (void) appendPrivate {
    [self appendLine:@"@private"];
}

- (void) appendSynthesize:(NSString*) propertyName ivarName:(NSString*) ivarName {
    [self appendLineWithFormat:@"@synthesize %@ = %@;", propertyName, ivarName];
}

- (void) appendVariableDeclaration:(NSString*) variableType variableName:(NSString*) variableName {
    [self appendLineWithFormat:@"%@ %@;", variableType, variableName];
}

- (void) appendBlankLine {
    [self closeLine];
    _appendBlankLine = YES;
}

- (void) stringFormatterOpenLine:(FLStringFormatter*) stringFormatter {
    if(_appendBlankLine) {
        [super appendBlankLine];
        _appendBlankLine = NO;
    }
    
    [super stringFormatterOpenLine:stringFormatter];
}

- (void) appendPropertyDeclaration:(NSString*) name 
                              type:(NSString*) type 
                            atomic:(BOOL) atomic 
                         ownership:(FLObjcPropertyTypeEnum) ownership 
                         readwrite:(BOOL) readwrite
                      customGetter:(NSString*) customGetter
                      customSetter:(NSString*) customSetter {

    if(readwrite) {
        [self openLineWithString:@"@property (readwrite"];
    }
    else {
        [self openLineWithString:@"@property (readonly"];
    }

    switch(ownership) {
        case FLObjcPropertyTypeStrong:
            [self appendString:@", strong"];
        break;
        case FLObjcPropertyTypeWeak:
            [self appendString:@", weak"];
        break;
        case FLObjcPropertyTypeAssign:
            [self appendString:@", assign"];
        break;
        case FLObjcPropertyTypeCopy:
            [self appendString:@", copy"];
        break;
    }
    if(!atomic) {
        [self appendString:@", nonatomic"];
    }
    if(FLStringIsNotEmpty(customGetter)) {
        [self appendFormat:@", getter=%@", customGetter];
    }
    if(FLStringIsNotEmpty(customSetter)) {
        [self appendFormat:@", setter=%@", customSetter];
    }
    
    [self appendLineWithFormat:@") %@ %@;", type, name];
}

- (void) appendMethodParameter:(NSString*) name type:(NSString*) type key:(NSString*) key isFirst:(BOOL) isFirst {

    if(isFirst) {
        [self appendFormat:@":(%@) %@", type, name];
    }
    else {
        [self appendFormat:@" %@:(%@) %@", key, type, name];
    }
}                

- (void) appendMethodDeclaration:(NSString*) name 
                            type:(NSString*) type 
                isInstanceMethod:(BOOL) isInstanceMethod 
                       closeLine:(BOOL) closeLine{

    if(FLStringIsEmpty(type)) {
        type = @"void";
    }

    [self appendFormat:@"%@ (%@) %@", isInstanceMethod ? @"-" : @"+", type, name];
    
    if(closeLine) {
        [self appendLine:@";"];
    }
}

- (void) closeLineWithSemiColon {
    [self appendLine:@";"];
}                

- (void) appendRelease:(NSString*) name {
    [self appendLineWithFormat:@"[%@ release];", name];
}

- (void) appendSuperDealloc {
    [self appendLine:@"[super dealloc];"];
}



- (void) appendDefine:(NSString*) name value:(NSString*) value {
    [self appendLineWithFormat:@"#define %@ %@", name, value];
}

- (void) appendDefine:(NSString*) name stringValue:(NSString*) value {
    [self appendLineWithFormat:@"#define %@ @\"%@\"", name, value];
}

- (void) appendCaseStatement:(NSString*) var statement:(dispatch_block_t) statement {
    [self appendLineWithFormat:@"case %@:{", var];
    [self indent:statement];
    [self appendLine:@"}"];
    [self appendLine:@"break;"];
}

- (void) appendSwitchBlock:(NSString*) variable caseStatements:(dispatch_block_t) caseStatements {
    [self appendLineWithFormat:@"switch(%@) {", variable];
    [self indent:caseStatements];
    [self appendLine:@"}"];
}

- (void) appendReturnValue:(NSString*) returnValue {
    [self appendLineWithFormat:@"return %@;", returnValue];
}

- (void) appendRunOnceBlock:(NSString*) predicateName block:(dispatch_block_t) block {
    [self appendLineWithFormat:@"static dispatch_once_t %@ = 0;", predicateName];
    [self appendLineWithFormat:@"dispatch_once(&%@, ^{", predicateName];
    [self indent:block];
    [self appendLine:@"});"];
}

- (void) appendStaticVariable:(NSString*) type name:(NSString*) name initialValue:(NSString*) initialValue {
    [self appendLineWithFormat:@"static %@ %@ = %@;", type, name, initialValue];
}

- (void) scope:(dispatch_block_t) block {
    [self appendLine:@"{"];
    [self indent:block];
    [self appendLine:@"}"];
}

- (void) appendScopedCode:(NSString*) leaderOrNil block:(dispatch_block_t) block {
    if(FLStringIsNotEmpty(leaderOrNil)) {
        [self appendLineWithFormat:@"%@ {", leaderOrNil];
    }
    else {
        [self appendLine:@"{"];
    }
    [self indent:block];
    [self appendLine:@"}"];
}

- (void) appendAssignment:(NSString*) from to:(NSString*) to {
    [self appendLineWithFormat:@"%@ = %@;", to, from];
}


@end

@implementation FLObjcComment

+ (id) objcComment {
    return FLAutorelease([[[self class] alloc] init]);
}

- (void) appendEmptyComment {
    [self appendLine:@""];
}

//- (NSMutableString*) willOpenLine {
//    return [NSMutableString stringWithString:@"// "];
//}

- (void) stringFormatterOpenLine:(FLStringFormatter*) stringFormatter {
    [super stringFormatterOpenLine:stringFormatter];
    [self appendString:@"// "];
}

@end