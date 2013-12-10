//
//	FLFolder.h
//	FishLamp
//
//	Created by Mike Fullerton on 2/7/10.
//	Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampMinimum.h"


@class FLFolder;

typedef void (^FLFolderShouldDeleteFileVisitor)(NSString* fileName, BOOL* shouldDeleteFile, BOOL* stop);
typedef void (^FLFileVisitorBlock)(NSString* fileName, BOOL* stop);

@interface FLFolder : NSObject<NSCopying, NSCoding> {
@private
    NSString* _folderPath;
}

@property (readonly, strong) NSURL* folderURL;

@property (readonly, strong) NSString* folderPath;

- (id) initWithFolderPath:(NSString*) path;

- (id) initWithURL:(NSURL*) url;

+ (id) folderWithPath:(NSString*) path;

+ (id) folderWithURL:(NSURL*) url;

- (unsigned long long) calculateFolderSize:(FLFileVisitorBlock) operation 
                              outItemCount:(NSUInteger*) outItemCount;

- (void) deleteAllFiles:(FLFileVisitorBlock) visitor;

- (void) deleteFiles:(FLFolderShouldDeleteFileVisitor) shouldDeleteFileVisitor;

- (void) visitAllFiles:(FLFileVisitorBlock) visitorBlock;

- (BOOL) existsOnDisk;

- (NSString*) pathForFile:(NSString*) fileName;

- (void) createIfNeeded;

- (void) writeObjectToFile:(NSString*) fileName object:(id) object;

- (void) deleteFile:(NSString*) fileName;

- (id) readObjectFromFile:(NSString*) fileName;

- (void) writeDataToFile:(NSString*) fileName data:(NSData*) data;

- (NSData*) readDataFromFile:(NSString*) fileName;

- (void) moveFilesToFolder:(FLFolder*) destinationFolder withCopy:(BOOL) copy;
	
- (BOOL) fileExistsInFolder:(NSString*) name;

- (NSDate*) dateCreatedForFile:(NSString*) name;

- (NSDate*) dateModifiedForFile:(NSString*) name;

- (unsigned long long) sizeForFileName:(NSString*) name;

- (NSArray*) allPathsInFolder;

#if IOS
- (void) addSkipBackupAttributeToFile:(NSString*) name;
#endif

- (NSUInteger) countItems:(BOOL) recursive;

- (NSString*) fileUTI:(NSString*) name;

@end



