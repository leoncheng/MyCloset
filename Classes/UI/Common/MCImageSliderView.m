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

	CGFloat imageButtonWidth = 80;
	CGFloat imageButtonHeight = self.frame.size.height;
	for (int i = 0; i < 4 ; i++) {
		UIButton* imageButton = [self _CreateImageButton:CGRectMake(i * imageButtonWidth, 0, imageButtonWidth, imageButtonHeight)];
		[self addSubview:imageButton];
	}
	self.contentSize = CGSizeMake(400, imageButtonHeight);
}


@end
