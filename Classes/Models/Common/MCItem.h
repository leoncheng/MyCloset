//
//  MCItem.h
//  MyCloset
//
//  Created by mmcl on 11-9-28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class MCItemType;

@interface MCItem :  NSManagedObject  
{
}

@property (nonatomic, retain) id ThumbnailImage;
@property (nonatomic, retain) NSNumber * Price;
@property (nonatomic, retain) NSManagedObject * Image;
@property (nonatomic, retain) MCItemType * Type;

@end



