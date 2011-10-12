//
//  MCMath.m
//  MyCloset
//
//  Created by mmcl on 11-10-10.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MCMath.h"


@implementation MCMath

+ (CGFloat)DistanceBetweenPoint:(CGPoint)point1 andPoint:(CGPoint)point2
{
	CGFloat deltaX = point1.x - point2.x;
	CGFloat deltaY = point1.y - point2.y;
	CGFloat distance = sqrt(deltaX * deltaX + deltaY * deltaY);
	return distance;
}

@end
