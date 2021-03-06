    //
//  MCTableViewController.m
//  MyCloset
//
//  Created by mmcl on 11-9-25.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MCTableViewController.h"
#import <objc/runtime.h>

@implementation MCTableViewResource
@synthesize CellName = m_cellName;
@synthesize Data = m_data;

- (void)dealloc
{
	MCSAFERELEASE(m_cellName)
	MCSAFERELEASE(m_data)
	[super dealloc];
}

@end

@implementation MCTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self != nil) {
		[self CommonInit];
	}
	return self;
}

- (void)CommonInit
{
	//do nothing
}

- (void)OnResourceChanged:(MCTableViewResource*)resource atRow:(NSUInteger)row
{
	//do nothing;
}
@end

@implementation MCTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
	self = [super initWithStyle:style];
	if (self != nil) {
		[self CommonInit];
	}
	return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self != nil) {
		[self CommonInit];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self != nil) {
		[self CommonInit];
	}
	return self;
}

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
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
	[self ReleaseViews];
}

- (void)dealloc {
	[self ReleaseViews];
	MCSAFERELEASE(m_resourceList)
	MCSAFERELEASE(m_paramsDict)
    [super dealloc];
}

#pragma mark Customized public methods
- (void)CommonInit
{
	m_resourceList = [[NSMutableArray alloc] init];
	m_paramsDict = [[NSMutableDictionary alloc] init];
}

- (void)AddResource:(MCTableViewResource*)resource
{
	[m_resourceList addObject:resource];
}

- (void)ClearResources
{
	[m_resourceList removeAllObjects];
}

- (void)ReleaseViews
{
	//do nothing
}

- (void)SetParam:(id)param withKey:(id)key
{
	[m_paramsDict setObject:param forKey:key];
}

- (id)GetParamForKey:(id)key
{
	return [m_paramsDict objectForKey:key];
}

#pragma mark Customized private methods
- (MCTableViewCell*)_CreateCellByName:(NSString*)cellName
{
	MCTableViewCell* cell = nil;
	Class cl = (Class)objc_lookUpClass([cellName UTF8String]);
	if (cl != nil)
	{
		cell = class_createInstance(cl, 0);
		[[cell initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName] autorelease];
	}
	return cell;
}

- (UITableViewCell*)_GetCell:(UITableView*)tableView withRow:(NSUInteger)row
{
	MCTableViewResource* resource = [m_resourceList objectAtIndex:row];
	
	NSString* cellName = resource.CellName;
	
	MCTableViewCell *cell = (MCTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellName];
	if (cell == nil)
	{
		cell = [self _CreateCellByName:cellName];
	}
	
	if (cell != nil)
	{
		[cell OnResourceChanged:resource atRow:row];
	}
	return cell;
}

#pragma mark UITableViewDataSource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [m_resourceList count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSUInteger row = [indexPath row];
	return [self _GetCell:tableView withRow:row];
}


#pragma mark UITableViewDelegate methods


@end
