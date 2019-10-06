//
//  XmlCodeReader.h
//  XmlCodeReader
//
//  Created by Mike Fullerton on 6/16/12.
//  Copyright (c) 2012 GreenTongue Software. All rights reserved.
//

#import "FishLampCore.h"
#import "FLCodeProjectReader.h"

@interface FLXmlCodeProjectReader : NSObject<FLCodeProjectReader>

+ (FLXmlCodeProjectReader*) xmlCodeProjectReader;

@end
