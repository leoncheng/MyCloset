//
//  MCItem.h
//  MyCloset
//
//  Created by mmcl on 11-9-25.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class MCItemType;

@interface MCItem :  NSManagedObject  
{
}

@property (nonatomic, retain) NSNumber * Price;
@property (nonatomic, retain) MCItemType * Type;

@end



