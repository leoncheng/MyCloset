//
//  MCItem.h
//  MyCloset
//
//  Created by mmcl on 11-9-24.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface MCItem :  NSManagedObject  
{
}

@property (nonatomic, retain) NSNumber * Price;
@property (nonatomic, retain) NSManagedObject * Type;

@end



