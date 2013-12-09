//
//	FLFolderFile.h
//	PackMule
//
//	Created by Mike Fullerton on 11/8/10.
//	Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampMinimum.h"

#import "FLFolder.h"

@interface FLFolderFile : NSObject<NSCopying> {
@private
	NSString* _fileName;
	FLFolder* _folder;
}

- (id) initWithFolder:(FLFolder*) folder fileName:(NSString*) fileName;

@property (readwrite, strong, nonatomic) FLFolder* folder;
@property (readwrite, strong, nonatomic) NSString* fileName; 
@property (readonly, strong, nonatomic) NSString* filePath;
@property (readonly, assign) unsigned long long fileSize;

- (id) readObjectFromFile;
- (NSData*) readDataFromFile;

- (void) writeDataToFile:(NSData*) data;
- (void) writeObjectToFile:(id) object;

- (void) deleteFile;
- (BOOL) fileExists;

- (NSInputStream*) createReadStream;

@end
