//
//  User+CoreDataProperties.h
//  Meari
//
//  Created by 李兵 on 16/3/14.
//  Copyright © 2016年 PPStrong. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface User (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *userAccount;
@property (nullable, nonatomic, retain) NSString *nickName;
@property (nullable, nonatomic, retain) NSString *userID;
@property (nullable, nonatomic, retain) NSString *userToken;
@property (nullable, nonatomic, retain) NSString *jpushAlias;
@property (nullable, nonatomic, retain) NSString *t;
@end

NS_ASSUME_NONNULL_END
