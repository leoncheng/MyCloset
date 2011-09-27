//
//  MCImageSliderView.m
//  MyCloset
//
//  Created by mmcl on 11-9-25.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MCImageSliderView.h"


@implementation MCImageSliderView

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
	MCSAFERELEASE(m_images)
	[super dealloc];
}

#pragma mark Customized methods
- (UIButton*)_CreateImageButton:(CGRect)frame
{
	UIButton* imageButton = [[[UIButton alloc] initWithFrame:frame] autorelease];
	UIImage* image = [UIImage imageNamed:@"MeganFox.jpg"];
	[imageButton setImage:image forState:UIControlStateNormal];
	UIEdgeInsets imageEdgeInsets = UIEdgeInsetsMake(5, 5 , 5, 5);
	imageButton.imageEdgeInsets = imageEdgeInsets;
	return imageButton;
}

- (void)CommonInit
{
	self.scrollEnabled = YES;
	self.alwaysBounceHorizontal = YES;
	self.delegate = self;
	
	m_images = [[NSMutableArray alloc] init];
}

- (void)AddImage:(UIImage *)image
{
	[m_images addObject:image];
	
	NSInteger imagesCount = [m_images count];
	NSInteger imageButtonIndex = MAX(imagesCount - 1, 0);
	CGFloat imageButtonWidth = 80;
	CGFloat imageButtonHeight = self.frame.size.height;
	UIButton* imageButton = [self _CreateImageButton:CGRectMake(imageButtonIndex * imageButtonWidth, 0, imageButtonWidth, imageButtonHeight)];
	[self addSubview:imageButton];
	
	self.contentSize = CGSizeMake(imagesCount * imageButtonWidth, imageButtonHeight);
}

- (void)_AutoAlignScrollView:(UIScrollView*)scrollView
{
	CGPoint curOffset = scrollView.contentOffset;
	
	NSInteger deltaOffsetX = (NSInteger)curOffset.x % 80;
	
	if (deltaOffsetX > 40) 
	{
		[self setContentOffset:CGPointMake(curOffset.x + 80 - deltaOffsetX, curOffset.y) animated:YES];
	}
	else 
	{
		[self setContentOffset:CGPointMake(curOffset.x - deltaOffsetX, curOffset.y) animated:YES];
	}
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
