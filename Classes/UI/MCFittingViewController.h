//
//  MCFittingViewController.h
//  MyCloset
//
//  Created by mmcl on 11-10-6.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MCFittingViewController : MCViewController<MCImageSliderViewDelegate> {
	MCImageSliderView* m_itemSlider;
	MCImageAssemblyView* m_assemblyView;
}

@end
