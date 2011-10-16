    //
//  MCOutfitImageViewController.m
//  MyCloset
//
//  Created by mmcl on 11-10-16.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MCOutfitImageViewController.h"


@implementation MCOutfitImageViewController

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor blackColor];
	m_outfitView.image = [self GetParamForKey:@"outfitImage"];

}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	//fade in the outfit view
	m_outfitView.alpha = 0.f;
	[UIView beginAnimations: nil context: nil];
	[UIView setAnimationDuration:0.5f];
	[UIView setAnimationDelegate:self];
	m_outfitView.alpha = 1.0;
	[UIView commitAnimations];
	
}
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)CommonInit
{
	[super CommonInit];
	m_outfit = [[[MCModelHelper SharedInstance] CreateModelBy:@"MCOutfit"] retain];

}

- (void)dealloc {
	MCSAFERELEASE(m_outfit)
    [super dealloc];
}


- (void)ReleaseViews
{
	MCSAFERELEASE(m_outfitView) 
	[super ReleaseViews];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
	//launch options's sheet
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
															 delegate:self 
													cancelButtonTitle:@"取消" 
											   destructiveButtonTitle:@"保存"
													otherButtonTitles:nil];
	
	actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
	[actionSheet showInView:self.view]; 
	[actionSheet release];
}


#pragma mark UIActionSheetDelegate methods
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	[self.parentViewController dismissModalViewControllerAnimated:YES];
	
	if (buttonIndex == 0) {
		m_outfit.Thumbnail = [self GetParamForKey:@"outfitImage"];
		[[MCModelHelper SharedInstance] Save:m_outfit];
		[[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadOutfitList" object:nil];
		
		MyClosetAppDelegate* curAppDelegate = (MyClosetAppDelegate*)[UIApplication sharedApplication].delegate;
		[curAppDelegate.TabBarController setSelectedIndex:1]; //go to outfit tab
	}
}


@end
