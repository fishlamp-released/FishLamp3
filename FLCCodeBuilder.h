//
//  FLCCodeBuilder.h
//  AssertWritingTool
//
//  Created by Mike Fullerton on 9/13/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLCStyleCodeBuilder.h"

@interface FLCCodeBuilder : FLCStyleCodeBuilder {
}


- (void) appendMacroDefine:(NSString*) name parameters:(NSArray*) parameters;
- (void) appendMacroCall:(NSString*) name parameters:(NSArray*) parameters;

@end

@interface FLCMacro : FLCCodeBuilder {
}
@end

@interface FLCComment : FLCCodeBuilder {
}
@end

@interface FLCDocumentationComment : FLCCodeBuilder {
}
@end
