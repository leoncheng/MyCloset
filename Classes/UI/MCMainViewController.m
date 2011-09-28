    //
//  MCMainViewController.m
//  MyCloset
//
//  Created by mmcl on 11-9-24.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MCMainViewController.h"
#import "MCClosetViewController.h"

@implementation MCMainViewController

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	
	/*
	MCItemType* type = [[MCModelHelper SharedInstance] CreateModelBy:@"MCItemType"];
	type.Name = @"上装";
	
	[[MCModelHelper SharedInstance] Save:type];
	*/
	 
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

#pragma mark customized methods

- (IBAction)SaveItem
{
	// Fetch the recipe types in alphabetical order by name from the recipe's context.
	NSArray* types = [[MCModelHelper SharedInstance]Load:@"MCItemType"];
	MCItemType* curType = [types objectAtIndex:0];
	
    MCItem *item = [[MCModelHelper SharedInstance] CreateModelBy:@"MCItem"];
	item.Price = [NSNumber numberWithInt:2000];
	item.Type = curType;
	
	[[MCModelHelper SharedInstance]Save:item];
				
}

- (IBAction)OpenCloset
{
	MCClosetViewController* controller = [[MCClosetViewController alloc] initWithStyle:UITableViewStylePlain];
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
}

@end
