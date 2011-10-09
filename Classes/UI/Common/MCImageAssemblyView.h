//
//  MCImageAssemblyView.h
//  MyCloset
//
//  Created by mmcl on 11-10-7.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MCButton;
@protocol MCImageAssemblyViewCellDelegate;

@interface MCImageAssemblyViewCell : UIButton
{
	CGPoint m_startLocation;
	MCButton* m_closeButton;
	UIButton* m_scaleButton;
	id<MCImageAssemblyViewCellDelegate> m_delegate;
}

@property(nonatomic, assign) id<MCImageAssemblyViewCellDelegate> Delegate;
@end

@protocol MCImageAssemblyViewCellDelegate <NSObject>

@optional
- (void)OnClose:(MCImageAssemblyViewCell*)cell;

@end


@interface MCImageAssemblyView : UIControl<MCImageAssemblyViewCellDelegate> {
	NSMutableArray* m_imageCells;
}

- (void)CommonInit;
- (void)AddImage:(UIImage*)image;
@end
