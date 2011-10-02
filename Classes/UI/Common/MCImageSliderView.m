//
//  MCImageSliderView.m
//  MyCloset
//
//  Created by mmcl on 11-9-25.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MCImageSliderView.h"
#import <QuartzCore/QuartzCore.h>

@implementation MCImageSliderViewCell
@synthesize Editing = m_editing;
@synthesize CheckMark = m_checkMark;

- (void)CommonInit
{
	CGSize checkMarkSize = CGSizeMake(30, 30);
	CGSize imageCellSize = self.frame.size;
	m_checkMarkView = [[UIImageView alloc] initWithFrame:
							  CGRectMake(imageCellSize.width - checkMarkSize.width, imageCellSize.height-checkMarkSize.height,
										 checkMarkSize.width, checkMarkSize.height)];
	m_checkMarkView.image = [UIImage imageNamed:@"checkMark.png"];
	
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
	MCSAFERELEASE(m_checkMarkView)
	[super dealloc];
}

- (void)setCheckMark:(BOOL)checked
{
	m_checkMark = checked;
	
	if (checked) {
		[self addSubview:m_checkMarkView];
	}
	else
	{
		[m_checkMarkView removeFromSuperview];
	}

}

@end

@implementation MCImageSliderView
@synthesize Delegate = m_delegate;
@synthesize Editing = m_editing;

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
	MCSAFERELEASE(m_curDeletingCells)
	MCSAFERELEASE(m_sliderView)
	[super dealloc];
}

-(void) animationDidStop:(CAAnimation *) animation finished:(BOOL) flag
{
	NSLog(@"end delete current cell");
	for (MCImageSliderViewCell* imageCell in m_curDeletingCells) {
		[imageCell removeFromSuperview];
	}
	[m_imageCells removeObjectsInArray:m_curDeletingCells];
	[m_curDeletingCells removeAllObjects];
}

- (void)setEditing:(BOOL)editing
{
	m_editing = editing;
	
	//clear all check marks in imageResource
	[self ClearCheckMarks];
}


#pragma mark Customized private methods
- (MCImageSliderViewCell*)_CreateImageButton:(CGRect)frame withImage:(UIImage*)image
{
	MCImageSliderViewCell* imageButton = nil;
	if (image != nil) {
		imageButton = [[[MCImageSliderViewCell alloc] initWithFrame:frame] autorelease];
		[imageButton setImage:image forState:UIControlStateNormal];
		UIEdgeInsets imageEdgeInsets = UIEdgeInsetsMake(5, 5 , 5, 5);
		imageButton.imageEdgeInsets = imageEdgeInsets;
		
	}
	return imageButton;
}

- (void)_AutoAlignScrollView:(UIScrollView*)scrollView
{
	CGPoint curOffset = scrollView.contentOffset;
	
	NSInteger deltaOffsetX = (NSInteger)curOffset.x % 80;
	
	if (deltaOffsetX > 40) 
	{
		[scrollView setContentOffset:CGPointMake(curOffset.x + 80 - deltaOffsetX, curOffset.y) animated:YES];
	}
	else 
	{
		[scrollView setContentOffset:CGPointMake(curOffset.x - deltaOffsetX, curOffset.y) animated:YES];
	}
}

- (void)_OnSelectCell:(id)sender
{
	MCImageSliderViewCell* cell = sender;
	
	if (m_editing) {
		cell.CheckMark = !cell.CheckMark;
	}
	
	NSUInteger cellIndex = [m_imageCells indexOfObject:cell];
	
	if (m_delegate && [m_delegate respondsToSelector:@selector(ImageSliderView:DidSelectedAtIndex:)]) {
		[m_delegate ImageSliderView:self DidSelectedAtIndex:cellIndex];
	}
}



#pragma mark Customized public methods
- (void)CommonInit
{
	m_sliderView = [[UIScrollView alloc] initWithFrame:self.bounds];
	m_sliderView.scrollEnabled = YES;
	m_sliderView.alwaysBounceHorizontal = YES;
	m_sliderView.delegate = self;
	[self addSubview:m_sliderView];
	
	m_imageCells = [[NSMutableArray alloc] init];
	m_curDeletingCells = [[NSMutableArray alloc]init];
}

