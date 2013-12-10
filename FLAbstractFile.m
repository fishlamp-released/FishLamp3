//
//	FLDataFile.m
//	FishLamp
//
//	Created by Mike Fullerton on 10/25/09.
//	Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLAbstractFile.h"
#import "FLFolder.h"

#if 0
@implementation FLAbstractFile

@synthesize folder = _folder;
@synthesize fileName = _fileName;

- (BOOL) canWriteToStorage
{
	return YES;
}

- (BOOL) willSendDeallocNotification {
    return YES;
}

- (BOOL) canDeleteFromStorage
{
	return YES;
}

- (id) initWithFolder:(FLFolder*) folder fileName:(NSString*) fileName
{
	if((self = [super init]))
	{
		FLAssertIsNotNilWithComment(folder, nil);
		FLAssertStringIsNotEmptyWithComment(fileName, nil);
	
		self.folder = folder;
		self.fileName = fileName;
	}
	
	return self;
}

- (BOOL) existsInStorage {
	[self _throwIfNotConfigured];

	return [_folder fileExistsInFolder:self.fileName];
}

- (void) deleteFromStorage {
	[self _throwIfNotConfigured];

	[_folder deleteFile:self.fileName];
}

- (void) writeToStorage {
	[self _throwIfNotConfigured];
}

- (void) readFromStorage {
	[self _throwIfNotConfigured];
}

#if FL_MRC
- (void) dealloc {
    FLSendDeallocNotification();
	FLRelease(_fileName);
	FLRelease(_folder);
    [super dealloc];
}
#endif

- (NSString*) filePath
{
	return [_folder pathForFile:self.fileName];
}

- (NSInputStream*) createReadStream {

	NSString* myPath = [_folder pathForFile:self.fileName];

	if(![[NSFileManager defaultManager] fileExistsAtPath:myPath])
	{
		FLThrowIfError([NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorFileDoesNotExist 
			userInfo:[NSDictionary dictionaryWithObject:@"Image file is missing - can't create read stream for upload" forKey:NSLocalizedFailureReasonErrorKey]]);
	}

	return FLAutorelease([[NSInputStream alloc] initWithFileAtPath:myPath]);
}

- (unsigned long long) sizeInStorage {
	return [_folder sizeForFileName:self.fileName];
}

- (BOOL) canSaveToFile {
	return _folder != nil && FLStringIsNotEmpty(_fileName);
}	

- (id) copyWithZone:(NSZone *)zone {
	return [[FLAbstractFile allocWithZone:zone] initWithFolder:self.folder fileName:self.fileName];
}

@end
#endif