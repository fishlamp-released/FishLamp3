//
//	FLFolder.m
//	FishLamp
//
//	Created by Mike Fullerton on 2/7/10.
//	Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLFolder.h"
#import "NSFileManager+FLExtras.h"

#if OSX
#import <CoreServices/CoreServices.h>
#else
#import <MobileCoreServices/MobileCoreServices.h>
#endif

@interface FLFolder ()
@property (readwrite, strong) NSString* folderPath;
@end

@implementation FLFolder

@synthesize folderPath = _folderPath;

- (NSURL*) folderURL {
    return [NSURL fileURLWithPath:self.folderPath isDirectory:YES];
}

- (id) init {
	if((self = [self initWithURL:nil])) {
	}
	
	return self;
}

- (id) initWithURL:(NSURL*) url {
	return [self initWithFolderPath:url.absoluteString];
}

- (id) initWithFolderPath:(NSString*) path {
    self = [super init];
    if(self) {
        _folderPath = FLRetain(path);
    }
    return self;
}

+ (id) folderWithPath:(NSString*) path  {
    return FLAutorelease([[[self class] alloc] initWithFolderPath:path]);
}

+ (id) folderWithURL:(NSURL*) url {
    return FLAutorelease([[[self class] alloc] initWithURL:url]);
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if(self) {
        FLSetObjectWithRetain(_folderPath, [aDecoder decodeObjectForKey:@"folderPath"]);
    }   

    return self;
}

- (void) encodeWithCoder:(NSCoder*) aCoder {
    [aCoder encodeObject:_folderPath forKey:@"folderPath"];
}

- (id)copyWithZone:(NSZone *)zone {
    return [[[self class] alloc] initWithFolderPath:FLCopyWithAutorelease(self.folderURL)];
}
    
#if FL_MRC
- (void) dealloc {
    [_folderPath release];
	[super dealloc];
}
#endif

- (void) deleteAllFiles:(FLFileVisitorBlock) visitor {
    [self deleteFiles:^(NSString* fileName, BOOL* shouldDeleteFile, BOOL* stop){
        *shouldDeleteFile = YES;
        if(visitor) {
            visitor(fileName, stop);
        }
    }];
}

- (NSArray*) allPathsInFolder {
    NSError* err = nil;
    NSArray* everything = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[self folderPath] error:&err];
    if(err) {
        FLThrowIfError(FLAutorelease(err));
    }
    
    return everything;
}

- (void) visitAllFiles:(FLFileVisitorBlock) visitorBlock
{
	if([self existsOnDisk] && visitorBlock)
	{
        NSError* err = nil;
		NSArray* everything = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[self folderPath] error:&err];
        if(err) {
           FLThrowIfError(FLAutorelease(err));
        }
		__block BOOL stop = NO;
        for(NSString* name in everything) {
            FLAutoreleasePool(
                visitorBlock(name, &stop);
            )
            
            if(stop) {
                break;
            }
        }
    }
}

- (void) deleteFiles:(FLFolderShouldDeleteFileVisitor) shouldDeleteFileBlock
{
	if([self existsOnDisk] && shouldDeleteFileBlock)
	{
        NSError* err = nil;
		NSArray* everything = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[self folderPath] error:&err];
        if(err) {
           FLThrowIfError(FLAutorelease(err));
        }
		
        for(NSString* name in everything) {
            BOOL shouldDelete = NO;
            BOOL stop = NO;
            shouldDeleteFileBlock(name, &shouldDelete, &stop);
            if(shouldDelete) {
                [[NSFileManager defaultManager] removeItemAtPath: 
                    [[self folderPath] stringByAppendingPathComponent:name] error:&err];
                
                if(err) {
                   FLThrowIfError(FLAutorelease(err));
                }
            }
            
            if(stop) {
                break;
            }
        }
        
#if DEBUG
    NSArray* everything2 = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[self folderPath] error:&err];
    FLLog(@"After delete, %ld items left", (unsigned long) everything2.count);
#endif         
	}
}



