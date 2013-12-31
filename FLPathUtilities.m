//
//	FLPathUtilities.m
//	FishLamp
//
//	Created by Mike Fullerton on 3/16/11.
//	Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton.
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLPathUtilities.h"
#import "FLGeometry.h"

void FLCreateRectPathWithCornerRadii(CGMutablePathRef path, CGRect rect, CGFloat topLeft, CGFloat topRight, CGFloat bottomRight, CGFloat bottomLeft)
{
	//
	// Create the boundary path
	//
	
	// bottomLeft
	
	CGPathMoveToPoint(path, NULL,
		rect.origin.x,
		rect.origin.y + rect.size.height - bottomLeft);

	// Top left corner
	CGPathAddArcToPoint(path, NULL,
		rect.origin.x,
		rect.origin.y,
		rect.origin.x + rect.size.width,
		rect.origin.y,
		topLeft);

	// Top right corner
	CGPathAddArcToPoint(path, NULL,
		rect.origin.x + rect.size.width,
		rect.origin.y,
		rect.origin.x + rect.size.width,
		rect.origin.y + rect.size.height,
		topRight);

	// Bottom right corner
	CGPathAddArcToPoint(path, NULL,
		rect.origin.x + rect.size.width,
		rect.origin.y + rect.size.height,
		rect.origin.x,
		rect.origin.y + rect.size.height,
		bottomRight);

	// Bottom left corner
	CGPathAddArcToPoint(path, NULL,
		rect.origin.x,
		rect.origin.y + rect.size.height,
		rect.origin.x,
		rect.origin.y,
		bottomLeft);

	// Close the path at the rounded rect
	CGPathCloseSubpath(path);
}

void FLCreateRectPathWithTopArrow(CGMutablePathRef path, CGRect rect, CGPoint arrowPoint, CGFloat arrowSize, CGFloat cornerRadius)
{
	

// bottom left
	CGPathMoveToPoint(path, NULL,
		rect.origin.x,
		rect.origin.y + rect.size.height - cornerRadius);
		
//	// Top left corner
	CGPathAddArcToPoint(path, NULL,
		rect.origin.x,
		rect.origin.y + arrowSize,
		rect.origin.x + cornerRadius,
		rect.origin.y + arrowSize,
		cornerRadius);
		
	CGPathAddLineToPoint(path, NULL,
		arrowPoint.x - (arrowSize),
		rect.origin.y + arrowSize);

	CGPathAddLineToPoint(path, NULL,
		arrowPoint.x,
		arrowPoint.y);

	CGPathAddLineToPoint(path, NULL,
		arrowPoint.x + (arrowSize),
		rect.origin.y + arrowSize);
		
	CGPathAddLineToPoint(path, NULL,
		CGRectGetRight(rect) - cornerRadius,
		rect.origin.y + arrowSize);

// top right
	CGPathAddArcToPoint(path, NULL,
		CGRectGetRight(rect),
		rect.origin.y + arrowSize,
		CGRectGetRight(rect),
		rect.origin.y + rect.size.height,
		cornerRadius);

	// Bottom right corner
	CGPathAddArcToPoint(path, NULL,
		rect.origin.x + rect.size.width,
		rect.origin.y + rect.size.height,
		rect.origin.x,
		rect.origin.y + rect.size.height,
		cornerRadius);

	// Bottom left corner
	CGPathAddArcToPoint(path, NULL,
		rect.origin.x,
		rect.origin.y + rect.size.height,
		rect.origin.x,
		rect.origin.y,
		cornerRadius);

	// Close the path at the rounded rect
	CGPathCloseSubpath(path);

}

