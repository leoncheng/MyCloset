//
//  MCTableViewController.h
//  MyCloset
//
//  Created by mmcl on 11-9-25.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MCTableViewResource : NSObject
{
	NSString* m_cellName;
	NSObject* m_data;
}
@property(nonatomic, retain) NSString* CellName;
@property(nonatomic, retain) NSObject* Data;
@end


@interface MCTableViewCell : UITableViewCell
{
	
}

- (void)CommonInit;

- (void)OnResourceChanged:(MCTableViewResource*)resource atRow:(NSUInteger)row;

@end


@interface MCTableViewController : UITableViewController 
{
	NSMutableArray* m_resourceList;
}

- (void)CommonInit;

- (void)AddResource:(MCTableViewResource*)resource;

- (void)ReleaseViews;
@end
