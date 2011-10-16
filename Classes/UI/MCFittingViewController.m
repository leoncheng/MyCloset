    //
//  MCFittingViewController.m
//  MyCloset
//
//  Created by mmcl on 11-10-6.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MCFittingViewController.h"
#import "MCOutfitImageViewController.h"

@implementation MCFittingViewController

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = @"试衣间";
	self.navigationItem.hidesBackButton = YES; 
	
	UIBarButtonItem* closetBtnItem = [[UIBarButtonItem alloc] 
						initWithTitle:@"衣橱" 
						style:UIBarButtonItemStyleBordered 
						target:self 
						action:@selector(_OnTouchClosetItemBtn:)];
	self.navigationItem.rightBarButtonItem = closetBtnItem;
	
	UIBarButtonItem* saveBtnItem = [[UIBarButtonItem alloc] 
									  initWithTitle:@"保存" 
									  style:UIBarButtonItemStyleBordered 
									  target:self 
									  action:@selector(_OnTouchSaveBtn:)];
	self.navigationItem.leftBarButtonItem = saveBtnItem;	
	
	//add items slider at the bottom of the view
	CGRect itemSliderFrame = self.view.frame;
	itemSliderFrame.size.height = 92;
	itemSliderFrame.origin.y = self.view.frame.size.height - itemSliderFrame.size.height;
	m_itemSlider = [[MCImageSliderView alloc] initWithFrame:itemSliderFrame];
	m_itemSlider.Delegate = self;
	NSArray* selectedItems = [self GetParamForKey:@"selectedItems"];
	for (MCItem* item in selectedItems) {
		[m_itemSlider AddImage:item.ThumbnailImage];
	}
	[self.view addSubview:m_itemSlider];
	
	//add item assembly view
	CGRect assemblyViewFrame = self.view.frame;
	assemblyViewFrame.size.height -= itemSliderFrame.size.height;
	m_assemblyView = [[MCImageAssemblyView alloc] initWithFrame:assemblyViewFrame];
	[self.view addSubview:m_assemblyView];
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


- (void)dealloc {
    [super dealloc];
}

- (void)ReleaseViews
{
	MCSAFERELEASE(m_itemSlider)
	MCSAFERELEASE(m_assemblyView)
}

- (void)_OnTouchClosetItemBtn:(id)sender
{
	[UIView  beginAnimations:nil context:NULL];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.75];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.navigationController.view cache:NO];
	[UIView commitAnimations];
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDelay:0.1];
	[self.navigationController popViewControllerAnimated:NO];
	[UIView commitAnimations];
	 
	//[self.parentViewController dismissModalViewControllerAnimated:YES];
}

- (void)_OnTouchSaveBtn:(id)sender
{
	// Capture screen here...
	CGRect imageRect = [m_assemblyView bounds];    
    UIGraphicsBeginImageContext(imageRect.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext(); 
    [m_assemblyView.layer renderInContext:ctx];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
	
	MCOutfitImageViewController* controller = [[MCOutfitImageViewController alloc] initWithNibName:@"MCOutfitImageViewController" bundle:nil];
	[controller SetParam:newImage withKey:@"outfitImage"];
	[self  presentModalViewController:controller animated:NO];
	[controller release];
	
}

#pragma mark MCImageSliderViewDelegate Methods
- (void)ImageSliderView:(MCImageSliderView*)imageSlider DidSelectedAtIndex:(NSUInteger)index
{
	UIImage* itemImage = [imageSlider ImageAtIndex:index];
	[m_assemblyView AddImage:itemImage];
}

@end
