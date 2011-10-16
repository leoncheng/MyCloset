//
//  MCOutfitImageViewController.h
//  MyCloset
//
//  Created by mmcl on 11-10-16.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MCOutfit;

@interface MCOutfitImageViewController : MCViewController<UIActionSheetDelegate> {
	IBOutlet UIImageView* m_outfitView;
	MCOutfit* m_outfit;
}

@end