- (unsigned long long) calculateFolderSize:(FLFileVisitorBlock) visitor
                              outItemCount:(NSUInteger*) outItemCount
{
	__block unsigned long long size = 0;
	
	if([self existsOnDisk]) {
        NSError* err = nil;
        NSDictionary* folderAttr = [[NSFileManager defaultManager] attributesOfItemAtPath:[self folderPath] error:&err];
        if(err) {
           FLThrowIfError(FLAutorelease(err));
        }
        
        size = [[folderAttr objectForKey:NSFileSize] longValue];
        
        NSArray* everything = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[self folderPath] error:&err];
        if(err) {
           FLThrowIfError(FLAutorelease(err));
        }

        if(outItemCount) {
            *outItemCount = everything.count; 
        }
        
        __block BOOL stop = NO;
        for(NSString* path in everything) {
            
            FLAutoreleasePool(
                NSError* innerErr = nil;
                NSDictionary* attr = [[NSFileManager defaultManager] attributesOfItemAtPath:
                    [[self folderPath] stringByAppendingPathComponent:path] error:&innerErr];

                if(innerErr) {
                   FLThrowIfError(FLAutorelease(innerErr));
                }
            
                size += [[attr objectForKey:NSFileSize] longLongValue];
                
                if(visitor) {
                    visitor(path, &stop);
                }
            )

            if(stop) {
                break;
            }
        }
        
	}
	return size;
}

- (NSDate*) dateCreatedForFile:(NSString*) fileName {
	NSError* err = nil;
	NSDictionary* attr = [[NSFileManager defaultManager] attributesOfItemAtPath:[self pathForFile:fileName] error:&err];
    if(err) {
       FLThrowIfError(FLAutorelease(err));
    }

	return [attr objectForKey:NSFileCreationDate];
}

- (NSDate*) dateModifiedForFile:(NSString*) fileName {
	NSError* err = nil;
	NSDictionary* attr = [[NSFileManager defaultManager] attributesOfItemAtPath:[self pathForFile:fileName] error:&err];
	
    if(err) {
       FLThrowIfError(FLAutorelease(err));
    }

	return [attr objectForKey:NSFileModificationDate];
}

- (unsigned long long) sizeForFileName:(NSString*) fileName {
	NSError* err = nil;
	NSDictionary* attr = [[NSFileManager defaultManager] attributesOfItemAtPath:[self pathForFile:fileName] error:&err];
    if(err) {
       FLThrowIfError(FLAutorelease(err));
    }

	return [[attr objectForKey:NSFileSize] longLongValue];
}

- (void) createIfNeeded {
	NSError* err = nil;
	BOOL isDirectory;
	if(![[NSFileManager defaultManager] fileExistsAtPath: [self folderPath] isDirectory:&isDirectory]) {
		[[NSFileManager defaultManager] createDirectoryAtPath: [self folderPath] withIntermediateDirectories:YES attributes:nil error:&err];
        
        if(err) {
           FLThrowIfError(FLAutorelease(err));
        }
    }
}

- (NSString*) pathForFile:(NSString*) fileName {
	FLAssertStringIsNotEmptyWithComment(fileName, nil);
	return [self.folderPath stringByAppendingPathComponent:fileName];
}

- (BOOL) existsOnDisk {
	BOOL isDirectory = NO;
	return [[NSFileManager defaultManager] fileExistsAtPath: [self folderPath] isDirectory:&isDirectory];
}

- (void) deleteFile:(NSString*) fileName {
	FLAssertStringIsNotEmptyWithComment(fileName, nil);

	NSError* error = nil;
	[[NSFileManager defaultManager] removeItemAtPath:[self pathForFile:fileName] error:&error];
	if(error) {
        FLThrowIfError(FLAutorelease(error));
    }
}

- (void) writeObjectToFile:(NSString*) fileName object:(id) object {
	FLAssertStringIsNotEmptyWithComment(fileName, nil);
	FLAssertIsNotNilWithComment(object, nil);

	NSData* data = [NSKeyedArchiver archivedDataWithRootObject:object];
	[self writeDataToFile:fileName data:data]; 
}

