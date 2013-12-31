//
//  FLObjcCodeBuilder+FLCodeElement.m
//  FishLampCodeGenerator
//
//  Created by Mike Fullerton on 6/19/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLObjcCodeBuilder+FLCodeElement.h"

#import "FLObjcType.h"
#import "FLObjcCodeBuilder.h"
#import "FLObjcProject.h"
#import "FLObjcTypeRegistry.h"
#import "FLObjcCodeGeneratorHeaders.h"

@implementation NSObject (FLObjcCodeWriter)
- (NSString*) stringForObjcProject:(FLObjcProject*) project {
    return nil;
}
@end

@implementation FLObjcCodeBuilder (FLObjcCodeWriter)

- (void) appendCodeElement:(FLCodeElement*) codeElement
               withProject:(FLObjcProject*) project {

    [self appendLine:[codeElement stringForObjcProject:project]];
}
@end


@implementation NSString (FLObjcCodeWriter)
- (NSString*) stringForObjcProject:(FLObjcProject*) project {
    return self;
}
@end

@implementation FLCodeElement (FLObjcCodeWriter)
- (NSString*) stringForObjcProject:(FLObjcProject*) project {
    FLAssertFailedWithComment(@"this is supposed to be overridden to do something");
    return nil;
}
@end


@implementation FLCodeString (FLObjcCodeWriter)
- (NSString*) stringForObjcProject:(FLObjcProject*) project {

    NSString* string = [self.string stringForObjcProject:project];

    if([string hasPrefix:@"@\""] && [string hasSuffix:@"\""]) {
        return string;
    }

    return [NSString stringWithFormat:@"@\"%@\"", string];
}
@end

@implementation FLCodeCreateObject (FLObjcCodeWriter)
- (NSString*) stringForObjcProject:(FLObjcProject*) project {
    FLObjcType* theType = [project.typeRegistry typeForKey:[self.objectType stringForObjcProject:project]];
    return [NSString stringWithFormat:@"FLAutorelease([[%@ alloc] init])", theType.generatedName];
}
@end

@implementation FLCodeReturn (FLObjcCodeWriter)
- (NSString*) stringForObjcProject:(FLObjcProject*) project {
    return [NSString stringWithFormat:@"return %@", [self.returns stringForObjcProject:project]];
}
@end

@implementation FLCodeClassName (FLObjcCodeWriter)

- (NSString*) stringForObjcProject:(FLObjcProject*) project {

    FLObjcType* type = [project.typeRegistry typeForKey:[self.className stringForObjcProject:project]];

//    FLObjcName* className = type.typeName;

//    [FLObjcClassName objcClassName: prefix:project.classPrefix];
    return [type generatedName];
}

@end

@implementation FLCodeStatement (FLObjcCodeWriter)
- (NSString*) stringForObjcProject:(FLObjcProject*) project {
   return [NSString stringWithFormat:@"%@;", [self.statement stringForObjcProject:project]];
}
@end

@implementation FLCodeGetPropertyValue (FLObjcCodeWriter) 
- (NSString*) stringForObjcProject:(FLObjcProject*) project {
   return [NSString stringWithFormat:@"[%@ %@]", 
                [self.object stringForObjcProject:project], 
                [self.property stringForObjcProject:project]];
}
@end

@implementation FLCodePropertyName (FLObjcCodeWriter) 
- (NSString*) stringForObjcProject:(FLObjcProject*) project {
    
    FLObjcPropertyName* propertyName = [FLObjcPropertyName objcPropertyName:[self.propertyName stringForObjcProject:project]];
    return [propertyName generatedName];
}
@end

@implementation FLCodeObjectReference (FLObjcCodeWriter)
- (NSString*) stringForObjcProject:(FLObjcProject*) project {
   return [self.object stringForObjcProject:project];
}
@end

@implementation FLCodeObjectSelfReference  (FLObjcCodeWriter)
- (NSString*) stringForObjcProject:(FLObjcProject*) project {
   return @"self";
}
@end
