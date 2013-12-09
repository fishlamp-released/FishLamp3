//
//  FLDatabase+FLTestCase.h
//  Fishlamp
//
//  Created by Mike Fullerton on 6/20/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLDatabase.h"
#import "FishLampMinimum.h"
#import "FLTestable.h"

@interface FLDatabaseTests : FLTestable {
@private
    id _database;
}
- (id) createDatabase:(NSString*) filePath;
@property (readonly, strong, nonatomic) id database;

@end

