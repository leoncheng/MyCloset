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

@implementation MCImageSliderViewResource
@synthesize Image =  m_image;
@synthesize Checked = m_checked;

- (id)init
{
	self = [super init];
	if (self != nil) {
		m_image = nil;
		m_checked = NO;
	}
	return self;
}

- (void)dealloc
{
	MCSAFERELEASE(m_image)
	[super dealloc];
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
	MCSAFERELEASE(m_resources)
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
- (MCImageSliderViewCell*)_CreateImageButton:(CGRect)frame
{
	MCImageSliderViewCell* imageButton = nil;
	imageButton = [[[MCImageSliderViewCell alloc] initWithFrame:frame] autorelease];
	UIEdgeInsets imageEdgeInsets = UIEdgeInsetsMake(5, 5 , 5, 5);
	imageButton.imageEdgeInsets = imageEdgeInsets;
	[imageButton addTarget:self action:@selector(_OnSelectCell:) forControlEvents:UIControlEventTouchUpInside];
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
	CGRect cellFrame = cell.frame;
	NSUInteger resourceIndex = floor(cellFrame.origin.x / m_cellWidth);
	
	if (m_editing) {
		cell.CheckMark = !cell.CheckMark;
		MCImageSliderViewResource* resource = [m_resources objectAtIndex:resourceIndex];
		resource.Checked = !resource.Checked;
	}
	
	if (m_delegate && [m_delegate respondsToSelector:@selector(ImageSliderView:DidSelectedAtIndex:)]) {
		[m_delegate ImageSliderView:self DidSelectedAtIndex:resourceIndex];
	}
}

- (MCImageSliderViewCell*)_DequeueCellWithFrame:(CGRect)frame
{
	//if the first/last data is invisible, deque the cell of it
	//otherwise, create a newCell and return it
	MCImageSliderViewCell *newCell = 0, *firstCell = 0, *lastCell = 0;
	CGFloat endFirstCellOffsetX = 0;
	CGFloat frontLastCellOffsetx = 0;
	if ([m_imageCells count] > 0) {
		firstCell = [m_imageCells objectAtIndex:0];
		endFirstCellOffsetX = firstCell.frame.origin.x + firstCell.frame.size.width;
		lastCell = [m_imageCells objectAtIndex:[m_imageCells count] - 1];
		frontLastCellOffsetx = lastCell.frame.origin.x;
	}

	CGFloat curOffsetX = m_sliderView.contentOffset.x;
	if (firstCell != nil && (endFirstCellOffsetX < curOffsetX)) {
		newCell = firstCell;
		newCell.frame = frame;
		[m_imageCells addObject:newCell];
		[m_imageCells removeObjectAtIndex:0];
	}
	else if(lastCell != nil && (frontLastCellOffsetx > curOffsetX + m_sliderView.frame.size.width)){
		newCell = lastCell;
		newCell.frame = frame;
		[m_imageCells insertObject:newCell atIndex:0];
		[m_imageCells removeObjectAtIndex:[m_imageCells count] - 1];
		
	}
	else {
		newCell = [self _CreateImageButton:frame];
		[m_imageCells addObject:newCell];
		[m_sliderView addSubview:newCell];
	}

	return newCell;
}

- (NSUInteger)_GetCellResourceIndex:(MCImageSliderViewCell*)cell
{
	CGRect cellFrame = cell.frame;
	NSUInteger resourceIndex = floor(cellFrame.origin.x / m_cellWidth);
	return resourceIndex;
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
	m_resources = [[NSMutableArray alloc] init];
	
	m_cellWidth = 80;
	m_cellHeight = self.frame.size.height;
	
	m_lastVisibleCellIndex = -1;
}

- (void)AddImage:(UIImage *)image
{
	MCImageSliderViewResource* imageResource = [[MCImageSliderViewResource alloc] init];
	imageResource.Image = image;
	[m_resources addObject:imageResource];
	[imageResource release];
	
	//resize the silder's content
	CGSize contentSize = m_sliderView.contentSize;
	contentSize.width += m_cellWidth;
	m_sliderView.contentSize = contentSize;
	
	//show the resource in cell if it is visible
	CGFloat curOffsetX = m_sliderView.contentOffset.x;
	CGFloat visibleWidth = m_sliderView.frame.size.width;
	NSLog(@"obj : %x with index: %d", imageResource,[m_resources indexOfObject:imageResource] );
	CGFloat newCellOffsetX = [m_resources indexOfObject:imageResource] * m_cellWidth;
	
	if (curOffsetX + visibleWidth > newCellOffsetX) {
		CGRect newFrame = CGRectMake(newCellOffsetX, 0, m_cellWidth, m_cellHeight);
		MCImageSliderViewCell* cell = [self _DequeueCellWithFrame:newFrame];
		[cell setImage:image forState:UIControlStateNormal];
		m_lastVisibleCellIndex++;
		
	}
}

- (void)ClearImages
{
	for (UIButton* imageBtn in m_imageCells) {
		[imageBtn removeFromSuperview];
	}
	[m_imageCells removeAllObjects];
	[m_resources removeAllObjects];
	m_lastVisibleCellIndex = -1;
	m_sliderView.contentSize = CGSizeZero;
}

- (MCImageSliderViewCell*)CellAtIndex:(NSUInteger)index
{
	return [m_imageCells objectAtIndex:index];
}

- (UIImage*)ImageAtIndex:(NSUInteger)index
{
	MCImageSliderViewResource* resource = [m_resources objectAtIndex:index];
	return resource.Image;
}

- (void)ClearCheckMarks
{
	for (MCImageSliderViewResource* resource in m_resources) {
		resource.Checked = NO;
	}
	for (MCImageSliderViewCell* cell in m_imageCells) {
		cell.CheckMark = NO;
	}
}

- (NSIndexSet*)DeleteCheckedImages
{
	//delete data first 
	NSMutableIndexSet* deletingResouceIndexes = [[[NSMutableIndexSet alloc] init] autorelease];
	NSUInteger resourceIndex = 0;
	for (; resourceIndex < [m_resources count]; resourceIndex++) {
		MCImageSliderViewResource* resource = [m_resources objectAtIndex:resourceIndex];
		if (resource.Checked == YES) {
			[deletingResouceIndexes addIndex:resourceIndex];
		}
	}
	[m_resources removeObjectsAtIndexes:deletingResouceIndexes];
	
	//add new cells
	NSUInteger checkedCellsNumber = 0;
	for (MCImageSliderViewCell* cell in m_imageCells) {
		if (cell.CheckMark == YES) {
			checkedCellsNumber++;
		}
	}
	
	if (checkedCellsNumber > 0) {
		m_lastVisibleCellIndex -= checkedCellsNumber;
		CGFloat curOffsetX = m_sliderView.contentOffset.x;
		for (int i = 0 ; i < checkedCellsNumber; i++) {
			NSUInteger newResourceIndex = (curOffsetX + ([m_imageCells count] - checkedCellsNumber + i) * m_cellWidth)/m_cellWidth;
			if (newResourceIndex < [m_resources count]) {
				CGRect newFrame = CGRectMake((newResourceIndex + checkedCellsNumber) * m_cellWidth, 0, m_cellWidth, m_cellHeight);
				MCImageSliderViewCell* newCell = [self _DequeueCellWithFrame:newFrame];
				MCImageSliderViewResource* resource = [m_resources objectAtIndex:newResourceIndex];
				[newCell setImage:resource.Image forState:UIControlStateNormal];
				newCell.CheckMark = resource.Checked;
				m_lastVisibleCellIndex++;
			}
		}	
	}
	
	//delete and relocate Cells with animation
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
	if ([deletingResouceIndexes count] > 0) {
		CGSize newContentSize = m_sliderView.contentSize;
		newContentSize.width -= 80 * [deletingResouceIndexes count];
		m_sliderView.contentSize = newContentSize;
	}
	return deletingResouceIndexes;
}

- (NSIndexSet*)SelectedCheckedImages
{
	NSMutableIndexSet* resourceIndexes = [[[NSMutableIndexSet alloc] init] autorelease];
	NSUInteger resourceIndex = 0;
	for (; resourceIndex < [m_resources count]; resourceIndex++) {
		MCImageSliderViewResource* resource = [m_resources objectAtIndex:resourceIndex];
		if (resource.Checked) {
			[resourceIndexes addIndex:resourceIndex];
		}
	}
	return resourceIndexes;
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	CGFloat visibleWidth = m_sliderView.frame.size.width;
	CGFloat curOffsetX = m_sliderView.contentOffset.x;
	NSUInteger lastResourceIndex = [m_resources count] ? [m_resources count] - 1 : 0; 
	NSUInteger newLastVisibleCellIndex = MIN(ceil((curOffsetX + visibleWidth) / m_cellWidth) - 1, lastResourceIndex);
	NSUInteger newFirstVisibleCellIndex = MAX(floor(curOffsetX / m_cellWidth), 0); 
	NSUInteger visibleCellsNumber = MIN(([m_imageCells count] - 1), visibleWidth/m_cellWidth);
	NSUInteger firstVisibleCellIndex = m_lastVisibleCellIndex - visibleCellsNumber;
	
	if (newLastVisibleCellIndex > m_lastVisibleCellIndex) {
		CGRect newFrame = CGRectMake(newLastVisibleCellIndex * m_cellWidth, 0, m_cellWidth, m_cellHeight);
		MCImageSliderViewCell* cell = [self _DequeueCellWithFrame:newFrame];
		MCImageSliderViewResource* resource = [m_resources objectAtIndex:newLastVisibleCellIndex];
		[cell setImage:resource.Image forState:UIControlStateNormal];
		cell.CheckMark = resource.Checked;
		m_lastVisibleCellIndex = newLastVisibleCellIndex;
	}
	else if(newFirstVisibleCellIndex < firstVisibleCellIndex)
	{
		CGRect newFrame = CGRectMake(newFirstVisibleCellIndex * m_cellWidth, 0, m_cellWidth, m_cellHeight);
		MCImageSliderViewCell* cell = [self _DequeueCellWithFrame:newFrame];
		MCImageSliderViewResource* resource = [m_resources objectAtIndex:newFirstVisibleCellIndex];
		[cell setImage:resource.Image forState:UIControlStateNormal];
		cell.CheckMark = resource.Checked;
		m_lastVisibleCellIndex = newFirstVisibleCellIndex + visibleCellsNumber;
	}
}

@end
