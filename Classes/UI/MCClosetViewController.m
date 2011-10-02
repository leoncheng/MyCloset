    //
//  MCClosetViewController.m
//  MyCloset
//
//  Created by mmcl on 11-9-25.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MCClosetViewController.h"
#import "MCItemDetailViewController.h"

@implementation MCClosetColumnCell

- (void)CommonInit
{
	CGRect sliderframe = self.bounds;
	sliderframe.size.height = 104;	//the height of the cell is still 44 at the moment, so we need to assign 104 manually
	
	m_itemsSliderView = [[MCImageSliderView alloc] initWithFrame:sliderframe];
	[self addSubview:m_itemsSliderView];
	m_itemsSliderView.Delegate = self;
}

- (void)OnResourceChanged:(MCTableViewResource *)resource atRow:(NSUInteger)row
{
	[m_itemsSliderView ClearImages];
	NSArray* typeList = [[MCModelHelper SharedInstance] Load:@"MCItemType"];
	
	MCItemType* curType = [typeList objectAtIndex:row];
	NSSet* itemList = curType.Items;
	
	for (MCItem* item in itemList) 
	{
		UIImage* image = item.ThumbnailImage;
		if( image == nil)
		{
			image = [UIImage imageNamed:@"MeganFox.jpg"];
		}
		[m_itemsSliderView AddImage:image];
	}
}

- (void)dealloc
{
	MCSAFERELEASE(m_itemsSliderView)
	[super dealloc];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
	[super setEditing:editing animated:animated];
	m_itemsSliderView.Editing = editing;
}

- (void)DeleteItems
{
	NSIndexSet* deletedItemIndexes = [m_itemsSliderView DeleteCheckedImages];
	NSArray* itemList = [[MCModelHelper SharedInstance] Load:@"MCItem"];
	NSArray* deletedItems = [itemList objectsAtIndexes:deletedItemIndexes];
	[[MCModelHelper SharedInstance] Delete:deletedItems];
	
}

#pragma mark MCImageSliderViewDelegate methods
- (void)ImageSliderView:(MCImageSliderView*)imageSlider DidSelectedAtIndex:(NSUInteger)index
{
	
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
	
	NSArray* typeList = [[MCModelHelper SharedInstance] Load:@"MCItemType"];
	if ([typeList count] == 0) {
		MCItemType* type = [[MCModelHelper SharedInstance] CreateModelBy:@"MCItemType"];
		type.Name = @"配饰";
		
		[[MCModelHelper SharedInstance] Save:type];
		
		type = [[MCModelHelper SharedInstance] CreateModelBy:@"MCItemType"];
		type.Name = @"上装";
		
		[[MCModelHelper SharedInstance] Save:type];
		
		type = [[MCModelHelper SharedInstance] CreateModelBy:@"MCItemType"];
		type.Name = @"下装";
		
		[[MCModelHelper SharedInstance] Save:type];
		
		type = [[MCModelHelper SharedInstance] CreateModelBy:@"MCItemType"];
		type.Name = @"鞋";
		
		[[MCModelHelper SharedInstance] Save:type];
		
		typeList = [[MCModelHelper SharedInstance] Load:@"MCItemType"];
	}
	
	
	self.title = @"我的衣柜";
	
	//customize row height
	UITableView* curView = self.tableView;
	curView.rowHeight = 104; //we only need 4 rows, each one's height is 104
	
	curView.scrollEnabled = NO;
	
	for (int i = 0; i < [typeList count]; i++) {
		MCTableViewResource* resource = [[MCTableViewResource alloc] init];
		resource.CellName = @"MCClosetColumnCell";
		[self AddResource:resource];
		[resource release];
	}
	
	//add addItem button on navigation bar
	m_addBtnItem = [[UIBarButtonItem alloc] 
								   initWithBarButtonSystemItem:UIBarButtonSystemItemAdd 
								   target:self action:@selector(OnTouchAddItemBtn)];
	self.navigationItem.rightBarButtonItem = m_addBtnItem;
	
	//add editItem button on navigation bar
	m_editBtnItem = [[UIBarButtonItem alloc] 
									initWithTitle:@"编辑" 
									style:UIBarButtonItemStyleBordered 
									target:self 
									action:@selector(_OnTouchEditItemBtn:)];
	self.navigationItem.leftBarButtonItem = m_editBtnItem;
	
	m_deleteBtnItem = [[UIBarButtonItem alloc] initWithTitle:@"删除" 
													   style:UIBarButtonItemStyleBordered 
														target:self 
													  action:@selector(_OnTouchDeleteItemBtn:)];
	
	
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

- (void)ReleaseViews
{
	MCSAFERELEASE(m_deleteBtnItem)
	MCSAFERELEASE(m_editBtnItem)
	MCSAFERELEASE(m_addBtnItem)
	
}

#pragma mark Customized private methods
- (void)OnTouchAddItemBtn
{
	MCItemDetailViewController* controller = [[MCItemDetailViewController alloc] initWithNibName:@"MCItemDetailViewController" bundle:nil];
	controller.Delegate = self;
	UINavigationController* naviController = [[UINavigationController alloc] initWithRootViewController:controller];
	[controller release];
	[self presentModalViewController:naviController animated:YES];

	NSLog(@"%@", NSStringFromClass([naviController.parentViewController class]));
	
	[naviController release];
}

- (void)_OnTouchEditItemBtn:(id)sender
{
	self.editing = !self.editing;
	UIBarButtonItem* editBtnItem = sender;
	if (self.editing) {
		
		editBtnItem.title = @"完成";
		editBtnItem.style = UIBarButtonItemStyleDone;
		
		//remove addItem btn and delete btn
		self.navigationItem.rightBarButtonItem = m_deleteBtnItem;
		
	}
	else 
	{
		editBtnItem.title = @"编辑";
		editBtnItem.style = UIBarButtonItemStyleBordered;
		
		self.navigationItem.rightBarButtonItem = m_addBtnItem;
	}
}

- (void)_OnTouchDeleteItemBtn:(id)sender
{
	MCClosetColumnCell* cell = (MCClosetColumnCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
	[cell DeleteItems];
}

#pragma mark UITableViewDelegate methods
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
	//set items slider view to edit mode
	return UITableViewCellEditingStyleNone;
}

#pragma mark UITableViewDataSource methods
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSLog(@"delete");
}

#pragma mark MCItemDetailViewControllerDelegate methods
- (void)OnSave
{
	NSArray* indexPaths = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]];
	[self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:YES];
	
}

@end