- (void)AddImage:(UIImage *)image
{
	NSInteger imagesCount = [m_imageCells count];
	NSInteger imageCellIndex = imagesCount;
	CGFloat imageCellWidth = 80;
	CGFloat imageCellHeight = self.frame.size.height;
	
	MCImageSliderViewCell* imageCell = [self _CreateImageButton:
							 CGRectMake(imageCellIndex * imageCellWidth, 0, imageCellWidth, imageCellHeight) withImage:image];
	if (imageCell != nil) {
		[m_sliderView addSubview:imageCell];
		
		[m_imageCells addObject:imageCell];
		m_sliderView.contentSize = CGSizeMake([m_imageCells count] * imageCellWidth, imageCellHeight);
		[imageCell addTarget:self action:@selector(_OnSelectCell:) forControlEvents:UIControlEventTouchUpInside];
	}
	
}

- (void)ClearImages
{
	for (UIButton* imageBtn in m_imageCells) {
		[imageBtn removeFromSuperview];
	}
	[m_imageCells removeAllObjects];
}

- (MCImageSliderViewCell*)CellAtIndex:(NSUInteger)index
{
	return [m_imageCells objectAtIndex:index];
}

- (void)ClearCheckMarks
{
	for (MCImageSliderViewCell* imageCell in m_imageCells) {
		imageCell.CheckMark = NO;
	}
}

- (NSIndexSet*)DeleteCheckedImages
{
	NSMutableIndexSet* deletedCellIndexes = [[NSMutableIndexSet alloc] init];
	for (MCImageSliderViewCell* imageCell in m_imageCells) {
		if (imageCell.CheckMark == YES) {
			CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
			animationGroup.removedOnCompletion = YES;
			animationGroup.delegate = self;
			animationGroup.duration = 0.1;
			
			CABasicAnimation *fadeAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
			fadeAnimation.fromValue = [NSNumber numberWithFloat:1.0];
			fadeAnimation.toValue = [NSNumber numberWithFloat:0.0];
			
			
			CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
			scaleAnimation.fromValue = [NSNumber numberWithFloat:1.0];
			scaleAnimation.toValue = [NSNumber numberWithFloat:0.0];
			
			animationGroup.animations = [NSArray arrayWithObjects:fadeAnimation, nil];
			
			[imageCell.layer addAnimation:animationGroup forKey:@"tranformAnimation"];
			imageCell.layer.opacity = 0.0;
			
			[m_curDeletingCells addObject:imageCell];
			NSUInteger cellIndex = [m_imageCells indexOfObject:imageCell];
			[deletedCellIndexes addIndex:cellIndex];
			
		}
		//relocate the sibling cells 
		if ([m_curDeletingCells count] > 0) {
			NSUInteger nextCellIndex = [m_imageCells indexOfObject:imageCell] + 1;
			if (nextCellIndex < [m_imageCells count]) {
				MCImageSliderViewCell* nextCell = [m_imageCells objectAtIndex:nextCellIndex];
				CGPoint newCenter = nextCell.center;
				newCenter.x -= 80 * [m_curDeletingCells count];
				CABasicAnimation* translateAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
				translateAnimation.fromValue = [NSValue valueWithCGPoint:nextCell.center];
				translateAnimation.toValue = [NSValue valueWithCGPoint:newCenter];
				translateAnimation.duration = 0.1;
				[nextCell.layer addAnimation:translateAnimation forKey:@"relocate"];
				nextCell.layer.position = newCenter;
				NSLog(@"next cell's new center: %f", newCenter.x);
			}
		}
	}
	//resize the content at the end
	if ([m_curDeletingCells count] > 0) {
		CGSize newContentSize = m_sliderView.contentSize;
		newContentSize.width -= 80 * [m_curDeletingCells count];
		m_sliderView.contentSize = newContentSize;
	}
	return deletedCellIndexes;
}

#pragma mark UIScrollViewDelegate methods

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	[self _AutoAlignScrollView:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	if (decelerate == NO) {
		[self _AutoAlignScrollView:scrollView];
	}
}

@end
