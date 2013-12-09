//
//  FLObjectXmlElement.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 12/29/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLObjectXmlElement.h"
#import "FLXmlStringBuilder.h"

@interface FLObjectXmlElement ()
@property (readwrite, strong, nonatomic) id object;
@property (readwrite, strong, nonatomic) FLPropertyDescriber* propertyDescriber;

- (id) initWithObject:(id) object 
        xmlElementTag:(NSString*) xmlElementTag 
   xmlElementCloseTag:(NSString*) xmlElementCloseTag
    propertyDescriber:(FLPropertyDescriber*) propertyDescriber;

@end

@implementation FLObjectXmlElement

@synthesize object = _object;
@synthesize propertyDescriber = _propertyDescriber;

- (id) init {	
	return [self initWithObject:nil xmlElementTag:nil xmlElementCloseTag:nil propertyDescriber:nil];
}

- (id) initWithObject:(id) object 
        xmlElementTag:(NSString*) xmlElementTag 
   xmlElementCloseTag:(NSString*) xmlElementCloseTag
    propertyDescriber:(FLPropertyDescriber*) propertyDescriber {

    FLAssertNotNil(object);
    FLAssertNotNil(propertyDescriber);

    self = [super initWithXmlElementTag:xmlElementTag xmlElementCloseTag:xmlElementCloseTag];
    if(self) {
        _object = FLRetain(object);
        _propertyDescriber = FLRetain(propertyDescriber);
    }
    return self;
}

- (id) initWithObject:(id) object 
        xmlElementTag:(NSString*) xmlElementTag 
   xmlElementCloseTag:(NSString*) xmlElementCloseTag {
   
    return [self initWithObject:object
                  xmlElementTag:xmlElementTag
             xmlElementCloseTag:xmlElementCloseTag
              propertyDescriber:[FLPropertyDescriber propertyDescriber:xmlElementTag propertyClass:[object class]]];
}

- (id) initWithObject:(id) object
        xmlElementTag:(NSString*) xmlElementTag {

    return [self initWithObject:object
                  xmlElementTag:xmlElementTag
             xmlElementCloseTag:xmlElementTag
              propertyDescriber:[FLPropertyDescriber propertyDescriber:xmlElementTag propertyClass:[object class]]];
}

- (id) initWithObject:(id) object
        xmlElementTag:(NSString*) xmlElementTag
    propertyDescriber:(FLPropertyDescriber*) propertyDescriber {

    return [self initWithObject:object
                  xmlElementTag:xmlElementTag
             xmlElementCloseTag:xmlElementTag
              propertyDescriber:propertyDescriber];
}

+ (id) objectXmlElement:(id) object 
          xmlElementTag:(NSString*) xmlElementTag {

    return FLAutorelease([[[self class] alloc] initWithObject:object xmlElementTag:xmlElementTag]);
}

+ (id) objectXmlElement:(id) object 
          xmlElementTag:(NSString*) xmlElementTag 
     xmlElementCloseTag:(NSString*) xmlElementCloseTag {

    return FLAutorelease([[[self class] alloc] initWithObject:object
                                                xmlElementTag:xmlElementTag
                                           xmlElementCloseTag:xmlElementCloseTag]);
}

+ (id) objectXmlElement:(id) object
          xmlElementTag:(NSString*) xmlElementTag
      propertyDescriber:(FLPropertyDescriber*) propertyDescriber {

    return FLAutorelease([[[self class] alloc] initWithObject:object
                                                xmlElementTag:xmlElementTag
                                            propertyDescriber:propertyDescriber]);
}

#if FL_MRC
- (void) dealloc {
    [_object release];
    [_propertyDescriber release];
    [super dealloc];
}
#endif

- (void) didMoveToParent:(id) parent {
    FLAssertNotNil(parent);
    FLAssertNotNil(_object);
    FLAssertNotNil(_propertyDescriber);

    if(parent && _object) {
//        FLLog(@"Adding %@ to %@ parent with object %@", NSStringFromClass([self class]), NSStringFromClass([parent class]), [_object description]);
        [_object addToXmlElement:self propertyDescriber:_propertyDescriber];
    }
}

@end

