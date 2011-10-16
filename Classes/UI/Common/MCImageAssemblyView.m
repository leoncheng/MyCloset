//
//  MCImageAssemblyView.m
//  MyCloset
//
//  Created by mmcl on 11-10-7.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MCImageAssemblyView.h"

@implementation MCImageAssemblyViewCell
@synthesize Delegate = m_delegate;

- (void)CommonInit
{
	m_startLocation = CGPointZero;
	//add close button on the left top corner
	CGFloat closeBtnWidth = 20;
	CGFloat closeBtnHeight = 20;
	CGFloat closeBtnX = -10;
	CGFloat closeBtnY = -10;
	m_closeButton = [[MCButton alloc] initWithFrame:CGRectMake(closeBtnX, closeBtnY, closeBtnWidth, closeBtnHeight)];
	[m_closeButton setImage:[UIImage imageNamed:@"closeButton.png"] forState:UIControlStateNormal];
	[m_closeButton addTarget:self action:@selector(OnTouchClose:) forControlEvents:UIControlEventTouchUpInside];
	m_closeButton.ErrorMargin = 10;
	[self addSubview:m_closeButton];
	m_closeButton.hidden = YES;
	
	//add scale button on the right bottom corner
	/*
	CGFloat scaleBtnWidth = 20;
	CGFloat scaleBtnHeight = 20;
	CGFloat scaleBtnX = -10 + self.frame.size.width;
	CGFloat scaleBtnY = -10 + self.frame.size.height;
	m_scaleButton = [[MCButton alloc] initWithFrame:CGRectMake(scaleBtnX, scaleBtnY, scaleBtnWidth, scaleBtnHeight)];
	[m_scaleButton setImage:[UIImage imageNamed:@"scaleButton.jpeg"] forState:UIControlStateNormal];
	[m_scaleButton addTarget:self action:@selector(OnTouchDownScaleBtn:) forControlEvents:UIControlEventTouchDown];
	[m_scaleButton addTarget:self action:@selector(OnDragScaleBtn:withEvent:) forControlEvents:UIControlEventTouchDragInside];
	[m_scaleButton addTarget:self action:@selector(OnTouchUpScaleBtn:) forControlEvents:UIControlEventTouchUpInside];
	m_scaleButton.ErrorMargin = 10;
	[self addSubview:m_scaleButton];
	m_scaleButton.hidden = YES;
	
	//initial status
	m_scaling = NO;
	 */

	[self _RegisterGestures];
}

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self != nil) {
		[self CommonInit];
	}
	return self;
}

- (void)dealloc
{
	MCSAFERELEASE(m_closeButton)
	//MCSAFERELEASE(m_scaleButton)
	[super dealloc];
}

- (void)setSelected:(BOOL)selected
{
	[super setSelected:selected];
	m_closeButton.hidden = !selected;
	//m_scaleButton.hidden = !selected;
}

/*
- (void) touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
	[super touchesBegan:touches withEvent:event];
    // Retrieve the touch point
    CGPoint pt = [[touches anyObject] locationInView:self];
    m_startLocation = pt;
    [[self superview] bringSubviewToFront:self];
}

- (void) touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event {
	[super touchesMoved:touches withEvent:event];
    // Move relative to the original touch point
    CGPoint pt = [[touches anyObject] locationInView:self];
    CGRect frame = [self frame];
    frame.origin.x += pt.x - m_startLocation.x;
    frame.origin.y += pt.y - m_startLocation.y;
    [self setFrame:frame];
}
 */

- (void)OnTouchClose:(id)sender
{
	if (m_delegate && [m_delegate respondsToSelector:@selector(OnClose:)]) {
		[m_delegate OnClose:self];
	}
	[self removeFromSuperview];
}

/*
- (void)OnTouchDownScaleBtn:(id)sender
{
	m_scaling = YES;
	NSLog(@"On touch down scale button");
}

- (void)OnTouchUpScaleBtn:(id)sender
{
	m_scaling = NO;
	NSLog(@"On touch up scale button");
}

- (void)OnDragScaleBtn:(id)sender withEvent:(UIEvent*) event
{
	CGPoint point = [[[event allTouches] anyObject] locationInView:self];
	//caculate the angle based on the law of cosines
	NSLog(@"cur point  %f, %f", point.x, point.y);
}
*/
//extend the user interation area 
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
	CGRect closeButtonArea = m_closeButton.frame;
	closeButtonArea.origin.x -= 10;
	closeButtonArea.origin.y -= 10;
	closeButtonArea.size.width += 20;
	closeButtonArea.size.height += 20;
	
	/*
	CGRect scaleButtonArea = m_scaleButton.frame;
	scaleButtonArea.origin.x -= 10;
	scaleButtonArea.origin.y -= 10;
	scaleButtonArea.size.width += 20;
	scaleButtonArea.size.height += 20;
	*/
    if (CGRectContainsPoint(self.bounds, point) ||
        CGRectContainsPoint(closeButtonArea, point)
		/*CGRectContainsPoint(scaleButtonArea, point)*/) {
        return YES;
	}
	return NO;
}

