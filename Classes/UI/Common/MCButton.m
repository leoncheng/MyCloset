//
//  MCButton.m
//  MyCloset
//
//  Created by mmcl on 11-10-9.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MCButton.h"


@implementation MCButton

@synthesize ErrorMargin = m_errorMargin;

-(BOOL) pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
	CGRect hitRect = CGRectMake(0 - m_errorMargin, 0 - m_errorMargin, self.bounds.size.width + 2 * m_errorMargin, self.bounds.size.height + 2 * m_errorMargin);
	
	BOOL result = CGRectContainsPoint(hitRect, point);
	return result;
}


@end
