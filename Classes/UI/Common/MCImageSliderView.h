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

@interface MCImageSliderView : UIView<UIScrollViewDelegate> {
	UIScrollView* m_sliderView;
	
	NSMutableArray* m_imageCells;
	id<MCImageSliderViewDelegate> m_delegate;
	BOOL m_editing;
	
	NSMutableArray*   m_curDeletingCells;
}

@property(nonatomic, assign) id<MCImageSliderViewDelegate> Delegate;
@property(nonatomic) BOOL Editing;

- (void)CommonInit;

- (void)AddImage:(UIImage*)image;

- (NSIndexSet*)DeleteCheckedImages;

- (void)ClearImages;

- (void)ClearCheckMarks;

- (MCImageSliderViewCell*)CellAtIndex:(NSUInteger)index;

- (MCImageSliderViewCell*)_CreateImageButton:(CGRect)frame withImage:(UIImage*)image;
@end

@protocol MCImageSliderViewDelegate <NSObject>
@optional
- (void)ImageSliderView:(MCImageSliderView*)imageSlider DidSelectedAtIndex:(NSUInteger)index;

@end

