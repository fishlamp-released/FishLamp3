//
//  FLHiddenFolderFileSink.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 3/31/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLFileSink.h"

@interface FLHiddenFolderFileSink : FLFileSink {
@private
    NSString* _folderPath;
    NSString* _tempFilePath;
    NSString* _destinationFilePath;
}

- (id) initWithFilePath:(NSString*) filePath folderPath:(NSString*) folderPath;

+ (id) hiddenFolderFileSink:(NSString*) filePath folderPath:(NSString*) folderPath;

@end
