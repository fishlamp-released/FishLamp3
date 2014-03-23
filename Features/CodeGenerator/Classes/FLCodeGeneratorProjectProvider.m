//
//  FLObjcCodeGenerator+GenerateFromFile.m
//  FishLampCodeGenerator
//
//  Created by Mike Fullerton on 6/17/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLCodeGeneratorProjectProvider.h"

#import "FLCodeProjectReader.h"
#import "FLXmlCodeProjectReader.h"
#import "FLWsdlCodeProjectReader.h"
#import "FLJsonCodeProjectReader.h"
#import "FLCodeProject.h"
#import "FLCodeGenerator.h"

@interface FLCodeGeneratorProjectProvider ()
@property (readwrite, strong, nonatomic) NSURL* url;
@end

@implementation FLCodeGeneratorProjectProvider

@synthesize url = _url;

- (id) initWithURL:(NSURL*) url {
	self = [super init];
	if(self) {
		self.url = url;
	}
	return self;
}

+ (id) codeGeneratorProjectProvider:(NSURL*) url {
    return FLAutorelease([[[self class] alloc] initWithURL:url]);
}

#if FL_MRC
- (void)dealloc {
	[_url release];
	[super dealloc];
}
#endif

- (FLCodeProject*) readProjectForCodeGenerator:(id<FLCodeGenerator>) codeGenerator {
    FLCodeProjectReader* reader = [FLCodeProjectReader codeProjectReader];
    [reader addFileReader:[FLXmlCodeProjectReader xmlCodeProjectReader]];
    [reader addFileReader:[FLWsdlCodeProjectReader wsdlCodeReader]];
    return [reader readProjectFromFileURL:self.url];
}


@end
