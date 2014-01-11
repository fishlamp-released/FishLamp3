//
//  FLObjcObject.m
//  CodeGenerator
//
//  Created by Mike Fullerton on 5/11/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLObjcObject.h"
#import "FLObjcCodeGeneratorHeaders.h"

#import "FLCodeObject.h"
#import "FLCodeStorageOptions.h"
#import "FLCodeProjectInfo.h"
#import "FLObjectDescriber.h"

@interface FLObjcObject ()
@property (readwrite, strong, nonatomic) FLCodeObject* codeObject;
//@property (readwrite, strong, nonatomic) FLCodeObject* codeObject;
@end

@implementation FLObjcObject 

@synthesize superclassType = _superclassType;
@synthesize objectName = _objectName;
@synthesize codeObject = _codeObject;
@synthesize ivars = _ivars;
@synthesize objectType = _objectType;
@synthesize properties = _properties;

- (id) initWithProject:(FLObjcProject*) project {	
	self = [super initWithProject:project];
	if(self) {
        _ivars = [[FLObjcNamedObjectCollection alloc] init];
        _properties = [[FLObjcNamedObjectCollection alloc] init];
        _methods = [[NSMutableArray alloc] init];
        _dependencies = [[NSMutableSet alloc] init];

	}
	return self;
}

+ (id) objcObject:(FLObjcProject*) project {
    return FLAutorelease([[[self class] alloc] initWithProject:project]);
}

- (BOOL) isObject {
    return YES;
}


- (NSString*) generatedName {
    return self.objectName.generatedName;
}

- (NSString*) generatedReference {
    return self.objectType.generatedReference;

//    return [NSString stringWithFormat:@"%@*", self.typeName];
}


- (NSString*) importFileName {
    return [NSString stringWithFormat:@"%@.h", self.generatedName];
}

- (void) addIvar:(FLObjcIvar*) ivar {
    [_ivars addObject:ivar forObjcName:ivar.variableName];
}

- (void) addProperty:(FLObjcProperty*) property {
    [_properties addObject:property forObjcName:property.propertyName];
}

- (void) addDependency:(FLObjcType*) type {

    [_dependencies addObject:type.typeName.identifier];

//    [_dependencies addObject:type.iden];
}

- (void) addMethod:(FLObjcMethod*) method {
    [_methods addObject:method];
    [method didMoveToObject:self];
}

- (void) addProtocol:(FLObjcType*) type {
    if(!_protocols) {
        _protocols = [[NSMutableArray alloc] init];
    }
    [_protocols addObject:type];
    [self addDependency:type];

}

#if FL_MRC
- (void) dealloc {
    [_protocols release];
    [_codeObject release];
	[_superclassType release];
    [_objectName release];
    [_ivars release];
    [_properties release];
    [_methods release];
    [_dependencies release];
    [super dealloc];
}
#endif

- (NSString*) storageMaskForStorageOptions:(FLCodeStorageOptions*) option {
	NSMutableString* storageMask = [NSMutableString string];

	if(!option.isStorable) {
		[storageMask appendString:@"FLStorageAttributeNotStored"];
	}
	else {
		[storageMask appendString:@"FLStorageAttributeStored"];
	}
	
    if(option.isPrimaryKey) {
		[storageMask appendString:@"|FLStorageAttributePrimaryKey"];
	}
	
    if(option.isIndexed) {
		[storageMask appendString:@"|FLStorageAttributeIndexed"];
	}
	
    if(option.isRequired) {
		[storageMask appendString:@"|FLStorageAttributeRequired"];
	}
	
    if(option.isUnique) {
		[storageMask appendString:@"|FLStorageAttributeUnique"];
	}
	
	return storageMask;
}


- (void) addProtocols:(FLCodeObject*) codeObject {
    if(FLStringIsNotEmpty(codeObject.protocols)) {
        NSArray* protocols = [[codeObject protocols] componentsSeparatedByCharactersInSet_fl:[NSCharacterSet characterSetWithCharactersInString:@" ,"] allowEmptyStrings:NO];

        for(NSString* protocol in protocols) {
            FLObjcType* type = [self.project.typeRegistry typeForKey:protocol];
            [self addProtocol:type];
        }
    }
}

- (void) addSuperclass:(FLCodeObject*) codeObject superclass:(NSString*) inSuperclass {

    FLObjcType* superclass = nil;

    if(FLStringIsNotEmpty(inSuperclass)) {
        superclass = [self.project.typeRegistry typeForKey:inSuperclass];
    }
    else if(FLStringIsNotEmpty(codeObject.superclass)) {
        superclass = [self.project.typeRegistry typeForKey:codeObject.superclass];
    }
    else {
        superclass = [self.project.typeRegistry typeForKey:NSStringFromClass([FLModelObject class])];
    }

    [self addDependency:superclass];
    self.superclassType = superclass;
}

- (void) setObjectTypeWithInputProject:(FLCodeObject*) codeObject {
    self.objectType = [FLObjcMutableObjectType objcMutableObjectType:self.objectName importFileName:[NSString stringWithFormat:@"%@.h", self.objectName.generatedName]];
}

