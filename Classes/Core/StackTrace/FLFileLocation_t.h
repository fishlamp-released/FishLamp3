//
//  FLFileLocation_t.h
//  FishLamp
//
//  Created by Mike Fullerton on 12/24/13.
//
//

#import <Foundation/Foundation.h>

typedef struct {
    const char* filePath; // absolute path to file
    const char* fileName; // just the file name (Call FLFileLocationSetFileName first)
    const char* function; // the function/method if any
    int line;             // line number
} FLFileLocation_t;

extern const FLFileLocation_t FLFileLocationZero;

/*!
 *  Make empty file location
 *  
 *  @param filePath path to file
 *  @param function function if any
 *  @param line     line number
 *  
 *  @return new file location
 */
NS_INLINE
FLFileLocation_t FLFileLocationMake(const char* filePath, const char* function, int line) {
    FLFileLocation_t loc = { filePath, nil, function, line };
    return loc;
}

/*!
 *  Sets the file name pointer in the struct if it hasn't been set yet.
 *  
 *  @param loc is the file location
 *
 */
extern const char* FLFileLocationGetFileName(FLFileLocation_t* loc);

#define FLCurrentFileLocation() \
            FLFileLocationMake(__FILE__, __PRETTY_FUNCTION__, __LINE__)
