//
//  MCClosetViewController.h
//  MyCloset
//
//  Created by mmcl on 11-9-25.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCItemDetailViewController.h"

@interface MCClosetColumnCell : MCTableViewCell
{
	MCImageSliderView* m_itemsSliderView;
}

@end


@interface MCClosetViewController : MCTableViewController<MCItemDetailViewControllerDelegate> {

}

@end
