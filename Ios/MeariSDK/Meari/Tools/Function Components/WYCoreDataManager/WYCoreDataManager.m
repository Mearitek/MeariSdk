//
//  WYCoreDataManager.m
//  Meari
//
//  Created by 李兵 on 16/3/26.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import "WYCoreDataManager.h"


@implementation WYCoreDataManager


#pragma mark 接口
WY_Singleton_Implementation(CoreDataManager)

/**
 *  插入
 */
- (void)insertEntityModel:(NSString *)entityName dealBlock:(void(^)(id entityModel))dealBlock {
    id model = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:self.managedObjectContext];
    if (dealBlock) {
        dealBlock(model);
    }
    [self saveContext];
}

/**
 *  删除
 */
- (void)deleteData:(NSManagedObject *)object {
    [self.managedObjectContext deleteObject:object];
    [self saveContext];
}

- (void)deleteDataWithEntityName:(NSString *)entityName {
    [self deleteDataWithEntityName:entityName
                         predicate:nil
                    sortDescriptor:nil
                        fetchLimit:0];
}

- (void)deleteDataWithEntityName:(NSString *)entityName
                           predicate:(NSPredicate *)predicate {
    [self deleteDataWithEntityName:entityName
                         predicate:predicate
                    sortDescriptor:nil
                        fetchLimit:0];
}

- (void)deleteDataWithEntityName:(NSString *)entityName
                           predicate:(NSPredicate *)predicate
                     sortDescriptors:(NSArray *)sortDescriptors {
    [self deleteDataWithEntityName:entityName
                         predicate:predicate
                    sortDescriptor:sortDescriptors
                        fetchLimit:0];
}

- (void)deleteDataWithEntityName:(NSString *)entityName
                           predicate:(NSPredicate *)predicate
                      sortDescriptor:(NSArray *)sortDescriptors
                           fetchLimit:(NSUInteger)fetchLimit{
    NSArray *arr = [self queryDataWithEntityName:entityName
                                       predicate:predicate
                                  sortDescriptor:sortDescriptors
                                      fetchLimit:fetchLimit];
    for (NSManagedObject *obj in arr) {
        [self.managedObjectContext deleteObject:obj];
    }
    [self saveContext];
    
}


/**
 *  查询
 */
- (NSArray *)queryDataWithEntityName:(NSString *)entityName {
    NSArray *results = [self queryDataWithEntityName:entityName
                                           predicate:nil
                                      sortDescriptor:nil
                                          fetchLimit:0];
    return results;
}

- (NSArray *)queryDataWithEntityName:(NSString *)entityName
                           predicate:(NSPredicate *)predicate {
    NSArray *results = [self queryDataWithEntityName:entityName
                                           predicate:predicate
                                      sortDescriptor:nil
                                          fetchLimit:0];
    return results;
}

- (NSArray *)queryDataWithEntityName:(NSString *)entityName
                           predicate:(NSPredicate *)predicate
                      sortDescriptors:(NSArray *)sortDescriptors {
    NSArray *results = [self queryDataWithEntityName:entityName
                                           predicate:predicate
                                      sortDescriptor:sortDescriptors
                                          fetchLimit:0];
    return results;
}

- (NSArray *)queryDataWithEntityName:(NSString *)entityName
                           predicate:(NSPredicate *)predicate
                      sortDescriptor:(NSArray *)sortDescriptors
                          fetchLimit:(NSUInteger)fetchLimit {
    NSFetchRequest *fetchR = [self fetchRequestWithEntityName:entityName
                                                    predicate:predicate
                                            sortDescriptors:sortDescriptors
                                                   fetchLimit:fetchLimit
                                                  fetchOffset:-1];
    NSError *error;
    NSArray *results = [self.managedObjectContext executeFetchRequest:fetchR error:nil];
    if (error) {
        NSLog(@"%s [line %d] 查询数据库失败:%@", __FUNCTION__, __LINE__, error);
    }
    return results;
}
- (NSArray *)queryDataWithEntityName:(NSString *)entityName
                           predicate:(NSPredicate *)predicate
                      sortDescriptor:(NSArray *)sortDescriptors
                          fetchLimit:(NSUInteger)fetchLimit
                         fetchOffset:(NSInteger)fetchOffset {
    NSFetchRequest *fetchR = [self fetchRequestWithEntityName:entityName
                                                    predicate:predicate
                                              sortDescriptors:sortDescriptors
                                                   fetchLimit:fetchLimit
                                                  fetchOffset:fetchOffset];
    NSError *error;
    NSArray *results = [self.managedObjectContext executeFetchRequest:fetchR error:nil];
    if (error) {
        NSLog(@"%s [line %d] 查询数据库失败:%@", __FUNCTION__, __LINE__, error);
    }
    return results;
}
/**
 *  创建请求
 */
- (NSFetchRequest *)fetchRequestWithEntityName:(NSString *)entityName
                                     predicate:(NSPredicate *)predicate
                               sortDescriptors:(NSArray *)sortDescriptors
                                    fetchLimit:(NSUInteger)fetchLimit
                                   fetchOffset:(NSInteger)fetchOffset {
    if (!entityName) {
        return nil;
    }
    NSFetchRequest *fetchR = [NSFetchRequest fetchRequestWithEntityName:entityName];
    if (predicate) {
        fetchR.predicate = predicate;
    }
    if (sortDescriptors) {
        fetchR.sortDescriptors = sortDescriptors;
    }
    if (fetchLimit > 0) {
        fetchR.fetchLimit = fetchLimit;
    }
    if (fetchOffset > 0) {
        fetchR.fetchOffset = fetchOffset * fetchLimit;
    }
    [fetchR setReturnsObjectsAsFaults:NO];
    return fetchR;
}


#pragma mark - Core Data stack
@synthesize managedObjectContext       = _managedObjectContext;
@synthesize managedObjectModel         = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    return [[WY_FileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}
- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    return _managedObjectModel;
}
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }

    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"coreData.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    NSDictionary *options = @{NSMigratePersistentStoresAutomaticallyOption:@(YES),
                              NSInferMappingModelAutomaticallyOption:@(YES),
                              };
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}
- (NSManagedObjectContext *)managedObjectContext {
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support
- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end



