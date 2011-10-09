//
//  MCImageSliderView.h
//  MyCloset
//
//  Created by mmcl on 11-9-25.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MCImageSliderViewCell :UIButton{
	BOOL m_editing;
	BOOL m_checkMark;
	UIImageView* m_checkMarkView;
}

@property (nonatomic) BOOL Editing;
@property (nonatomic) BOOL CheckMark;
@end

@protocol MCImageSliderViewDelegate;

@interface MCImageSliderViewResource: NSObject{
	UIImage* m_image;
	BOOL m_checked;
}
@property (nonatomic, retain) UIImage* Image;
@property (nonatomic) BOOL Checked;
	
@end

@interface MCImageSliderView : UIView<UIScrollViewDelegate> {
	UIScrollView* m_sliderView;
	
	NSMutableArray* m_imageCells;
	id<MCImageSliderViewDelegate> m_delegate;
	BOOL m_editing;
	
	NSMutableArray*   m_curDeletingCells;
	NSMutableArray*   m_resources;
	
	CGFloat m_cellWidth;
	CGFloat m_cellHeight;
	
	NSInteger m_lastVisibleCellIndex;
}

@property(nonatomic, assign) id<MCImageSliderViewDelegate> Delegate;
@property(nonatomic) BOOL Editing;

- (void)CommonInit;

- (void)AddImage:(UIImage*)image;

- (NSIndexSet*)DeleteCheckedImages;

- (NSIndexSet*)SelectedCheckedImages;

- (void)ClearImages;

- (void)ClearCheckMarks;

- (MCImageSliderViewCell*)CellAtIndex:(NSUInteger)index;

- (UIImage*)ImageAtIndex:(NSUInteger)index;

- (MCImageSliderViewCell*)_CreateImageButton:(CGRect)frame;
@end

@protocol MCImageSliderViewDelegate <NSObject>
@optional
- (void)ImageSliderView:(MCImageSliderView*)imageSlider DidSelectedAtIndex:(NSUInteger)index;

@end