- (id) readObjectFromFile:(NSString*) fileName {
	FLAssertStringIsNotEmptyWithComment(fileName, nil);
    NSData* data = [self readDataFromFile:fileName];
	if(data) {
        return [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }

    return nil;
}

- (void) writeDataToFile:(NSString*) fileName data:(NSData*) data {
	FLAssertStringIsNotEmptyWithComment(fileName, nil);
	FLAssertIsNotNilWithComment(data, nil);
	
	NSError* error = nil;
	[data writeToFile:[self pathForFile:fileName] options:NSAtomicWrite error:&error];
	FLThrowIfError(FLAutorelease(error));
}

- (NSData*) readDataFromFile:(NSString*) fileName {
	FLAssertStringIsNotEmptyWithComment(fileName, nil);

	NSString* path = [self pathForFile:fileName];

    NSError* error = nil;
	NSData* data = [NSData dataWithContentsOfFile:path options:0 error:&error];

    if(error) {
    
// TODO: WTF: this is already autoreleased???
/*        FLAutorelease(error); */ 
        
        if(![error isErrorCode:NSFileReadNoSuchFileError domain:NSCocoaErrorDomain]) {
            FLThrowIfError(error);
        }
    }
    
    
    return data;
}

- (void) moveFilesToFolder:(FLFolder*) destinationFolder withCopy:(BOOL) copy {
	FLAssertIsNotNilWithComment(destinationFolder, nil);

	FLAutoreleasePool(

		if(![self existsOnDisk] || ![destinationFolder existsOnDisk]) {
			FLThrowIfError( FLAutorelease([[NSError alloc] initWithDomain:NSCocoaErrorDomain code:NSFileNoSuchFileError userInfo:nil]));
		}
		
        NSError* err = nil;
		NSFileManager* fileMgr = [NSFileManager defaultManager];
		NSArray* everything = [fileMgr contentsOfDirectoryAtPath:[self folderPath] error:&err];
        if(err) {
           FLThrowIfError(FLAutorelease(err));
        }

		NSString* destFolder = destinationFolder.folderPath;
		NSString* srcFolder = self.folderPath;
		
		for(NSString* file in everything) {
			NSString* src =		[srcFolder stringByAppendingPathComponent:file];
			NSString* dest =	[destFolder stringByAppendingPathComponent:file];
		
			if([fileMgr fileExistsAtPath:dest]) {
				continue;
			}
		
			if(copy) {
				[fileMgr copyItemAtPath:src toPath:dest error:&err];
			}
			else {
				[fileMgr moveItemAtPath:src toPath:dest error:&err];
			}
			
            if(err) {
               FLThrowIfError(FLAutorelease(err));
            }
        }
    )
}

- (BOOL) fileExistsInFolder:(NSString*) name {
	FLAssertStringIsNotEmptyWithComment(name, nil);

	return [[NSFileManager defaultManager] fileExistsAtPath:[self pathForFile:name]];
}

#if IOS
- (void) addSkipBackupAttributeToFile:(NSString*) name {
    [NSFileManager addSkipBackupAttributeToFile:[self pathForFile:name]];
}
#endif

- (NSUInteger) countItems:(BOOL) recursive {
    return [[NSFileManager defaultManager] countItemsInDirectory:self.folderPath recursively:recursive visibleItemsOnly:YES];
}

- (NSString*) fileUTI:(NSString*) name {

    NSString* extension = [[self pathForFile:name] pathExtension];
    FLConfirmStringIsNotEmptyWithComment(extension, @"failed to get file extension for %@", name);
    
    NSString* UTI = FLAutorelease(FLBridgeTransfer(NSString*, UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension,  FLBridge(CFStringRef, extension), NULL)));

    FLConfirmNotNilWithComment(UTI, @"failed to get UTI for extension for file %@", name);

    return UTI;
                    
}

@end

                                                   