- (void)_RegisterGestures
{
	UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(_PanCell:)];
    [panGesture setMaximumNumberOfTouches:2];
    [panGesture setDelegate:self];
    [self addGestureRecognizer:panGesture];
    [panGesture release];
	
	UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(_ScaleCell:)];
    [pinchGesture setDelegate:self];
    [self addGestureRecognizer:pinchGesture];
    [pinchGesture release];
	
	UIRotationGestureRecognizer *rotationGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(_RotateCell:)];
    [self addGestureRecognizer:rotationGesture];
    [rotationGesture release];
}

#pragma mark UIGestureRecognizerDelegate
// shift the piece's center by the pan amount
// reset the gesture recognizer's translation to {0, 0} after applying so the next callback is a delta from the current position
- (void)_PanCell:(UIPanGestureRecognizer *)gestureRecognizer
{
    MCImageAssemblyViewCell *cell = (MCImageAssemblyViewCell*)[gestureRecognizer view];
    
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan 
		|| [gestureRecognizer state] == UIGestureRecognizerStateChanged) {
		
        CGPoint translation = [gestureRecognizer translationInView:[cell superview]];
        [cell setCenter:CGPointMake([cell center].x + translation.x, [cell center].y + translation.y)];
        [gestureRecognizer setTranslation:CGPointZero inView:[cell superview]];
    }
}

// scale the piece by the current scale
// reset the gesture recognizer's rotation to 0 after applying so the next callback is a delta from the current scale
- (void)_ScaleCell:(UIPinchGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan || [gestureRecognizer state] == UIGestureRecognizerStateChanged) {
        [gestureRecognizer view].transform = CGAffineTransformScale([[gestureRecognizer view] transform], [gestureRecognizer scale], [gestureRecognizer scale]);
        [gestureRecognizer setScale:1];
    }
}

// rotate the piece by the current rotation
// reset the gesture recognizer's rotation to 0 after applying so the next callback is a delta from the current rotation
- (void)_RotateCell:(UIRotationGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan || [gestureRecognizer state] == UIGestureRecognizerStateChanged) {
        [gestureRecognizer view].transform = CGAffineTransformRotate([[gestureRecognizer view] transform], [gestureRecognizer rotation]);
        [gestureRecognizer setRotation:0];
    }
}


@end



@implementation MCImageAssemblyView

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self != nil) {
		[self CommonInit];
	}
	return self;
}

- (void)dealloc
{
	MCSAFERELEASE(m_imageCells)
	[super dealloc];
}

- (void)CommonInit
{
	self.backgroundColor = [UIColor whiteColor];
	m_imageCells = [[NSMutableArray alloc] init];
	[self addTarget:self action:@selector(OnTouch:) forControlEvents:UIControlEventTouchDown];
}


- (void)AddImage:(UIImage*)image
{
	//add image to the center
	CGFloat cellWidth = 80;
	CGFloat cellHeight = 104;
	CGFloat cellX = (self.frame.size.width - cellWidth) / 2;
	CGFloat cellY = (self.frame.size.height - cellHeight) / 2;
	CGRect cellFrame = CGRectMake(cellX, cellY, cellWidth, cellHeight);
	MCImageAssemblyViewCell* cell = [[MCImageAssemblyViewCell alloc] initWithFrame:cellFrame];
	[cell addTarget:self action:@selector(OnTouchCell:) forControlEvents:UIControlEventTouchDown];
    [cell setImage:image forState:UIControlStateNormal];
	cell.Delegate = self;
	[self addSubview:cell];
	[m_imageCells addObject:cell];
	[cell release];
	
}

- (void)OnTouchCell:(id)sender
{
	MCImageAssemblyViewCell* selectedCell = sender;
	
	for (MCImageAssemblyViewCell* cell in m_imageCells) {
		if (cell == selectedCell) {
			cell.selected = YES;
		} else {
			cell.selected = NO;
		}

	}
}

- (void)OnTouch:(id)sender
{
	MCImageAssemblyView* view = sender;
	if (view == self) {
		for (MCImageAssemblyViewCell* cell in m_imageCells) {
			cell.selected = NO;
		}
	}
}

#pragma mark MCImageAssemblyViewCellDelegate Methods
- (void)OnClose:(MCImageAssemblyViewCell*)cell
{
	[m_imageCells removeObject:cell];
}
@end
