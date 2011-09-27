    //
//  MCClosetViewController.m
//  MyCloset
//
//  Created by mmcl on 11-9-25.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MCClosetViewController.h"
#import "MCAddItemViewController.h"

@implementation MCClosetColumnCell

- (void)CommonInit
{
	CGRect sliderframe = self.bounds;
	sliderframe.size.height = 104;	//the height of the cell is still 44 at the moment, so we need to assign 104 manually
	
	m_itemsSliderView = [[MCImageSliderView alloc] initWithFrame:sliderframe];
	[self addSubview:m_itemsSliderView];
}

- (void)OnResourceChanged:(MCTableViewResource *)resource
{
	NSArray* items = [[MCModelHelper SharedInstance] Load:@"MCItem"];
	for (int i = 0; i < [items count]; i++) 
	{
		[m_itemsSliderView AddImage:[UIImage imageNamed:@"MeganFox.jpg"]];
	}
}

- (void)dealloc
{
	MCSAFERELEASE(m_itemsSliderView)
	[super dealloc];
}

@end


@implementation MCClosetViewController

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

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	//customize row height
	UITableView* curView = self.tableView;
	curView.rowHeight = 104; //we only need 4 rows, each one's height is 104
	
	curView.scrollEnabled = NO;
	
	MCTableViewResource* resource = [[MCTableViewResource alloc] init];
	resource.CellName = @"MCClosetColumnCell";
	[self AddResource:resource];
	[resource release];
	
	//add addItem button on navigation bar
	UIBarButtonItem* addItemBtn = [[UIBarButtonItem alloc] 
								   initWithBarButtonSystemItem:UIBarButtonSystemItemAdd 
								   target:self action:@selector(OnTouchAddItemBtn)];
	self.navigationItem.rightBarButtonItem = addItemBtn;
	[addItemBtn release];
}

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

#pragma mark Customized private methods
- (void)OnTouchAddItemBtn
{
	MCAddItemViewController* controller = [[MCAddItemViewController alloc] initWithNibName:@"MCAddItemViewController" bundle:nil];
	UINavigationController* naviController = [[UINavigationController alloc] initWithRootViewController:controller];
	[controller release];
	[self presentModalViewController:naviController animated:YES];
	[naviController release];
	
}

@end