void FLCreateRectPathBackButtonShape(CGMutablePathRef path, CGRect rect, CGFloat cornerRadius, CGFloat ptSize)
{
	// bottomLeft
	
	CGPathMoveToPoint(path, NULL,
		rect.origin.x + 0.5,
		CGRectGetCenter(rect).y + 0.5);

	CGPathAddArcToPoint(path, NULL,
		rect.origin.x + ptSize,
		rect.origin.y,
		rect.origin.x + rect.size.width,
		rect.origin.y,
		cornerRadius);

	// Top right corner
	CGPathAddArcToPoint(path, NULL,
		rect.origin.x + rect.size.width,
		rect.origin.y,
		rect.origin.x + rect.size.width,
		rect.origin.y + rect.size.height + cornerRadius,
		cornerRadius);

	// Bottom right corner
	CGPathAddArcToPoint(path, NULL,
		rect.origin.x + rect.size.width,
		rect.origin.y + rect.size.height,
		rect.origin.x + 0.5,
		rect.origin.y + rect.size.height,
		cornerRadius);

	// Bottom left corner
	CGPathAddArcToPoint(path, NULL,
		rect.origin.x + ptSize,
		rect.origin.y + rect.size.height,
		rect.origin.x,
		CGRectGetCenter(rect).y - 0.5,
		cornerRadius);

	// Close the path at the rounded rect
	CGPathCloseSubpath(path);

}

void FLCreateRectPathForwardButtonShape(CGMutablePathRef path, CGRect rect, CGFloat cornerRadius, CGFloat ptSize)
{
    rect = CGRectInset(rect, 0.5, 0.5);

	CGPathMoveToPoint(path, NULL,
		rect.origin.x + rect.size.width,
		CGRectGetCenter(rect).y);
            
    CGPathAddLineToPoint(path, NULL,
        rect.origin.x + rect.size.width - ptSize,
        rect.origin.y);
        
    CGPathAddLineToPoint(path, NULL,
        rect.origin.x,
        rect.origin.y);

    CGPathAddLineToPoint(path, NULL,
        rect.origin.x,
        rect.origin.y + rect.size.height);

    CGPathAddLineToPoint(path, NULL,
        rect.origin.x + rect.size.width - ptSize,
        rect.origin.y + rect.size.height);

    CGPathAddLineToPoint(path, NULL,
		rect.origin.x + rect.size.width,
		CGRectGetCenter(rect).y);

	CGPathCloseSubpath(path);

//// start at point.
//	CGPathMoveToPoint(path, NULL,
//		rect.origin.x + rect.size.width - 0.5,
//		CGRectGetCenter(rect).y);
//
//// to origin
//	CGPathAddArcToPoint(path, NULL,
//		rect.origin.x + rect.size.width - ptSize,
//		rect.origin.y,
//		rect.origin.x,
//		rect.origin.y,
//		cornerRadius);
//
//	CGPathAddArcToPoint(path, NULL,
//		rect.origin.x + rect.size.width,
//		rect.origin.y,
//		rect.origin.x + rect.size.width,
//		rect.origin.y + rect.size.height + cornerRadius,
//		cornerRadius);
//
//	// Bottom right corner
//	CGPathAddArcToPoint(path, NULL,
//		rect.origin.x + rect.size.width,
//		rect.origin.y + rect.size.height,
//		rect.origin.x + 0.5,
//		rect.origin.y + rect.size.height,
//		cornerRadius);
//
//	// Bottom left corner
//	CGPathAddArcToPoint(path, NULL,
//		rect.origin.x + ptSize,
//		rect.origin.y + rect.size.height,
//		rect.origin.x,
//		CGRectGetCenter(rect).y - 0.5,
//		cornerRadius);
//
//	// Close the path at the rounded rect
//	CGPathCloseSubpath(path);
//
//
//	// top left
//
//    rect = CGRectInset(rect, 0.5, 0.5);
//
//    // origin.
//	CGPathMoveToPoint(path, NULL, 
//        rect.origin.x + cornerRadius, 
//        rect.origin.y);
//        
//    // to point (through top right), with curve
//	CGPathAddArcToPoint(path, NULL,
//    // curve through
//        rect.origin.x + rect.size.width - ptSize, 
//        rect.origin.y,
//    // to point
//        rect.origin.x + rect.size.width,
//        rect.origin.y + (rect.size.height / 2),
//        cornerRadius);
//
//    // to bottom left, from curve point
//	CGPathAddArcToPoint(path, NULL,
//    // curve through
//        rect.origin.x + rect.size.width - ptSize, 
//        rect.origin.y + rect.size.height,
//    // to point
//        rect.origin.x + cornerRadius,
//        rect.origin.y + rect.size.height,
//        cornerRadius);
//
//	CGPathAddArcToPoint(path, NULL,
//    // curve through
//        rect.origin.x, 
//        rect.origin.y + rect.size.height - cornerRadius,
//    // to point
//        rect.origin.x,
//        rect.origin.y + (rect.size.height / 2),
//        cornerRadius);
//
//
//    // back to start (allowing for curved corners)
//	CGPathAddArcToPoint(path, NULL,
//    // curve through
//        rect.origin.x, 
//        rect.origin.y + cornerRadius,
//    // to point
//        rect.origin.x + cornerRadius,
//        rect.origin.y,
//        cornerRadius);
//        
//    
//	// Close the path at the rounded rect
//	CGPathCloseSubpath(path);

}


