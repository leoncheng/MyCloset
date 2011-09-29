//
//  MCViewController.m
//  MyCloset
//
//  Created by mmcl on 11-9-29.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MCViewController.h"

@implementation MCViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self != nil) {
		[self CommonInit];
	}
	return self;
}

- (void)viewDidUnload
{
	[super viewDidUnload];
	[self ReleaseViews];
}

- (void)dealloc
{
	[self ReleaseViews];
	[super dealloc];
}

- (void)CommonInit
{
	//do nothing
}

- (void)ReleaseViews
{
	//do nothing
}

@end
