//
//  WhittleJsonReader.m
//  WhittleJsonReader
//
//  Created by Mike Fullerton on 6/24/12.
//  Copyright (c) 2012 GreenTongue Software. All rights reserved.
//

#import "FLJsonCodeProjectReader.h"
#import "FLJsonParser.h"
#import "FLCodeProject.h"
#import "FLCodeProjectLocation.h"

@implementation FLJsonCodeProjectReader

+ (FLJsonCodeProjectReader*) jsonCodeProjectReader  {
    return FLAutorelease([[[self class] alloc] init]);
}

- (FLCodeProject *) parseProjectFromData:(NSData*) data fromURL:(NSURL*) url {

    id jsonObject = nil;
    @try {
        jsonObject = [[FLJsonParser jsonParser] parseData:data];
    }
    @catch(NSException* ex) {
    
    }
    
// The FLCodeProject is the "code model document". We're creating an empty one here as the root object.
// The parser should fill in the suborinate data as it parses the Json.
    
//    NSData* jsonData = [descriptor loadDataInResource];
//   
//    FLCodeProject * project = [FLCodeProject project];
//    FLJsonParser* parser = [FLJsonParser jsonParser];
//    [parser parseJsonData:jsonData rootObject:project withDecoder:nil];
//    return project;

    return nil;
}

@end

