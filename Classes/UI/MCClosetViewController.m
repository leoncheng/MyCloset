    //
//  MCClosetViewController.m
//  MyCloset
//
//  Created by mmcl on 11-9-25.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MCClosetViewController.h"

@implementation MCClosetColumnCell

- (void)CommonInit
{
	CGRect sliderframe = self.bounds;
	sliderframe.size.height = 104;	//the height of the cell is still 44 at the moment, so we need to assign 104 manually
	
	MCImageSliderView* itemsSliderView = [[MCImageSliderView alloc] initWithFrame:sliderframe];
	[self addSubview:itemsSliderView];
	[itemsSliderView release];
}

- (void)OnResourceChanged:(MCTableViewResource *)resource
{
	//do nothing
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


@end