//
//  WYCoreDataManager.h
//  Meari
//
//  Created by 李兵 on 16/3/26.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import <Foundation/Foundation.h>


#define WY_CoreDataM [WYCoreDataManager sharedCoreDataManager]
@class NSManagedObject;

@interface WYCoreDataManager : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext       *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel         *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

WY_Singleton_Interface(CoreDataManager)


/**
 *  插入
 */
- (void)insertEntityModel:(NSString *)entityName dealBlock:(void(^)(id entityModel))dealBlock;


/**
 *  删除
 */
- (void)deleteData:(NSManagedObject *)object;

- (void)deleteDataWithEntityName:(NSString *)entityName;

- (void)deleteDataWithEntityName:(NSString *)entityName
                       predicate:(NSPredicate *)predicate;

- (void)deleteDataWithEntityName:(NSString *)entityName
                       predicate:(NSPredicate *)predicate
                 sortDescriptors:(NSArray *)sortDescriptors;

- (void)deleteDataWithEntityName:(NSString *)entityName
                       predicate:(NSPredicate *)predicate
                  sortDescriptor:(NSArray *)sortDescriptors
                      fetchLimit:(NSUInteger)fetchLimit;


/**
 *  查询
 */
- (NSArray *)queryDataWithEntityName:(NSString *)entityName;

- (NSArray *)queryDataWithEntityName:(NSString *)entityName
                           predicate:(NSPredicate *)predicate;

- (NSArray *)queryDataWithEntityName:(NSString *)entityName
                           predicate:(NSPredicate *)predicate
                     sortDescriptors:(NSArray *)sortDescriptors;

- (NSArray *)queryDataWithEntityName:(NSString *)entityName
                           predicate:(NSPredicate *)predicate
                      sortDescriptor:(NSArray *)sortDescriptors
                          fetchLimit:(NSUInteger)fetchLimit;
- (NSArray *)queryDataWithEntityName:(NSString *)entityName
                           predicate:(NSPredicate *)predicate
                      sortDescriptor:(NSArray *)sortDescriptors
                          fetchLimit:(NSUInteger)fetchLimit
                         fetchOffset:(NSInteger)fetchOffset;

/**
 *  保存
 */
- (void)saveContext;


@end


