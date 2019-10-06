//
//  FLSoapParser.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 3/13/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLSoapParser.h"

@implementation FLSoapParser 

+ (id) soapParser {
    return FLAutorelease([[[self class] alloc] init]);
}

- (void) willParseXMLData:(NSData*) data withXMLParser:(NSXMLParser*) parser {
	[parser setShouldProcessNamespaces:YES];
	[parser setShouldReportNamespacePrefixes:YES];
	[parser setShouldResolveExternalEntities:NO];
}

- (NSDictionary*) bodyContentsForDictionary:(NSDictionary*) soap {
    NSDictionary* outDict = [soap objectForKey:@"Envelope"];
    outDict = [outDict objectForKey:@"Body"];
    outDict = [[outDict allValues] objectAtIndex:0];
    return outDict;
}



@end
