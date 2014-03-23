//
//	NSFileManager+FishLamp.m
//	FishLamp
//
//	Created by Mike Fullerton on 6/20/09.
//	Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "NSFileManager+FishLamp.h"

#import "FishLampCore.h"
#include <sys/param.h>
#include <sys/mount.h>
#include <sys/xattr.h>

@implementation NSFileManager (FishLamp)

+ (BOOL) getFileSize:(NSString*) filePath 
	outSize:(unsigned long long*) outSize
	outError:(NSError**) outError {
	if(outSize) {
		*outSize = 0;
	}

	if(![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
		if(outError) {
			*outError = [[NSError alloc] initWithDomain:NSCocoaErrorDomain code:NSFileNoSuchFileError userInfo:nil];
		}
		
		return NO;
	}
	
	NSError* err = nil;
	NSDictionary* attr = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:&err];

	if(err) {
		if(*outError) {
			*outError = err;
		}
		
		err = nil;
	
		return NO;
	}
	
	if(outSize) {
		*outSize = [[attr objectForKey:NSFileSize] unsignedLongLongValue];
	}

	return YES;
}

+ (void) moveFolderContents:(NSString*) fromFolder toFolder:(NSString*) toFolder {
// move visible contents of folder to archive folder
// we can't just move the folder because of the hidden .svn folder.

	NSError* err = nil;
	NSArray* contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:fromFolder error:&err];
    if(err) {
       FLThrowIfError(err);
    }
	
	for(NSString* item in contents) {
		if([item characterAtIndex:0] == '.') {// invisible file or folder
			continue;
		}
	
		NSString* srcPath = [fromFolder stringByAppendingPathComponent:item];
		NSString* destPath = [toFolder stringByAppendingPathComponent:item];
	
		[[NSFileManager defaultManager] moveItemAtPath:srcPath toPath:destPath error:&err];
        if(err) {
           FLThrowIfError(err);
        }
	}
}

+ (NSString*) timeStampedName:(NSString*) baseName optionalExtension:(NSString*) extension {
	NSDateComponents* parts = [[NSCalendar currentCalendar] components: 
			(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit |NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit)
			fromDate:[NSDate date]];
	return [NSString stringWithFormat:@"%@ (%.2ld.%.2ld.%.2ld-%.2ld.%.2ld.%.2ld)%@", baseName, 
				(long)parts.month,
				(long)parts.day,
				(long)parts.year,
				(long)parts.hour,
				(long)parts.minute,
				(long)parts.second,
				extension ? extension : @""];
}

//+ (NSString*) createUniqueFolder:(NSString*) folderName inParentFolder:(NSString*) parentPath {
//	NSString* newFolderPath = nil;
//
//	BOOL isDirectory = YES;
//	
//	// find unique name for archive folder
//	do {
//		NSDateComponents* parts = [[NSCalendar currentCalendar] components: 
//			(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit |NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit)
//			fromDate:[NSDate date]];
//		
//		newFolderPath = [parentPath stringByAppendingPathComponent:
//			[NSString stringWithFormat:@"%@ (%.2d.%.2d.%.2d-%.2d.%.2d.%.2d)", folderName, 
//				parts.month,
//				parts.day,
//				parts.year,
//				parts.hour,
//				parts.minute,
//				parts.second]];
//	} while([[NSFileManager defaultManager] fileExistsAtPath:newFolderPath isDirectory:&isDirectory] || !isDirectory);
//
//	NSError* err = nil;
//	
//	[[NSFileManager defaultManager] createDirectoryAtPath:newFolderPath withIntermediateDirectories:YES attributes:nil error:&err];
//    if(err)
//    {
//       FLThrowIfError(err);
//    }
//	
//	return newFolderPath;
//}

