//
//  FLTestablesLogViewController.m
//  Pods
//
//  Created by Mike Fullerton on 2/23/14.
//
//

#import "FLTestablesLogViewController.h"
#import "FLTestOrganizer.h"

@interface FLTestablesLogViewController ()

@end

@implementation FLTestablesLogViewController

//@synthesize textView = _textView;
//@synthesize logger = _logger;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (id) init {	
    return [self initWithNibName:@"FLTestablesLogViewController" bundle:nil];
}

- (void) appendLine:(NSString*) string {

    NSInteger indent = _indent;
    dispatch_async(dispatch_get_main_queue(), ^{

        NSString* line = [NSString stringWithFormat:@"%@%@\n",
            [[FLWhitespace defaultWhitespace] tabStringForScope:indent ],
            string];

        NSAttributedString* attrString =
            FLAutorelease([[NSAttributedString alloc] initWithString:line]);

        NSTextStorage* textStorage = [_textView textStorage];

        [textStorage beginEditing];
        [textStorage appendAttributedString:attrString];
        [textStorage endEditing];

        [_textView scrollRangeToVisible:NSMakeRange([[_textView string] length], 0)];
    });
}

- (void) updateLogSinkBehavior:(id<FLLogSinkBehavior>) behavior {

}


- (void) logEntry:(FLLogEntry*) entry stopPropagating:(BOOL*) stop {

    [self appendLine:entry.logString];

//    printf_fl(@"%@", entry.logString);
//
//    if(FLTestAnyBit(self.outputFlags, FLLogOutputWithLocation | FLLogOutputWithStackTrace)) { 
//        [[FLPrintfStringFormatter instance] indentLinesInBlock:^{
//            NSString* moreInfo = [entry.object moreDescriptionForLogging];
//            if(moreInfo) {
//                printf_fl(@"%@", moreInfo);
//            }
//            
//            printf_fl(@"%@:%d: %@",
//                         entry.stackTrace.fileName,
//                         entry.stackTrace.lineNumber,
//                         entry.stackTrace.function);
//        }];
//    }
//
//    if(FLTestBits(self.outputFlags, FLLogOutputWithStackTrace)) {
//
//        [[FLPrintfStringFormatter instance] indentLinesInBlock:^{
//            if(entry.stackTrace.callStack.depth) {
//                for(int i = 0; i < entry.stackTrace.callStack.depth; i++) {
//                    printf_fl(@"%s", [entry.stackTrace stackEntryAtIndex:i]);
//                }
//            }
//        }];
//    }






}

- (void) indent:(FLIndentIntegrity*) integrity {
    _indent++;
}

- (void) outdent:(FLIndentIntegrity*) integrity {
    _indent--;
}




//FLSynthesizeLazyGetterWithBlock(logger, FLTextViewLogger*, _logger, ^{ return [FLTextViewLogger textViewLogger:self.textView]; } );
//
//- (void) setLinkAttributes {
//    NSMutableDictionary* attr = [NSMutableDictionary dictionary];
//    [attr setObject:[NSFont boldSystemFontOfSize:[NSFont smallSystemFontSize]] forKey:NSFontAttributeName];
//    [attr setObject:[NSNumber numberWithBool:YES] forKey:NSUnderlineStyleAttributeName];
//    [attr setObject:[NSColor blueColor] forKey:NSForegroundColorAttributeName];
//    [attr setObject:[NSCursor pointingHandCursor] forKey:NSCursorAttributeName];
//    [_textView setLinkTextAttributes:attr];
//}
//
//- (void) awakeFromNib {
//	[super awakeFromNib];
//    FLAssertNotNil(_textView);
//
//    [self setLinkAttributes];
//}
//
//#if FL_MRC
//- (void)dealloc {
//	[_logger release];
//	[super dealloc];
//}
//#endif


@end
