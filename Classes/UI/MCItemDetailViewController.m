    //
//  MCAddItemViewController.m
//  MyCloset
//
//  Created by mmcl on 11-9-27.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MCItemDetailViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>

@implementation MCItemDetailViewController
@synthesize Delegate = m_delegate;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	UIBarButtonItem* saveBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
																			  target:self 
																			  action:@selector(_OnTouchSaveBtn)]; 
	self.navigationItem.leftBarButtonItem = saveBtn;
	[saveBtn release];
	
	UIBarButtonItem* cancelBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
																			 target:self 
																			 action:@selector(_OnTouchCancelBtn)]; 
	self.navigationItem.rightBarButtonItem = cancelBtn;
	[cancelBtn release];
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
	MCSAFERELEASE(m_item)
    [super dealloc];
}

- (void)CommonInit
{
	[super CommonInit];
	
	// Fetch the recipe types in alphabetical order by name from the recipe's context.
    m_item = [[[MCModelHelper SharedInstance] CreateModelBy:@"MCItem"] retain];
	m_item.Price = [NSNumber numberWithInt:2000];
	
	
}

- (void)ReleaseViews
{
	MCSAFERELEASE(m_photoBtn)
	MCSAFERELEASE(m_typesCtrl)
	[super ReleaseViews];
}

#pragma mark customized private methods
- (void)_Close
{
	[self.navigationController.parentViewController dismissModalViewControllerAnimated:YES];
}

- (void)_OnTouchSaveBtn
{
	NSArray* types = [[MCModelHelper SharedInstance]Load:@"MCItemType"];
	m_item.Type = [types objectAtIndex:m_typesCtrl.selectedSegmentIndex];
	
	[[MCModelHelper SharedInstance]Save:m_item];
	
	if (m_delegate && [m_delegate respondsToSelector:@selector(OnSave)]) {
		[m_delegate performSelector:@selector(OnSave)];
	}
	[self _Close];
}

- (void)_OnTouchCancelBtn
{
	[self _Close];
}

- (void)_LaunchCameraView
{
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO)
	{
		return ;
	}
	
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
	
    // Displays a control that allows the user to choose picture or
    // movie capture, if both are available:
    cameraUI.mediaTypes =
	[UIImagePickerController availableMediaTypesForSourceType:
	 UIImagePickerControllerSourceTypeCamera];
	
    // Hides the controls for moving & scaling pictures, or for
    // trimming movies. To instead show the controls, use YES.
    cameraUI.allowsEditing = NO;
	
    cameraUI.delegate = self;
	
    [self presentModalViewController: cameraUI animated: YES];
	[cameraUI release];
}

#pragma mark customized public methods
- (IBAction)OnTouchPhotoBtn
{
	// open a dialog with an OK and cancel button
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
															 delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"相机" otherButtonTitles:nil];
	actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
	[actionSheet showInView:self.view]; // show from our table view (pops up in the middle of the table)
	[actionSheet release];
	
}

#pragma mark UIActionSheetDelegate methods
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 0) {
		//present modal camera view
		[self _LaunchCameraView];
	}
}

#pragma mark mark UIImagePickerControllerDelegate methods

- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker
{
    [[picker parentViewController] dismissModalViewControllerAnimated: YES];
}

// For responding to the user accepting a newly-captured picture or movie
- (void) imagePickerController: (UIImagePickerController *) picker
 didFinishPickingMediaWithInfo: (NSDictionary *) info 
{	
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    UIImage *originalImage;
	
    // Handle a still image capture
    if (CFStringCompare ((CFStringRef) mediaType, kUTTypeImage, 0)
		== kCFCompareEqualTo) 
	{
        originalImage = (UIImage *) [info objectForKey:
									 UIImagePickerControllerOriginalImage];
		
		[m_photoBtn setImage:originalImage forState:UIControlStateNormal];
		[m_photoBtn setTitle:nil forState:UIControlStateNormal];
		m_item.ThumbnailImage = originalImage;
    }
	
    [[picker parentViewController] dismissModalViewControllerAnimated: YES];
}
@end