- (void) addPropertiesWithInputObject:(FLCodeObject*) codeObject {
    for(FLCodeProperty* codeProperty in codeObject.properties) {
        FLObjcType* type = [self.project.typeRegistry typeForKey:[codeProperty type]];
        [type addPropertiesToObjcObject:self withCodeProperty:codeProperty];
    }
}

- (void) addMethodsWithInputObject:(FLCodeObject*) codeObject {
    for(FLCodeMethod* method in codeObject.methods) {
        FLObjcMethod* objcMethod = [FLObjcMethod objcMethod:self.project];
        [objcMethod configureWithCodeMethod:method];
        [self addMethod:objcMethod];
        [self addDependency:objcMethod.returnType];
    }
}

- (void) addConstructorsWithInputObject:(FLCodeObject*) codeObject {
    for(FLCodeConstructor* inputCtor in codeObject.constructors) {
        FLObjcConstructor* ctor = [FLObjcConstructor objcConstructor:self.project];
        [ctor configureWithInputConstructor:inputCtor withObject:self];
        [self addMethod:ctor];
    }
}

- (void) addStandardBaseClassMethodsWithInputObject:(FLCodeObject*) codeObject {
    [self addDependency:[self.project.typeRegistry typeForClass:[FLObjectDescriber class]]];
    [self addMethod:[FLObjcDidRegisterObjectDescriberMethod objcDidRegisterObjectDescriberMethod:self.project]];
    [self addMethod:[FLObjcDeallocMethod objcMethod:self.project]];
}

- (void) addClassConstructorsWithInputObject:(FLCodeObject*) codeObject
                                    toObject:(FLObjcObject*) object {

    FLObjcClassInitializerMethod* defaultInit = [FLObjcClassInitializerMethod objcMethod:self.project];
    [defaultInit configureWithInputConstructor:nil withObject:self];
    [object addMethod:defaultInit];

    for(FLCodeConstructor* inputCtor in codeObject.constructors) {
        FLObjcClassInitializerMethod* method = [FLObjcClassInitializerMethod objcMethod:self.project];
        [method configureWithInputConstructor:inputCtor withObject:self];
        [object addMethod:method];
    }
}

- (NSString*) description {
    FLPrettyString* string = [FLPrettyString prettyString];
    [string appendLineWithFormat:@"classType: %@, superclass:%@",  [self.objectName description], [self.superclassType description]];
    
    [string appendLine:@"properties:"];
    [string indent: ^{
        for(FLObjcProperty* prop in [_properties objectEnumerator]) {
            [string appendLine:[prop description]];
        }
    }];
    [string appendLine:@"ivars:"];
    [string indent: ^{
        for(FLObjcIvar* ivar in [_ivars objectEnumerator]) {
            [string appendLine:[ivar description]];
        }
    }];
    [string appendLine:@"dependencies:"];
    [string indent: ^{
        for(NSString* type in _dependencies) {
            [string appendLine:type];
        }
    }];
    
    return string.string;
}

- (void) writeCodeToHeaderFile:(FLObjcFile*) file withCodeBuilder:(FLObjcCodeBuilder*) codeBuilder {

    NSMutableSet* fwdRefs = [NSMutableSet set];
    NSMutableSet* imports = [NSMutableSet set];
    
    FLObjcType* superclass = self.superclassType;
    
    if(FLStringIsNotEmpty(superclass.importFileName)) {
        [imports addObject:superclass];
    }
    
    for(NSString* dependencyName in _dependencies) {
        FLObjcType* dependency = [self.project.typeRegistry typeForKey:dependencyName];
        
        if(FLStringIsNotEmpty(dependency.importFileName)) {
            if(dependency.canForwardReference) {
                [fwdRefs addObject:dependency];
            }
            else {
                [imports addObject:dependency];
            }
        }
    }

    for(FLObjcType* aImport in imports) {
        [codeBuilder appendImport:aImport.importFileName];
        [fwdRefs removeObject:aImport];
    }

    [codeBuilder appendBlankLine];

    for(FLObjcType* fwdRef in fwdRefs) {
        [codeBuilder appendClassDeclaration:fwdRef.generatedName];
    }

    NSMutableArray* protocols = nil;
    if(_protocols) {
        protocols = [NSMutableArray array];
        
        for(FLObjcType* type in _protocols) {
            [protocols addObject:type.generatedName];
        }
    }
    
    [codeBuilder appendBlankLine];
    [codeBuilder appendInterfaceDeclaration:self.objectName.generatedName 
                                 superClass:self.superclassType.generatedName 
                                  protocols:protocols 
                   appendMemberDeclarations:^{
    
        for(FLObjcIvar* ivar in [_ivars objectEnumerator]) {
            [ivar writeCodeToHeaderFile:file withCodeBuilder:codeBuilder];
        }
    }];

    NSMutableArray* props = FLMutableCopyWithAutorelease([_properties allValues]);
    
    [props sortUsingComparator:^NSComparisonResult(FLObjcProperty* obj1, FLObjcProperty* obj2) {
        return [obj1.propertyName.generatedName compare:obj2.propertyName.generatedName];
    }];
    
    for(FLObjcProperty* prop in props) {
        [prop writeCodeToHeaderFile:file withCodeBuilder:codeBuilder];
    }

    [codeBuilder appendBlankLine];
    for(FLObjcMethod* method in _methods) {
        [method writeCodeToHeaderFile:file withCodeBuilder:codeBuilder];
    }

    [codeBuilder appendBlankLine];
    [codeBuilder appendEnd];
}

