//
//  FLJsonObjectBuilder.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 3/26/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampCore.h"

@class FLStringToObjectConversionManager;

@interface FLJsonObjectBuilder : NSObject {
@private
    FLStringToObjectConversionManager* _decoder;
}
@property (readonly, strong,nonatomic) FLStringToObjectConversionManager* decoder;

- (id) initWithDataDecoder:(FLStringToObjectConversionManager*) decoder;
+ (id) jsonObjectBuilder:(FLStringToObjectConversionManager*) decoder;
+ (id) jsonObjectBuilder;

- (NSArray*) arrayOfObjectsFromJSON:(id) jsonObject withTypeDescs:(NSArray*) arrayOfObjectDescriber;
- (NSArray*) arrayOfObjectsFromJSON:(id) json expectedRootObjectClass:(Class) type;
- (id) objectFromJSON:(id) parsedJson expectedRootObjectClass:(Class) type;

@end