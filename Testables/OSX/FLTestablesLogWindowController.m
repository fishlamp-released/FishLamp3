//
//  FLTestablesLogWindowController.m
//  Pods
//
//  Created by Mike Fullerton on 2/23/14.
//
//

#import "FLTestablesLogWindowController.h"
#import "FLTestablesLogViewController.h"
#import "FLTestOrganizer.h"

@interface FLTestablesLogWindowController ()

@end

static NSMutableArray* s_windows = nil;

@implementation FLTestablesLogWindowController

+ (void) initialize {
    s_windows = [[NSMutableArray alloc] init];
}

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        self.shouldCascadeWindows = YES;
        [s_windows addObject:self];
    }
    return self;
}

- (id) init {	
	self = [super initWithWindowNibName:@"FLTestablesLogWindowController"];
	if(self) {
		
	}
	return self;
}

+ (id) testablesLogViewController {
    return FLAutorelease([[[self class] alloc] init]);
}

- (void)windowDidLoad
{
    [super windowDidLoad];


    _logViewController = [[FLTestablesLogViewController alloc] init];

    [self.window setContentView:_logViewController.view];
}

- (void) runTests:(id) sender {

    FLLogger* logger = [FLLogger logger];
    [logger addLoggerSink:_logViewController];

    [logger updateLogSinkBehavior:[FLLogSinkBehavior logSinkBehavior]];

    FLTestOrganizer* organizer = [FLTestOrganizer testOrganizer];
    [organizer.logger addLogger:logger];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        [organizer.logger appendLine:@"Finding tests..."];

        FLSortedTestGroupList* tests = [organizer organizeTests];

        [organizer.logger appendLine:@"Starting tests..."];

        [organizer runTests:tests];

        [organizer.logger appendLine:@"Done"];
    });
}

- (BOOL)windowShouldClose:(id)sender {
    [s_windows removeObject:self];

    return YES;
}


@end
