//
//  FLStringFormatterDelegate.h
//  FishLampCore
//
//  Created by Mike Fullerton on 10/26/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FishLampCore.h"

@class FLStringFormatter;
@protocol FLStringFormatter;

/**
 *  This delegate is here mainly to help subclasses be sure that they're implementing all the relevant methods.
 *  The delegate is normally the subclass of the FLStringFormatter.
 */
@protocol FLStringFormatterDelegate <NSObject>

- (void) stringFormatterAppendBlankLine:(FLStringFormatter*) formatter;

- (void) stringFormatterOpenLine:(FLStringFormatter*) formatter;

- (void) stringFormatterCloseLine:(FLStringFormatter*) formatter;

- (void) stringFormatterIndent:(FLStringFormatter*) formatter;

- (void) stringFormatterOutdent:(FLStringFormatter*) formatter;

- (NSUInteger) stringFormatterLength:(FLStringFormatter*) formatter;

- (void)stringFormatter:(FLStringFormatter*) formatter
appendContentsToStringFormatter:(id<FLStringFormatter>) stringFormatter;

- (void) stringFormatter:(FLStringFormatter*) formatter
            appendString:(NSString*) string;

- (void) stringFormatter:(FLStringFormatter*) formatter
  appendAttributedString:(NSAttributedString*) attributedString;

- (NSString*) stringFormatterExportString:(FLStringFormatter*) formatter;

- (NSAttributedString*) stringFormatterExportAttributedString:(FLStringFormatter*) formatter;

@end