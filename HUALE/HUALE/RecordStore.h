//
//  RecordStore.h
//  HUALE
//
//  Created by WEI WEI FAN on 16/8/6.
//  Copyright © 2016年 WEI WEI FAN. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreData;
@class RecordItem;

@interface RecordStore : NSObject

@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, readonly) NSArray *allRecords;

@property (nonatomic, strong) NSArray *sectionsInDate;
@property (nonatomic, strong) NSMutableDictionary *recordsInDate;

+ (instancetype)sharedStore;
//- (RecordItem *)createItem;

- (RecordItem *) addRecord;

- (void)removeItem:(RecordItem *)item;

- (BOOL)saveChanges;

- (NSString *)itemArchivePath;


@end
