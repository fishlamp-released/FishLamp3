//
//  FLXmlStringEncoding.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 5/11/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLStringToObjectConverting.h"
#import "NSString+XML.h"

@interface FLXmlStringEncoder : FLStringToObjectConverter
+ (id) xmlStringEncoder;
@end

@interface FLXmlURLStringEncoder : FLURLStringToNSURLObjectConverter
+ (id) xmlURLStringEncoder;
@end
