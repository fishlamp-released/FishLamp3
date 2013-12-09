//
//  FLJson.m
//  FishLamp
//
//  Created by Mike Fullerton on 5/12/11.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton.
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLJsonParser.h"

@implementation FLJsonParser

+ (FLJsonParser*) jsonParser {
    return FLAutorelease([[FLJsonParser alloc] init]);
}

- (id) parseData:(NSData*) data {
#if __MAC_10_8
    NSError* error = nil;
    id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    FLThrowIfError(object);
    return object;
#else
    return nil;
#endif
}

- (id) parseFileAtPath:(NSString*) path {
    return [self parseFileAtURL:[NSURL fileURLWithPath:path]];
}

- (id) parseFileAtURL:(NSURL*) url {
    NSError* err = nil;
    NSData* data = [NSData dataWithContentsOfURL:url options:0  error:&err];
    FLThrowIfError(FLAutorelease(err));
        
    return [self parseData:data];
}

+ (BOOL) canParseData:(NSData*) data {
#if __MAC_10_8
    NSError* error = nil;
    id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    return object != nil && error == nil;
#else 
    return NO;
#endif    
}

//#if REFACTOR
//#if FL_ARC
//    SBJsonParser* parser = [[SBJsonParser alloc] init];
//    
//    id outObject = [parser objectWithData:data];			
//    
//    if(FLStringIsNotEmpty(parser.error))
//    {	
//        FLLog(@"JSON parse failed: %@", parser.error);
//
//        self.error = [NSError errorWithDomain:FLJsonParserErrorDomain code:FLJsonParserParseFailedErrorCode localizedDescription:parser.error]; 
//
//        
//        outObject = nil;
//    }
//    else
//    {
//        if(rootObject) {
//            FLObjectBuilder* builder = [[FLObjectBuilder alloc] init];  
//            [builder buildObjectsFromDictionary:outObject withRootObject:rootObject withDecoder:decoder];
//            FLRelease(builder);
//            
//            outObject = rootObject;
//        }
//    }    
//    
//    FLRelease(parser);
//    return outObject;
//#endif
//#endif
//    
//    FLAssertIsImplementedWithComment(@"SBJson requires ARC");
//    
//    return nil;
//}

@end