+ (BOOL) createDirectoryIfNeeded:(NSString*) path {
	BOOL isDirectory = false;
	if(![[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDirectory]) {
		NSError* err = nil;
	
		[[NSFileManager defaultManager] createDirectoryAtPath:path 
			withIntermediateDirectories:YES 
			attributes:nil 
			error:&err];
        
        if(err) {
           FLThrowIfError(err);
        }

	
		return YES;
	}
	
	return NO;
}

//+ (NSString*) cacheFolderPath:(NSString*) userId {
//	NSArray* paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
//	return [ [paths objectAtIndex: 0] stringByAppendingPathComponent:userId];
//}
//
//+ (NSString*) documentsFolderPath:(NSString*) userId {
//	NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//	return [ [paths objectAtIndex: 0] stringByAppendingPathComponent:userId];
//}
//
//+ (NSString*) documentsFilePath:(NSString*) fileName userName:(NSString*) userName {
//	return [[NSFileManager documentsFolderPath:userName] stringByAppendingPathComponent:fileName];
//}
//
//+ (NSString*) cachedFilePath:(NSString*) fileName userName:(NSString*) userName; {
//	return [[NSFileManager cacheFolderPath:userName] stringByAppendingPathComponent:fileName];
//}

#if IOS
//+ (void) createUserFoldersIfNeeded:(NSString*) userId {
//	[NSFileManager createDirectoryIfNeeded:[NSFileManager cacheFolderPath:userId]];
//	[NSFileManager createDirectoryIfNeeded:[NSFileManager documentsFolderPath:userId]];
//}

+ (void) addSkipBackupAttributeToFile:(NSString*) filePath {
    u_int8_t b = 1;
    setxattr([filePath fileSystemRepresentation], "com.apple.MobileBackup", &b, 1, 0, 0);
}

#endif

+ (unsigned long long) availableDiskSpace {
	struct statfs tStats;
	memset(&tStats, 0, sizeof(struct statfs));
 
#if IOS
	statfs([NSHomeDirectory() cStringUsingEncoding:NSASCIIStringEncoding], &tStats);
#endif	   
	return tStats.f_bavail * tStats.f_bsize;
}

+ (unsigned long long) diskSize {
	struct statfs tStats;
	memset(&tStats, 0, sizeof(struct statfs));

#if IOS	   
	statfs([NSHomeDirectory() cStringUsingEncoding:NSASCIIStringEncoding], &tStats);
#endif	   
	return tStats.f_blocks * tStats.f_bsize;
}

- (BOOL) itemIsDirectory:(NSString*) path {
    NSError* err = nil;
    NSDictionary* attrs = [self attributesOfItemAtPath:path error:&err];
    if(err) {
       FLThrowIfError(err);
    }
    
    return attrs.fileType == NSFileTypeDirectory;
}

- (NSUInteger) countItemsInDirectory:(NSString*) startPath 
                         recursively:(BOOL) recursively
                    visibleItemsOnly:(BOOL) visibleItemsOnly {
    __block NSUInteger outCount = 0;
    
    [self visitEachItemAtPath:startPath recursively:recursively visibleItemsOnly:visibleItemsOnly visitor:
        ^(NSString* filePath, BOOL* stop) {
            ++outCount;
        }];

    return outCount;
}

- (BOOL) _visitEachItemAtPath:(NSString*) path
                 recursively:(BOOL) recursively
            visibleItemsOnly:(BOOL) visibleItemsOnly
                     visitor:(FLFileManagerVisitor) visitor {
    NSError* err = nil;
    NSArray* contents = [self contentsOfDirectoryAtPath:path error:&err];
    if(err) {
       FLThrowIfError(err);
    }
    
    for(NSString* item in contents) {
        if(visibleItemsOnly && [item characterAtIndex:0] == '.') { // invisible file or folder
            continue;
        }

        NSString* fullPath = [path stringByAppendingPathComponent:item];
            
        BOOL stop = NO;
        if(visitor) {
            visitor(fullPath, &stop);
        }
        
        if(stop) {
            return YES;
        }
        
        if(recursively) {
            if([self itemIsDirectory:fullPath]) {
                if([self _visitEachItemAtPath:fullPath recursively:YES visibleItemsOnly:visibleItemsOnly visitor:visitor]) {
                    return YES;
                }
            }
        }
    }
    
    return NO;
}


- (void) visitEachItemAtPath:(NSString*) path
                 recursively:(BOOL) recursively
            visibleItemsOnly:(BOOL) visibleItemsOnly
                     visitor:(FLFileManagerVisitor) visitor {
    [self _visitEachItemAtPath:path recursively:recursively visibleItemsOnly:visibleItemsOnly visitor:visitor];

}


@end

