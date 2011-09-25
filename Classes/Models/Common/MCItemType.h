//
//  MCItemType.h
//  MyCloset
//
//  Created by mmcl on 11-9-25.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class MCItem;

@interface MCItemType :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * Name;
@property (nonatomic, retain) NSSet* Items;

@end


@interface MCItemType (CoreDataGeneratedAccessors)
- (void)addItemsObject:(MCItem *)value;
- (void)removeItemsObject:(MCItem *)value;
- (void)addItems:(NSSet *)value;
- (void)removeItems:(NSSet *)value;

@end

