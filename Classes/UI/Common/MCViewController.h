//
//  MCViewController.h
//  MyCloset
//
//  Created by mmcl on 11-9-29.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MCViewController : UIViewController {
	NSMutableDictionary* m_paramsDict;
}

- (void)SetParam:(id)param withKey:(id)key;

- (id)GetParamForKey:(id)Key;

- (void)CommonInit;

- (void)ReleaseViews;
@end
