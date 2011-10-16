    //
//  MCOutfitsViewController.m
//  MyCloset
//
//  Created by mmcl on 11-10-15.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MCOutfitsViewController.h"

#define MC_OUTFITS_GRID_HEIGHT 92

@implementation MCOutfitsViewCell

- (void)CommonInit
{
	CGRect sliderframe = self.bounds;
	sliderframe.size.height = MC_OUTFITS_GRID_HEIGHT;	//the height of the cell is still 44 at the moment, so we need to assign 91 manually
	
	m_outfitsRowView = [[MCImageSliderView alloc] initWithFrame:sliderframe];
	[self addSubview:m_outfitsRowView];
}

- (void)OnResourceChanged:(MCTableViewResource *)resource atRow:(NSUInteger)row
{
	[m_outfitsRowView ClearImages];
	NSArray* imageList = resource.Data;
	for (UIImage* outfitThumbnail in imageList) {
		[m_outfitsRowView AddImage:outfitThumbnail];
	}
	
}


- (void)dealloc
{
	MCSAFERELEASE(m_outfitsRowView)
	[super dealloc];
}

@end



@implementation MCOutfitsViewController

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"着装";
	
	//customize row height
	UITableView* curView = self.tableView;
	curView.rowHeight = MC_OUTFITS_GRID_HEIGHT; //we only need 4 rows, each one's height is 92	
	
	[self _FillOutfitResouce];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_ReloadOutfitList) name:@"ReloadOutfitList" object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear: animated];
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

- (void)_FillOutfitResouce
{
	[self ClearResources];
	NSArray* outfitList = [[MCModelHelper SharedInstance] Load:@"MCOutfit"];
	for (int i = 0; i < [outfitList count]; i += 4) {
		//load outfits data, and create table cell resource
		NSMutableArray* outfitThumbnails = [[NSMutableArray alloc] init];
		for (int j = 0; j < 4; j++) {
			NSUInteger outfitIndex = i + j;
			if (outfitIndex < [outfitList count]) {
				MCOutfit* outfit = [outfitList objectAtIndex:outfitIndex];
				if (outfit.Thumbnail != nil) {
					[outfitThumbnails addObject:outfit.Thumbnail];
				}
				
			}
			
		}
		
		MCTableViewResource* outfitsRowData = [[MCTableViewResource alloc] init];
		outfitsRowData.CellName = @"MCOutfitsViewCell";
		outfitsRowData.Data = outfitThumbnails;
		[outfitThumbnails release];	
		
		[self AddResource:outfitsRowData];
		[outfitsRowData release];
	}	
}

- (void)_ReloadOutfitList
{
	[self _FillOutfitResouce];
	[self.tableView reloadData];
}

@end
