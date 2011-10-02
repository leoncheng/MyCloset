//
//  MCClosetViewController.h
//  MyCloset
//
//  Created by mmcl on 11-9-25.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCItemDetailViewController.h"

@interface MCClosetColumnCell : MCTableViewCell<MCImageSliderViewDelegate>
{
	MCImageSliderView* m_itemsSliderView;
}

- (void)DeleteItems;
@end


@interface MCClosetViewController : MCTableViewController<MCItemDetailViewControllerDelegate> {
	UIBarButtonItem* m_deleteBtnItem;
	UIBarButtonItem* m_editBtnItem;
	UIBarButtonItem* m_addBtnItem;
}

@end
