//
//  MyClosetAppDelegate.h
//  MyCloset
//
//  Created by mmcl on 11-9-24.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyClosetAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	IBOutlet UITabBarController *m_tabBarController;
}

@property (nonatomic, readonly) UITabBarController* TabBarController;
@property (nonatomic, retain) IBOutlet UIWindow *window;

@end

