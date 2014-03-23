//
//  FLObjcCodeGenerator+GenerateFromFile.h
//  FishLampCodeGenerator
//
//  Created by Mike Fullerton on 6/17/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FishLampCore.h"

@class FLCodeProject;
@protocol FLCodeGenerator;

@protocol FLCodeGeneratorProjectProvider <NSObject>
- (FLCodeProject*) readProjectForCodeGenerator:(id<FLCodeGenerator>) codeGenerator;
@end

@interface FLCodeGeneratorProjectProvider : NSObject<FLCodeGeneratorProjectProvider> {
@private
    NSURL* _url;
}

+ (id) codeGeneratorProjectProvider:(NSURL*) url;

@end
