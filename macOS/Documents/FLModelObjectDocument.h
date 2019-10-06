//
//  FLModelObjectDocument.h
//  FishLampOSX
//
//  Created by Mike Fullerton on 5/2/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampOSX.h"

#import "FLModelObject.h"

@interface FLModelObjectDocument : NSDocument {
@private
    id _modelObject;
}
@property (readwrite, strong, nonatomic) id modelObject;

@end
