    //
//  MCClosetViewController.m
//  MyCloset
//
//  Created by mmcl on 11-9-25.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MCClosetViewController.h"
#import "MCItemDetailViewController.h"
#import "MCFittingViewController.h"

#define MC_CLOSET_ROW_HEIGHT 92

@implementation MCClosetColumnCell
@synthesize Delegate = m_delegate;

- (void)CommonInit
{
	CGRect sliderframe = self.bounds;
	sliderframe.size.height = MC_CLOSET_ROW_HEIGHT;	//the height of the cell is still 44 at the moment, so we need to assign 91 manually
	
	m_itemsSliderView = [[MCImageSliderView alloc] initWithFrame:sliderframe];
	[self addSubview:m_itemsSliderView];
	m_itemsSliderView.Delegate = self;
}

- (void)OnResourceChanged:(MCTableViewResource *)resource atRow:(NSUInteger)row
{
	[m_itemsSliderView ClearImages];
	NSArray* typeList = [[MCModelHelper SharedInstance] Load:@"MCItemType"];
	
	MCItemType* curType = [typeList objectAtIndex:row];
	m_row = row;
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
	NSArray* typeList = [[MCModelHelper SharedInstance] Load:@"MCItemType"];
	MCItemType* curType = [typeList objectAtIndex:m_row];
	NSArray* itemList = curType.Items.allObjects;
	NSIndexSet* deletedItemIndexes = [m_itemsSliderView DeleteCheckedImages];
	NSArray* deletedItems = [itemList objectsAtIndexes:deletedItemIndexes];
	[[MCModelHelper SharedInstance] Delete:deletedItems];
	
}

- (NSArray*)GetSelectedItems
{
	NSArray* typeList = [[MCModelHelper SharedInstance] Load:@"MCItemType"];
	MCItemType* curType = [typeList objectAtIndex:m_row];
	NSArray* itemList = curType.Items.allObjects;	
	NSIndexSet* selectedItemIndexes = [m_itemsSliderView SelectedCheckedImages];
	NSArray* selectedItems = [itemList objectsAtIndexes:selectedItemIndexes];
	return selectedItems;
}

#pragma mark MCImageSliderViewDelegate methods
- (void)ImageSliderView:(MCImageSliderView*)imageSlider DidSelectedAtIndex:(NSUInteger)index
{
	NSArray* typeList = [[MCModelHelper SharedInstance] Load:@"MCItemType"];
	MCItemType* curType = [typeList objectAtIndex:m_row];
	NSArray* itemList = curType.Items.allObjects;	
	
	MCItem* selectedItem = [itemList objectAtIndex:index];
	if (m_delegate && [m_delegate respondsToSelector:@selector(OnSelectItem:)]) {
		[m_delegate OnSelectItem:selectedItem];
	}
	
}

@end


@implementation MCClosetViewController

- (void)CommonInit
{
	[super CommonInit];
}

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
	
	
	self.title = @"衣橱";
	
	//customize row height
	UITableView* curView = self.tableView;
	curView.rowHeight = MC_CLOSET_ROW_HEIGHT; //we only need 4 rows, each one's height is 92
	
	curView.scrollEnabled = NO;
	
	for (int i = 0; i < [typeList count]; i++) {
		MCTableViewResource* resource = [[MCTableViewResource alloc] init];
		resource.CellName = @"MCClosetColumnCell";
		[self AddResource:resource];
		[resource release];
	}
	
	//add editItem button on navigation bar
	m_editBtnItem = [[UIBarButtonItem alloc] 
									initWithTitle:@"编辑" 
									style:UIBarButtonItemStyleBordered 
									target:self 
									action:@selector(_OnTouchEditItemBtn:)];
	self.navigationItem.leftBarButtonItem = m_editBtnItem;
	
	UIBarButtonItem* deleteBtnItem = [[UIBarButtonItem alloc] initWithTitle:@"删除" 
													   style:UIBarButtonItemStyleBordered 
														target:self 
													  action:@selector(_OnTouchDeleteItemBtn:)];
	
	UIBarButtonItem* addBtnItem = [[UIBarButtonItem alloc] initWithTitle:@"添加"
																   style:UIBarButtonItemStyleBordered
																  target:self 
																  action:@selector(OnTouchAddItemBtn)];
	
	UIToolbar* editToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 103.0f, 44.01f)];
	NSArray* buttons = [NSArray arrayWithObjects:deleteBtnItem, addBtnItem, nil];
	[editToolbar setItems:buttons animated:NO];
    m_editToolBarItem = [[UIBarButtonItem alloc] initWithCustomView:editToolbar];
	
	//add fitting button on navigation bar
	m_fittingBtnItem = [[UIBarButtonItem alloc] 
					 initWithTitle:@"试衣" 
					 style:UIBarButtonItemStyleBordered 
					 target:self 
					 action:@selector(_OnTouchFittingItemBtn:)];
	self.navigationItem.rightBarButtonItem = m_fittingBtnItem;
	
	m_fittingCancelBtnItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" 
															  style:UIBarButtonItemStyleBordered 
															 target:self 
															 action:@selector(_OnTouchFittingCancelItemBtn:)];
	
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
	MCSAFERELEASE(m_editBtnItem)
	MCSAFERELEASE(m_editToolBarItem)
	MCSAFERELEASE(m_fittingBtnItem)
	MCSAFERELEASE(m_fittingCancelBtnItem)
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
		self.navigationItem.rightBarButtonItem = m_editToolBarItem;
		
	}
	else 
	{
		editBtnItem.title = @"编辑";
		editBtnItem.style = UIBarButtonItemStyleBordered;
		
		self.navigationItem.rightBarButtonItem = m_fittingBtnItem;
	}
}

