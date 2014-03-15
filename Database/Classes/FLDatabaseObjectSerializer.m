//
//  FLDatabaseColumnData.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 5/9/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLDatabaseObjectSerializer.h"
#import "FLDatabase.h"

@interface FLDatabaseObjectSerializer ()
@property (readwrite, strong, nonatomic) id object;
@end

@implementation FLDatabaseObjectSerializer 
@synthesize object = _object;
@synthesize objectClass = _objectClass;

#if FL_MRC
- (void) dealloc {
	[_object release];
	[super dealloc];
}
#endif

- (id) initWithObject:(id) object {	
	self = [super init];
	if(self) {
		_object = FLRetain(object);
        _objectClass = [object class];
	}
	return self;
}

+ (id) objectSerializer:(id) object {
    return FLAutorelease([[[self class] alloc] initWithObject:object]);
}

- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if(self) {
        NSString* classString = [aDecoder decodeObjectForKey:@"objectClass"];
        if(FLStringIsNotEmpty(classString)) {
            _objectClass = NSClassFromString(classString);
            if(_objectClass) {
                self.object = [_objectClass objectWithDatabaseRepresentation:[aDecoder decodeObjectForKey:@"object"]];
            }
        }
    }
    return self;
}

- (void) encodeWithCoder:(NSCoder *)aCoder {
    if(_objectClass && _object) {
        [aCoder encodeObject:NSStringFromClass(_objectClass) forKey:@"objectClass"];
     
        id rep = [self.object databaseRepresentation];
        if(rep) {
            [aCoder encodeObject:rep forKey:@"object"];
        }
    }
}

@end
