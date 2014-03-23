//
//  FLCriticalSection.h
//  FishLamp
//
//  Created by Mike Fullerton on 12/26/13.
//
//

#import "FishLampRequired.h"

typedef void (^FLCriticalSectionBlock)();

extern void FLCriticalSection(void* shared_addr, FLCriticalSectionBlock block);
