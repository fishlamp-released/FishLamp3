//
//  FLFileLocation_t.m
//  FishLamp
//
//  Created by Mike Fullerton on 12/24/13.
//
//

#import "FLFileLocation_t.h"

const FLFileLocation_t FLFileLocationZero = { nil, nil, nil, 0 };

const char* FLFileNameFromPathNoCopy(const char* filePath) {
    if(filePath) {
        const char* lastComponent = nil;

        while(*filePath) {
            if(*filePath++ == '/') {
                lastComponent = filePath;
            }
        }
        
        return lastComponent;
    }
    return nil;
}

void FLFileLocationSetFileName(FLFileLocation_t* loc) {
    if(!loc->fileName) {
        loc->fileName = FLFileNameFromPathNoCopy(loc->filePath);
    }
}