- (void)_OnTouchDeleteItemBtn:(id)sender
{
	NSInteger rowsNumber = [self.tableView numberOfRowsInSection:0];
	for (int i = 0; i < rowsNumber ; i++) {
		MCClosetColumnCell* cell = (MCClosetColumnCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
		[cell DeleteItems];
	}
	
}

- (void)_OnTouchFittingItemBtn:(id)sender
{
	UIBarButtonItem* fittingBtnItem = sender;
	if ([fittingBtnItem.title isEqual:@"试衣"]) {
		fittingBtnItem.title = @"确定";
		self.navigationItem.leftBarButtonItem = m_fittingCancelBtnItem;
		fittingBtnItem.style = UIBarButtonItemStyleDone;
		//set table to edit state
		self.editing = YES;
	}else {
		NSArray* selectedItems = [self _GetSelectedItems];
		
		//go to fitting view
		MCFittingViewController* fittingController = [[MCFittingViewController alloc] initWithNibName:@"MCFittingViewController" bundle:nil];
		[fittingController SetParam:selectedItems withKey:@"selectedItems"];
		//fittingController.modalTransitionStyle = UIViewAnimationTransitionFlipFromLeft;
		//UINavigationController* naviController = [[UINavigationController alloc] initWithRootViewController:fittingController];
		
		[UIView  beginAnimations:nil context:NULL];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationDuration:0.75];
		[self.navigationController pushViewController:fittingController animated:NO];
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
		[UIView commitAnimations];
		
		
		//[self presentModalViewController:naviController animated:YES];
		//[naviController release];
		[fittingController release];
	}

}

- (void)_OnTouchFittingCancelItemBtn:(id)sender
{
	m_fittingBtnItem.title = @"试衣";
	m_fittingBtnItem.style = UIBarButtonItemStyleBordered;
	self.navigationItem.leftBarButtonItem = m_editBtnItem;
	self.editing = NO;
}

- (NSArray*)_GetSelectedItems
{
	NSMutableArray* selectedItems = [[NSMutableArray alloc] init];
	NSUInteger rowsNumber = [self.tableView numberOfRowsInSection:0];
	for (int i = 0; i < rowsNumber ; i++) {
		MCClosetColumnCell* cell = (MCClosetColumnCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
		[selectedItems addObjectsFromArray:[cell GetSelectedItems]] ;
	}
	return selectedItems;
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

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	MCClosetColumnCell* curCell = (MCClosetColumnCell*)[super tableView:tableView cellForRowAtIndexPath:indexPath];
	curCell.Delegate = self;
	return curCell;
}


#pragma mark MCItemDetailViewControllerDelegate methods
- (void)OnSave:(MCItem*)item
{
	// find the type index
	NSArray* types = [[MCModelHelper SharedInstance] Load:@"MCItemType"];
	NSUInteger typeIndex = 0;
	
	for (; typeIndex < [types count]; typeIndex++) {
		MCItemType* type = [types objectAtIndex:typeIndex];
		if ([type.Name isEqualToString:item.Type.Name]) {
			break;
		}
	}
	//update the corresponding row in the table
	NSArray* indexPaths = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:typeIndex inSection:0]];
	[self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:NO];
	
}

#pragma mark MCClosetColumnCellDelegate methods
- (void)OnSelectItem:(MCItem*)item
{
	if (self.editing == NO) {
		NSLog(@"on select item");
	}
	
}

@end
