//
//  NSString+FLPathUtilities.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 12/10/13.
//
//

#import <Foundation/Foundation.h>
#import "FishLampCore.h"

typedef void (^FLPathUtilitiesVisitor)(NSRange range, BOOL* stop);

@interface NSString (FLPathUtilities)

+ (NSString *)pathWithComponents:(NSArray *)components withDelimiter:(unichar) delimiter;

- (NSArray *)pathComponentsWithDelimiter:(unichar) delimiter;

- (NSString *)lastPathComponentWithDelimiter:(unichar) delimiter;

- (NSString *)stringByDeletingLastPathComponentWithDelimiter:(unichar) delimiter;

- (NSString *)stringByAppendingPathComponent:(NSString *)str withDelimiter:(unichar) delimiter;

- (NSArray *)stringsByAppendingPaths:(NSArray *)paths withDelimiter:(unichar) delimiter;

- (NSUInteger) indexOflastPathComponentDelimiter:(unichar) delimiter;

- (void) visitComponentsWithDelimiter:(unichar) delimiter
                    withForwardSearch:(FLPathUtilitiesVisitor) visitor;
                    
- (void) visitComponentsWithDelimiter:(unichar) delimiter
                   withBackwardSearch:(FLPathUtilitiesVisitor) visitor;

- (BOOL) basePathEqualsPath:(NSString*) path
              withDelimiter:(unichar) delimiter;

@end
