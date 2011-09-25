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
	IBOutlet UINavigationController *m_naviController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end

