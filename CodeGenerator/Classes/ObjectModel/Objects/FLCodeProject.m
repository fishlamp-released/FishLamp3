// 
// FLCodeProject.m
// 
// Modifications are expected. File will not be overwritten.
// Generated by: Mike Fullerton @ 6/15/13 4:24 PM with PackMule (3.0.0.29)
// 
// Project: FishLamp Code Generator
// 
// Copyright 2013 (c) GreenTongue Software LLC, Mike Fullerton
// The FishLamp Framework is released under the MIT License: http://fishlamp.com/license
// 

#import "FLCodeProject.h"
#import "FLCodeProjectBaseClass.h"
#import "FLCodeImport.h"
#import "FLModelObject.h"
#import "FLCodeGeneratorOptions.h"
#import "FLCodeObject.h"
#import "FLCodeProperty.h"
#import "FLCodeProjectLocation.h"
#import "FLCodeProjectInfo.h"
#import "FLCodeProjectReader.h"

@interface FLCodeProject ()
@property (readwrite, assign, nonatomic) FLCodeProject* parent;
@end

@implementation FLCodeProject
@synthesize projectPath = _projectPath;
@synthesize projectLocation = _projectLocation;
@synthesize parent = _parent;

+ (id) codeProject {
    return FLAutorelease([[[self class] alloc] init]);
}
#if FL_MRC
- (void) dealloc {
    [_subProjects release];
    [_projectLocation release];
    [_projectPath release];
    [super dealloc];
}
#endif

- (NSString*) projectFolderPath {
//    return [[self.projectPath path] stringByDeletingLastPathComponent];

    return [self.projectPath stringByDeletingLastPathComponent];
}

- (void) addSubProject:(FLCodeProject*) subProject {
    if(!_subProjects) {
        _subProjects = [[NSMutableDictionary alloc] init];
    }

    [_subProjects setObject:subProject forKey:subProject.projectPath];
    subProject.parent = self;
    


//    FLMergeObjects(self, subproject, FLMergeModePreserveDestination);
}

- (void) addSubProjectsToDictionary:(NSMutableDictionary*) subprojects {
    for(NSString* path in _subProjects) {
        [subprojects setObject:[_subProjects objectForKey:path] forKey:path];
    }
    for(FLCodeProject* project in [_subProjects objectEnumerator]) {
        [project addSubProjectsToDictionary:subprojects];
    }
}

- (void) mergeWithSubprojects {

    NSMutableDictionary* flattened = [NSMutableDictionary dictionary];
    for(FLCodeProject* project in _subProjects) {
        [self addSubProjectsToDictionary:flattened];
    }
    for(FLCodeProject* project in [flattened objectEnumerator]) {
        FLMergeObjects(self, project, FLMergeModePreserveDestination);
    }

    if(self.options.canLazyCreate) {
        for(FLCodeObject* object in self.classes) {
            object.canLazyCreate = YES;
        }
    }

    for(FLCodeObject* object in self.classes) {
        if(object.canLazyCreate) {
            for(FLCodeProperty* prop in object.properties) {
                prop.canLazyCreate = YES;
            }
        }
    }

    [_subProjects removeAllObjects];
}

- (void) loadSubProjectsWithProjectReader:(FLCodeProjectReader*) reader {
    for(FLCodeImport* aImport in self.imports) {

        FLCodeProjectLocation* location = [FLCodeProjectLocation codeProjectLocationWithImport:aImport
                                                                             pathToProjectFolder:self.projectFolderPath];

        FLCodeProject* subProject = [reader readProjectFromLocation:location];

        if(subProject) {
            [self addSubProject:subProject];
        }
	}
}

- (void) didLoadFromLocation:(FLCodeProjectLocation*) location
           withProjectReader:(FLCodeProjectReader*) reader {
           
    self.projectLocation = location;
    self.projectPath = location.URL.path;
    
	if(FLStringIsEmpty(self.info.projectName)){
		self.info.projectName = [[self.projectPath lastPathComponent] stringByDeletingPathExtension];
	}

    self.info.projectName = [self.info.projectName stringByReplacingOccurrencesOfString:@"." withString:@"_"];
	FLConfirmStringIsNotEmpty(self.info.projectName, @"project needs to be named - <description name='foo'/>");

//    if(FLStringIsEmpty(project.schemaName)) {
//        project.schemaName = [[project.projectPath lastPathComponent] stringByDeletingPathExtension];
//    }

    [self loadSubProjectsWithProjectReader:reader];
    [self mergeWithSubprojects];
}

@end
