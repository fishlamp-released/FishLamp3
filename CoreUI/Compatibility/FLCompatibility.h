//
//  FLCompatibility.h
//  FLCompatibility
//
//  Created by Mike Fullerton on 1/6/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampCore.h"

#if OSX

#import <Cocoa/Cocoa.h>

#if __MAC_10_8
#import <CoreGraphics/CoreGraphics.h>
#endif

#import <AppKit/AppKit.h>



#define SDKColor             NSColor
#define SDKControl           NSControl
#define SDKEvent             NSEvent
#define SDKFont              NSFont
#define SDKImage             NSImage

#define SDKView              NSView
#define SDKViewController    NSViewController

// views
#define SDKTextField         NSTextField
#define SDKImageView         NSImageView
#define SDKLabel             NSTextField
#define SDKButton            NSButton
#define SDKTextView          NSTextView

#define SDKApplication       NSApplication

#define CGGetCurrentContext() [[NSGraphicsContext currentContext] graphicsPort]


#endif

#if IOS

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <CoreText/CoreText.h>

#define NSLinkAttributeName @"NSLinkAttributeName"

#define SDKColor            UIColor
#define SDKControl          UIControl
#define SDKEvent            UIEvent
#define SDKFont             UIFont
#define SDKImage            SDKImage
#define SDKView             UIView
#define SDKViewController   UIViewController
#define SDKButton           UIButton
#define SDKImageView        UIImageView
#define SDKLabel            UITextField
#define SDKTextField        UITextField
#define SDKTextView         UITextView
#define SDKApplication      UIApplication

#define CGGetCurrentContext UIGraphicsGetCurrentContext

#define NSRectFromCGRect(RECT) RECT
#define NSRectToCGRect(RECT) RECT

#define NSPointFromCGPoint(POINT) POINT
#define NSPointToCGPoint(POINT) POINT

#define NSSizeFromCGSize(SIZE) SIZE
#define NSSizeToCGSize(SIZE) SIZE

@interface NSValue (Compatibility)

+ (NSValue *)valueWithPoint:(CGPoint)point;
+ (NSValue *)valueWithSize:(CGSize)size;
+ (NSValue *)valueWithRect:(CGRect)rect;

- (CGPoint)pointValue;
- (CGSize)sizeValue;
- (CGRect)rectValue;

@end

#endif



