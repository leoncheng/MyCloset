//
//  MCModelHelper.h
//  MyCloset
//
//  Created by mmcl on 11-9-24.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MCModelHelper : NSObject {

}

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (NSString *)applicationDocumentsDirectory;

- (id)CreateModelBy:(NSString*)name;

- (void)Save:(NSManagedObject*)model;

- (NSArray*)Load:(NSString*)modelName;

MC_DECLARE_AS_SINGLETON(MCModelHelper)
@end
