//
//  FLJsonNetworkOperationBehavior.m
//  FishLamp
//
//  Created by Mike Fullerton on 5/13/11.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton.
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLJsonHttpRequest.h"
#import "FLJsonParser.h"

#import "FLHttpRequestBody.h"
#import "FLHttpResponse.h"

@implementation FLJsonHttpRequest

@synthesize outputObject = _outputObject;
@synthesize json = _json;

- (id) init {
    self = [super init];
    if(self) {
    }
    return self;
}


#if FL_MRC
- (void) dealloc {
    [_outputObject release];
	[_json release];
    [super dealloc];
}
#endif

- (void) willOpen {
//    if(self.json && self.json.lines.count > 0) {

        FLPrettyString* jsonString = [FLPrettyString prettyString:nil];
        [jsonString appendString:self.json];
                         
        NSData* content = [jsonString.string dataUsingEncoding:NSUTF8StringEncoding];
        
        [self.requestBody setContentWithData:content typeContentHeader:@"application/json; charset=utf-8"];
//    }
}

- (id) convertResponseToPromisedResult:(FLHttpResponse *)httpResponse {

    
    if(!_outputObject) {
        _outputObject = [NSMutableDictionary dictionary];
    }
    
    id jsonObject = [[FLJsonParser jsonParser] parseData:[[httpResponse responseData] data]];
    
    
    
    
//    id result = [parser parseJsonData:[httpResponse responseData] rootObject:_outputObject withDecoder:self.dataDecoder];
//
//    FLThrowIfError(parser.error);
    
//    [httpResponse throwHttpErrorIfNeeded];
    
    return jsonObject;
}

@end

