//
//  FLWizardStyleViewTransition.h
//  FishLampCocoaUI
//
//  Created by Mike Fullerton on 1/1/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLViewTransition.h"

@interface FLWizardStyleTransition : FLBatchViewTransition
@end

@interface FLWizardStyleForwardTransition : FLWizardStyleTransition
+ (id) wizardStyleForwardTransition;
@end

@interface FLWizardStyleBackwardTransition : FLWizardStyleTransition 
+ (id) wizardStyleBackwardTransition;
@end


