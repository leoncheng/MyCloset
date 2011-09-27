    //
//  MCAddItemViewController.m
//  MyCloset
//
//  Created by mmcl on 11-9-27.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MCAddItemViewController.h"


@implementation MCAddItemViewController

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	UIBarButtonItem* closeBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
																			  target:self 
																			  action:@selector(_OnTouchSaveBtn)]; 
	self.navigationItem.leftBarButtonItem = closeBtn;
	[closeBtn release];
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

#pragma mark customized private methods
- (void)_OnTouchSaveBtn
{
	// Fetch the recipe types in alphabetical order by name from the recipe's context.
	NSArray* types = [[MCModelHelper SharedInstance]Load:@"MCItemType"];
	MCItemType* curType = [types objectAtIndex:0];
	
    MCItem *item = [[MCModelHelper SharedInstance] CreateModelBy:@"MCItem"];
	item.Price = [NSNumber numberWithInt:2000];
	item.Type = curType;
	
	[[MCModelHelper SharedInstance]Save:item];
	
	//close controller
	[self.navigationController.parentViewController dismissModalViewControllerAnimated:YES];
}

@end
