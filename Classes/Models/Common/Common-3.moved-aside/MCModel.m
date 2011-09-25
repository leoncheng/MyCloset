// 
//  MCModel.m
//  MyCloset
//
//  Created by mmcl on 11-9-24.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MCModel.h"


@implementation MCModel 

- (void)Save
{
	NSError *error = nil;
	if (![self.managedObjectContext save:&error]) {
		/*
		 Replace this implementation with code to handle the error appropriately.
		 
		 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
		 */
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	}
}
@end
