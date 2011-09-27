//
//  MCImageSliderView.h
//  MyCloset
//
//  Created by mmcl on 11-9-25.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MCImageSliderView : UIScrollView<UIScrollViewDelegate> {
	NSMutableArray* m_images;
}

- (void)CommonInit;

- (void)AddImage:(UIImage*)image;

- (UIButton*)_CreateImageButton:(CGRect)frame;
@end
