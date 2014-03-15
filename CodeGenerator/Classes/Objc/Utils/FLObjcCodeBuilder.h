//
//  FLObjcCodeBuilder.h
//  CodeGenerator
//
//  Created by Mike Fullerton on 2/1/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLCodeBuilder.h"

typedef enum {
  FLObjcPropertyTypeAssign,
  FLObjcPropertyTypeWeak,
  FLObjcPropertyTypeStrong,
  FLObjcPropertyTypeCopy  
} FLObjcPropertyTypeEnum;

@interface FLObjcCodeBuilder : FLCodeBuilder {
@private
    BOOL _appendBlankLine;
}

+ (id) objcCodeBuilder;

- (void) appendComment:(NSString*) comment;

- (void) appendPreprocessorIf:(NSString*) condition;
- (void) appendPreprocessorEndIf;
- (void) appendDefine:(NSString*) name value:(NSString*) value;
- (void) appendDefine:(NSString*) name stringValue:(NSString*) value;

- (void) appendImport:(NSString*) fileName;
- (void) appendClassDeclaration:(NSString*) className;
- (void) appendProtocolDeclaration:(NSString*) className;
- (void) appendInterfaceDeclaration:(NSString*) className 
                         superClass:(NSString*) superClass 
                          protocols:(NSArray*) prococols
           appendMemberDeclarations:(dispatch_block_t) appendMembers;
           
- (void) appendEnd;
- (void) appendPrivate;

- (void) appendVariableDeclaration:(NSString*) variableType variableName:(NSString*) variableName;

- (void) appendPropertyDeclaration:(NSString*) name 
                              type:(NSString*) type 
                            atomic:(BOOL) atomic 
                         ownership:(FLObjcPropertyTypeEnum) ownership 
                         readwrite:(BOOL) readwrite
                      customGetter:(NSString*) customGetterOrNil
                      customSetter:(NSString*) customSetterOrNil;

- (void) appendImplementation:(NSString*) className;

- (void) appendMethodDeclaration:(NSString*) name 
                            type:(NSString*) type
                isInstanceMethod:(BOOL) isInstanceMethod // e.g. is NOT static (class) method
                       closeLine:(BOOL) closeLine;
                
- (void) appendMethodParameter:(NSString*) name type:(NSString*) type key:(NSString*) key isFirst:(BOOL) isFirst;                

- (void) closeLineWithSemiColon;

- (void) appendSynthesize:(NSString*) propertyName ivarName:(NSString*) ivarName;

- (void) appendRelease:(NSString*) name;
- (void) appendSuperDealloc;

- (void) scope:(dispatch_block_t) block;

// switch blocks
- (void) appendSwitchBlock:(NSString*) variable caseStatements:(dispatch_block_t) caseStatements;
- (void) appendCaseStatement:(NSString*) var statement:(dispatch_block_t) statement;

- (void) appendReturnValue:(NSString*) returnValue;

- (void) appendRunOnceBlock:(NSString*) predicateName block:(dispatch_block_t) block;
- (void) appendStaticVariable:(NSString*) type name:(NSString*) name initialValue:(NSString*) initialValue;

- (void) appendAssignment:(NSString*) from to:(NSString*) to;

@end


#import "FLCodeChunk.h"

@interface FLObjcComment : FLCodeChunk
+ (id) objcComment;
- (void) appendEmptyComment;
@end

