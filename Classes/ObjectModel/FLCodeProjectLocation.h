//
//  FLInputDescriptor.h
//  Whittle
//
//  Created by Mike Fullerton on 6/27/12.
//  Copyright (c) 2012 GreenTongue Software. All rights reserved.
//

#import "FishLampCore.h"

@class FLCodeImport;

typedef enum {
    FLCodeProjectLocationTypeNone = 0,
    FLCodeProjectLocationTypeFile = (1 << 1),
    FLCodeProjectLocationTypeHttp = (1 << 2),
    FLCodeProjectLocationTypeWsdl = (1 << 3)
} FLCodeProjectLocationType;

@interface FLCodeProjectLocation : NSObject {
@private
    NSURL* _url;
    FLCodeProjectLocationType _locationType;
}
@property (readonly, strong, nonatomic) NSURL* URL;

@property (readonly, assign, nonatomic) FLCodeProjectLocationType locationType;

- (id) initWithURL:(NSURL*) url 
      resourceType:(FLCodeProjectLocationType) resourceType;

+ (id) codeProjectLocation:(NSURL*) url
                                  resourceType:(FLCodeProjectLocationType) inputType;

+ (id) codeProjectLocationWithImport:(FLCodeImport*) aImport
                 pathToProjectFolder:(NSString*) pathToProjectFolder;


- (BOOL) isLocationType:(FLCodeProjectLocationType) type;

- (NSData*) loadDataInResource;

- (BOOL) hasFileExtension:(NSString*) extension;

@end