void FLCreateRectPathWithRightArrow(CGMutablePathRef path, CGRect rect, CGPoint arrowPoint, CGFloat arrowSize, CGFloat cornerRadius)
{
        // bottom left
	CGPathMoveToPoint(path, NULL,
                      rect.origin.x,
                      rect.origin.y + rect.size.height - cornerRadius);
    
        //	// Top left corner
	CGPathAddArcToPoint(path, NULL,
                        rect.origin.x,
                        rect.origin.y,
                        rect.origin.x + cornerRadius,
                        rect.origin.y,
                        cornerRadius);
    
    	// Top right corner
	CGPathAddArcToPoint(path, NULL,
                        rect.origin.x + rect.size.width - arrowSize,
                        rect.origin.y,
                        rect.origin.x + rect.size.width - arrowSize,
                        rect.origin.y + cornerRadius ,
                        cornerRadius);

        // start of right point
	CGPathAddLineToPoint(path, NULL,
                         rect.origin.x + rect.size.width - arrowSize,
                         arrowPoint.y - (arrowSize));
    
	CGPathAddLineToPoint(path, NULL,
                         arrowPoint.x,
                         arrowPoint.y);
        
        // end of right point
	CGPathAddLineToPoint(path, NULL,
                         rect.origin.x + rect.size.width - arrowSize,
                         arrowPoint.y + arrowSize);
    
//	CGPathAddLineToPoint(path, NULL,
//                         rect.origin.x + rect.size.width,
//                         rect.origin.y + rect.size.height);
    
        // Bottom right corner
	CGPathAddArcToPoint(path, NULL,
                        rect.origin.x + rect.size.width - arrowSize,
                        rect.origin.y + rect.size.height,
                        rect.origin.x,
                        rect.origin.y + rect.size.height,
                        cornerRadius);
    
        // Bottom left corner
	CGPathAddArcToPoint(path, NULL,
                        rect.origin.x,
                        rect.origin.y + rect.size.height,
                        rect.origin.x,
                        rect.origin.y,
                        cornerRadius);
    
        // Close the path at the rounded rect
	CGPathCloseSubpath(path);

}

