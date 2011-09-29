//
//  MCAddItemViewController.h
//  MyCloset
//
//  Created by mmcl on 11-9-27.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MCItemDetailViewControllerDelegate;

@interface MCItemDetailViewController : MCViewController
<UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
	IBOutlet UIButton* m_photoBtn;
	MCItem *m_item;
	id<MCItemDetailViewControllerDelegate> m_delegate;
}

@property(nonatomic, assign) id<MCItemDetailViewControllerDelegate> Delegate;

- (IBAction)OnTouchPhotoBtn;
@end

@protocol MCItemDetailViewControllerDelegate <NSObject>
@optional
- (void)OnSave;

@end