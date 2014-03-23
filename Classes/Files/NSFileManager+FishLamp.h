//
//	NSFileManager+FishLamp
//	FishLamp
//
//	Created by Mike Fullerton on 6/20/09.
//	Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampCore.h"

typedef void (^FLFileManagerVisitor)(NSString* filePath, BOOL* stop);

@interface	NSFileManager (FishLamp)

+ (BOOL) getFileSize:(NSString*) filePath 
	outSize:(unsigned long long*) outSize
	outError:(NSError**) outError;
	
+ (void) moveFolderContents:(NSString*) fromFolder toFolder:(NSString*) toFolder;

+ (NSString*) timeStampedName:(NSString*) baseName	optionalExtension:(NSString*) extension;

+ (BOOL) createDirectoryIfNeeded:(NSString*) path;

+ (unsigned long long) availableDiskSpace;

+ (unsigned long long) diskSize;

- (NSUInteger) countItemsInDirectory:(NSString*) path 
                         recursively:(BOOL) recursively
                    visibleItemsOnly:(BOOL) visibleItemsOnly;

- (BOOL) itemIsDirectory:(NSString*) path;

- (void) visitEachItemAtPath:(NSString*) path
                 recursively:(BOOL) recursively
            visibleItemsOnly:(BOOL) visibleItemsOnly
                     visitor:(FLFileManagerVisitor) visitor;

#if IOS
+ (void) addSkipBackupAttributeToFile:(NSString*) filePath;
#endif 
@end

