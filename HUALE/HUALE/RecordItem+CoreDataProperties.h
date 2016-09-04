//
//  RecordItem+CoreDataProperties.h
//  HUALE
//
//  Created by WEI WEI FAN on 16/8/10.
//  Copyright © 2016年 WEI WEI FAN. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "RecordItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface RecordItem (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *itemKey;
@property (nullable, nonatomic, retain) NSDate *recordDate;
@property (nullable, nonatomic, retain) NSDecimalNumber *amount;
@property (nullable, nonatomic, retain) NSString *remark;
@property (nonatomic) int currency;
@property (nonatomic) int recordType;

@end

NS_ASSUME_NONNULL_END
