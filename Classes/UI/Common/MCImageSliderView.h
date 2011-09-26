//
//  MCImageSliderView.h
//  MyCloset
//
//  Created by mmcl on 11-9-25.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MCImageSliderView : UIScrollView<UIScrollViewDelegate> {

}

- (void)CommonInit;

- (UIButton*)_CreateImageButton:(CGRect)frame;
@end