void FLCreateRectPathWithBottomArrow(CGMutablePathRef path, CGRect rect, CGPoint arrowPoint, CGFloat arrowSize, CGFloat cornerRadius)
{
	
 
// bottom left
	CGPathMoveToPoint(path, NULL,
		rect.origin.x,
		CGRectGetBottom(rect) - cornerRadius - arrowSize);
		
//	// Top left corner
	CGPathAddArcToPoint(path, NULL,
		rect.origin.x,
		rect.origin.y,
		rect.origin.x + cornerRadius,
		rect.origin.y,
		cornerRadius);
		
// top right
	CGPathAddArcToPoint(path, NULL,
		CGRectGetRight(rect),
		rect.origin.y,
		CGRectGetRight(rect),
		CGRectGetBottom(rect) - arrowSize,
		cornerRadius);

	// Bottom right corner
	CGPathAddArcToPoint(path, NULL,
		CGRectGetRight(rect),
		CGRectGetBottom(rect) - arrowSize,
		CGRectGetRight(rect) - cornerRadius,
		CGRectGetBottom(rect) - arrowSize,
		cornerRadius);

	// right base of arrow
	CGPathAddLineToPoint(path, NULL,
		arrowPoint.x + (arrowSize),
		CGRectGetBottom(rect) - arrowSize);

	// tip of arrow
	CGPathAddLineToPoint(path, NULL,
		arrowPoint.x,
		arrowPoint.y);

	// left base of arrow
	CGPathAddLineToPoint(path, NULL,
		arrowPoint.x - (arrowSize),
		CGRectGetBottom(rect) - arrowSize);
	 
	CGPathAddLineToPoint(path, NULL,
		rect.origin.x + cornerRadius,
		CGRectGetBottom(rect) - arrowSize);


	// Bottom left corner
//	CGPathAddArcToPoint(path, NULL,
//		rect.origin.x,
//		CGRectGetBottom(rect) - arrowSize - cornerRadius,
//		rect.origin.x + cornerRadius,
//		CGRectGetBottom(rect) - arrowSize,
//		cornerRadius);

	CGPathAddArcToPoint(path, NULL,
		rect.origin.x,
		CGRectGetBottom(rect) - arrowSize,
		rect.origin.x,
		CGRectGetBottom(rect) - arrowSize - cornerRadius,
		cornerRadius);
		
	// Close the path at the rounded rect
	CGPathCloseSubpath(path);

}

void FLCreateRectPathWithLeftArrow(CGMutablePathRef path, CGRect rect, CGPoint arrowPoint, CGFloat arrowSize, CGFloat cornerRadius)
{
        // bottom left
	CGPathMoveToPoint(path, NULL,
                      rect.origin.x + arrowSize,
                      rect.origin.y + rect.size.height - cornerRadius);

        // start of  point
	CGPathAddLineToPoint(path, NULL,
                         rect.origin.x + arrowSize,
                         arrowPoint.y - (arrowSize));
    
	CGPathAddLineToPoint(path, NULL,
                         arrowPoint.x,
                         arrowPoint.y);
    
        // end of  point
	CGPathAddLineToPoint(path, NULL,
                         rect.origin.x + arrowSize,
                         arrowPoint.y + arrowSize);

        //	Top left corner
	CGPathAddArcToPoint(path, NULL,
                        rect.origin.x + arrowSize,
                        rect.origin.y,
                        rect.origin.x + arrowSize + cornerRadius,
                        rect.origin.y,
                        cornerRadius);
    
    	// Top right corner
	CGPathAddArcToPoint(path, NULL,
                        rect.origin.x + rect.size.width,
                        rect.origin.y,
                        rect.origin.x + rect.size.width,
                        rect.origin.y + cornerRadius ,
                        cornerRadius);
    
        // Bottom right corner
	CGPathAddArcToPoint(path, NULL,
                        rect.origin.x + rect.size.width,
                        rect.origin.y + rect.size.height,
                        rect.origin.x,
                        rect.origin.y + rect.size.height,
                        cornerRadius);
    
        // Bottom left corner
	CGPathAddArcToPoint(path, NULL,
                        rect.origin.x + arrowSize,
                        rect.origin.y + rect.size.height,
                        rect.origin.x + arrowSize,
                        rect.origin.y,
                        cornerRadius);
    
        // Close the path at the rounded rect
	CGPathCloseSubpath(path);
}

void FLCreatePartialRectPathTop(CGMutablePathRef path, CGRect rect, CGFloat cornerRadius)
{
	//
	// Create the boundary path
	//
	
	
	// bottom left
	CGPathMoveToPoint(path, NULL,
		rect.origin.x,
		rect.origin.y + rect.size.height);

	// Top left corner
	CGPathAddArcToPoint(path, NULL,
		rect.origin.x,
		rect.origin.y,
		rect.origin.x + rect.size.width,
		rect.origin.y,
		cornerRadius);

	// Top right corner
	CGPathAddArcToPoint(path, NULL,
		rect.origin.x + rect.size.width,
		rect.origin.y,
		rect.origin.x + rect.size.width,
		rect.origin.y + rect.size.height,
		cornerRadius);
		
	CGPathAddLineToPoint(path, NULL,
		rect.origin.x + rect.size.width,
		rect.origin.y + rect.size.height);		  

	// Close the path at the rounded rect
	//CGPathCloseSubpath(path);
	
}

