//
//	FLFolderFile.m
//	PackMule
//
//	Created by Mike Fullerton on 11/8/10.
//	Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLFolderFile.h"
#import "FLObjectDescriber.h"

@implementation FLFolderFile

@synthesize folder = _folder;
@synthesize fileName = _fileName;

- (id) initWithFolder:(FLFolder*) folder 
             fileName:(NSString*) fileName {
	if((self = [super init])) {
		FLAssertIsNotNil(folder);
		FLAssertStringIsNotEmpty(fileName);
		
        self.folder = folder;
		self.fileName = fileName;
	}
	return self;
}

- (void) dealloc {
	FLRelease(_fileName);
	FLRelease(_folder);
	FLSuperDealloc();
}

- (NSString*) filePath {
	return [_folder pathForFile:self.fileName];
}

- (void) deleteFile {
	[_folder deleteFile:self.fileName];
}

- (void) writeDataToFile:(NSData*) data {
	[_folder writeDataToFile:self.fileName data:data];
}

- (void) writeObjectToFile:(id) object {
	[_folder writeObjectToFile:self.fileName object:object];
}

- (BOOL) fileExists {
	return [_folder fileExistsInFolder:self.fileName];
}

- (id) readObjectFromFile {
	return [_folder readObjectFromFile:self.fileName];
}

- (NSData*) readDataFromFile {
    return [_folder readDataFromFile:self.fileName];
}

- (unsigned  long long) fileSize {
	return [_folder sizeForFileName:self.fileName];
}

- (id) copyWithZone:(NSZone *)zone {
	return [[[self class] alloc] initWithFolder:self.folder fileName:self.fileName];
}

- (NSInputStream*) createReadStream {

	if(!self.fileExists)
	{
		FLThrowIfError([NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorFileDoesNotExist 
			userInfo:[NSDictionary dictionaryWithObject:@"file is missing - can't create read stream" forKey:NSLocalizedFailureReasonErrorKey]]);
	}

	return FLAutorelease([[NSInputStream alloc] initWithFileAtPath:self.filePath]);
}



@end