// need ugly cast - conflict between propertyName 
#define NameForSorting(obj) \
            [obj respondsToSelector:@selector(propertyName)] ? ((FLObjcProperty*)obj).propertyName.generatedName : [[obj methodName] generatedName]
            

- (void) writeCodeToSourceFile:(FLObjcFile*) file withCodeBuilder:(FLObjcCodeBuilder*) codeBuilder {

    [codeBuilder appendBlankLine];

    NSMutableSet* imports = [NSMutableSet set];
    [imports addObject:file.counterPartFileName];

    for(NSString* dependencyName in _dependencies) {
        FLObjcType* dependency = [self.project.typeRegistry typeForKey:dependencyName];
        
        if(FLStringIsNotEmpty(dependency.importFileName) && dependency.canForwardReference) {
            [imports addObject:dependency.importFileName];
        }
    }

    for(NSString* aImport in imports) {
        [codeBuilder appendImport:aImport];
    }

    
    [codeBuilder appendBlankLine];
    [codeBuilder appendImplementation:self.objectName.generatedName];

    [codeBuilder appendBlankLine];
    
    NSMutableArray* all = FLMutableCopyWithAutorelease([_properties allValues]);
    
    [all addObjectsFromArray:_methods];
    
    [all sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
    
        NSString* lhs = NameForSorting(obj1);
        NSString* rhs = NameForSorting(obj2);
        
        if([lhs hasPrefix:@"@"] && [rhs hasPrefix:@"@"]) {
            return [lhs compare:rhs];
        }
        else if([lhs hasPrefix:@"@"]) {
            return NSOrderedAscending;
        }
        else if([rhs hasPrefix:@"@"]) {
            return NSOrderedDescending;
        }

        return [lhs compare:rhs];
    }];
    
    for(id thing in all) {
        [thing writeCodeToSourceFile:file withCodeBuilder:codeBuilder];
    }

    [codeBuilder appendBlankLine];
    [codeBuilder appendEnd];
}

- (void) configureWithCodeObject:(FLCodeObject*) codeObject 
                      objectName:(FLObjcClassName*) objectName {

    self.objectName = objectName;
    self.codeObject = codeObject;

    [self addProtocols:codeObject];
    [self addSuperclass:codeObject superclass:nil];
    [self setObjectTypeWithInputProject:codeObject];
    [self addPropertiesWithInputObject:codeObject];
    [self addMethodsWithInputObject:codeObject];
    [self addConstructorsWithInputObject:codeObject];
    [self addStandardBaseClassMethodsWithInputObject:codeObject];
}

@end

@implementation FLObjcGeneratedBaseClass
- (FLObjcFile*) headerFile {
    return [self generatedHeaderFile];
}

- (FLObjcFile*) sourceFile {
    return [self generatedSourceFile];
}


- (void) configureWithCodeObject:(FLCodeObject*) codeObject {

    FLObjcGeneratedBaseClassName* baseClassName =
        [FLObjcGeneratedBaseClassName objcGeneratedClassName:codeObject.name
                                                  prefix:self.project.classPrefix];
    
    [super configureWithCodeObject:codeObject objectName:baseClassName];
}


@end

@implementation FLObjcGeneratedObject

- (BOOL) includeInAllFiles {
    return YES;
}

- (FLObjcFile*) headerFile {
    return [self generatedHeaderFile];
}

- (FLObjcFile*) sourceFile {
    return [self generatedSourceFile];
}

- (void) configureWithCodeObject:(FLCodeObject*) codeObject {
    FLObjcClassName* objectName = [FLObjcClassName objcClassName:codeObject.name prefix:self.project.classPrefix];
    [self configureWithCodeObject:codeObject objectName:objectName];
    [self addClassConstructorsWithInputObject:codeObject toObject:self];
}

@end

@implementation FLObjcUserObject : FLObjcObject

- (BOOL) includeInAllFiles {
    return YES;
}

- (FLObjcFile*) headerFile {
    return [self userHeaderFile];
}

- (FLObjcFile*) sourceFile {
    return [self userSourceFile];
}

- (void) configureWithCodeObject:(FLCodeObject*) codeObject
                       baseClass:(FLObjcGeneratedBaseClass*) baseClass {

    self.objectName = [FLObjcClassName objcClassName:codeObject.name
                                                         prefix:self.project.classPrefix];
    self.superclassType = baseClass.objectType;
    [self addDependency:baseClass.superclassType];
    [self addClassConstructorsWithInputObject:codeObject toObject:baseClass];
}

@end