void FLCreatePartialRectPathLeft(CGMutablePathRef path, CGRect rect, CGFloat cornerRadius)
{
	
	CGPathMoveToPoint(path, NULL,
		CGRectGetLeft(rect),
		CGRectGetTop(rect) + cornerRadius);
	CGPathAddLineToPoint(path, NULL,
		CGRectGetLeft(rect),
		CGRectGetBottom(rect) - cornerRadius);	
}

void FLCreatePartialRectPathRight(CGMutablePathRef path, CGRect rect, CGFloat cornerRadius)
{
	
	CGPathMoveToPoint(path, NULL,
		CGRectGetRight(rect),
		CGRectGetTop(rect) + cornerRadius);
	CGPathAddLineToPoint(path, NULL,
		CGRectGetRight(rect),
		CGRectGetBottom(rect) - cornerRadius);	
}

void FLCreatePartialRectPathBottom(CGMutablePathRef path, CGRect rect, CGFloat cornerRadius)
{
	//
	// Create the boundary path
	//
	
	
	// bottom left
	CGPathMoveToPoint(path, NULL,
		CGRectGetRight(rect),
		CGRectGetTop(rect));

	// Bottom right corner
	CGPathAddArcToPoint(path, NULL,
		rect.origin.x + rect.size.width,
		rect.origin.y + rect.size.height,
		rect.origin.x,
		rect.origin.y + rect.size.height,
		cornerRadius);

	// Bottom left corner
	CGPathAddArcToPoint(path, NULL,
		rect.origin.x,
		rect.origin.y + rect.size.height,
		rect.origin.x,
		rect.origin.y,
		cornerRadius);
		
	CGPathAddLineToPoint(path, NULL,
		rect.origin.x,
		rect.origin.y);		   

	// Close the path at the rounded rect
}

void FLSetPathToTriangleInRectCorner(CGMutablePathRef path, 
    CGRect rect, 
    FLTriangleCorner cornerInRect) {
    
    switch(cornerInRect) {
        case FLTriangleCornerUpperLeft:
          	CGPathMoveToPoint(path, NULL, rect.origin.x, rect.origin.y);
            CGPathAddLineToPoint(path, NULL, CGRectGetRight(rect), rect.origin.y);
            CGPathAddLineToPoint(path, NULL, rect.origin.x, CGRectGetBottom(rect));
            CGPathAddLineToPoint(path, NULL, rect.origin.x, rect.origin.y);
        break;
        case FLTriangleCornerUpperRight:
          	CGPathMoveToPoint(path, NULL, CGRectGetRight(rect), rect.origin.y);
            CGPathAddLineToPoint(path, NULL, CGRectGetRight(rect), CGRectGetBottom(rect));
            CGPathAddLineToPoint(path, NULL, rect.origin.x, rect.origin.y);
            CGPathAddLineToPoint(path, NULL, CGRectGetRight(rect), rect.origin.y);
        break;
        case FLTriangleCornerBottomRight:
          	CGPathMoveToPoint(path, NULL, CGRectGetRight(rect), CGRectGetBottom(rect));
            CGPathAddLineToPoint(path, NULL, rect.origin.x, CGRectGetBottom(rect));
            CGPathAddLineToPoint(path, NULL, CGRectGetRight(rect), rect.origin.y);
            CGPathAddLineToPoint(path, NULL, CGRectGetRight(rect), CGRectGetBottom(rect));
        break;
        case FLTriangleCornerBottomLeft:
          	CGPathMoveToPoint(path, NULL, rect.origin.x, CGRectGetBottom(rect));
            CGPathAddLineToPoint(path, NULL, rect.origin.x, rect.origin.y);
            CGPathAddLineToPoint(path, NULL, CGRectGetRight(rect), rect.origin.y);
            CGPathAddLineToPoint(path, NULL, rect.origin.x, CGRectGetBottom(rect));
        break;

    
    }

  	CGPathCloseSubpath(path);
}

