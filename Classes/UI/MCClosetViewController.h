//
//  MCClosetViewController.h
//  MyCloset
//
//  Created by mmcl on 11-9-25.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCItemDetailViewController.h"

@protocol MCClosetColumnCellDelegate;


@interface MCClosetColumnCell : MCTableViewCell<MCImageSliderViewDelegate>
{
	MCImageSliderView* m_itemsSliderView;
	NSUInteger m_row;
	id<MCClosetColumnCellDelegate> m_delegate;
}

@property(nonatomic, assign) id<MCClosetColumnCellDelegate> Delegate;

- (NSArray*)GetSelectedItems;
- (void)DeleteItems;
@end

@protocol MCClosetColumnCellDelegate<NSObject>

@optional
- (void)OnSelectItem:(MCItem*)item;

@end



@interface MCClosetViewController : MCTableViewController<
MCItemDetailViewControllerDelegate,MCClosetColumnCellDelegate> {
	UIBarButtonItem* m_editBtnItem;
	UIBarButtonItem* m_editToolBarItem;
	UIBarButtonItem* m_fittingBtnItem;
	UIBarButtonItem* m_fittingCancelBtnItem;
}

- (NSArray*)_GetSelectedItems;
@end
