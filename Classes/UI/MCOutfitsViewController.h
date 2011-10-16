//
//  MCOutfitsViewController.h
//  MyCloset
//
//  Created by mmcl on 11-10-15.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MCOutfitsViewCell : MCTableViewCell
{
	MCImageSliderView* m_outfitsRowView;
}

@end


@interface MCOutfitsViewController : MCTableViewController {

}

- (void)_FillOutfitResouce;

@end
