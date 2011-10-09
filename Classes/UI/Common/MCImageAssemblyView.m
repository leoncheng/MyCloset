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
	CGFloat scaleBtnWidth = 20;
	CGFloat scaleBtnHeight = 20;
	CGFloat scaleBtnX = -10 + self.frame.size.width;
	CGFloat scaleBtnY = -10 + self.frame.size.height;
	m_scaleButton = [[UIButton alloc] initWithFrame:CGRectMake(scaleBtnX, scaleBtnY, scaleBtnWidth, scaleBtnHeight)];
	[m_scaleButton setImage:[UIImage imageNamed:@"scaleButton.jpeg"] forState:UIControlStateNormal];
	[self addSubview:m_scaleButton];
	m_scaleButton.hidden = YES;
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
	MCSAFERELEASE(m_scaleButton)
	[super dealloc];
}

- (void)setSelected:(BOOL)selected
{
	[super setSelected:selected];
	m_closeButton.hidden = !selected;
	m_scaleButton.hidden = !selected;
}


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

- (void)OnTouchClose:(id)sender
{
	if (m_delegate && [m_delegate respondsToSelector:@selector(OnClose:)]) {
		[m_delegate OnClose:self];
	}
	[self removeFromSuperview];
}

//extend the user interation area 
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
	CGRect buttonFrame = m_closeButton.frame;
	buttonFrame.origin.x -= 10;
	buttonFrame.origin.y -= 10;
	buttonFrame.size.width += 20;
	buttonFrame.size.height += 20;
	
    if (CGRectContainsPoint(self.bounds, point) ||
        CGRectContainsPoint(buttonFrame, point)){
        return YES;
	}
	return NO;
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
