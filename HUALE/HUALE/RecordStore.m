//
//  RecordStore.m
//  HUALE
//
//  Created by WEI WEI FAN on 16/8/6.
//  Copyright © 2016年 WEI WEI FAN. All rights reserved.
//

#import "RecordStore.h"
#import "RecordItem.h"

@interface RecordStore ()

@property (nonatomic) NSMutableArray *privateRecords;
@property (nonatomic, strong) NSManagedObjectModel *model;

@end

static NSSortDescriptor *dateSortDescriptor = nil;
static NSDateFormatter * dateFormatter = nil;
@implementation RecordStore

+ (instancetype)sharedStore
{
    static RecordStore *sharedStore = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedStore = [[self alloc] initPrivate];
    });
    
    return sharedStore;
}

- (instancetype)init
{
    @throw [NSException exceptionWithName:@"Singleton"
                                   reason:@"Use + [RecordStore shareStore]"
                                 userInfo:nil];
    return nil;
}

- (instancetype)initPrivate
{
    self = [super init];
    if (self) {
//        _privateRecords = [[NSMutableArray alloc] init];
        
        
        _model = [NSManagedObjectModel mergedModelFromBundles:nil];
        
        NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_model];
        
        NSString *path = [self itemArchivePath];
        NSURL *storeURL = [NSURL fileURLWithPath:path];
        
        NSError *error = nil;
        
        if (![psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
            @throw [NSException exceptionWithName:@"OpenFailure" reason:[error localizedDescription] userInfo:nil];
        }
        
        _context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        _context.persistentStoreCoordinator = psc;
        
        [self loadAllItems];
        [self groupRecordsInDays];
    }
    return self;
}

- (NSArray *)allRecords
{
    return self.privateRecords;
}

- (void)loadAllItems
{
    if (!self.privateRecords) {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        
        NSEntityDescription *e = [NSEntityDescription entityForName:@"RecordItem" inManagedObjectContext:self.context];
        
        request.entity = e;
        
//        NSSortDescriptor *sd = [NSSortDescriptor sortDescriptorWithKey:@"recordDate" ascending:NO];
//        
//        request.sortDescriptors = @[sd];
        
        NSError *err;
        NSArray *result = [self.context executeFetchRequest:request error:&err];
        
        if (!result) {
            [NSException raise:@"Fetch failed" format:@"Reason: %@", [err localizedDescription]];
        }
        self.privateRecords = [[NSMutableArray alloc] initWithArray:result];
    }
}

- (RecordItem *) addRecord
{
    RecordItem *newItem = [NSEntityDescription insertNewObjectForEntityForName:@"RecordItem"
                                                  inManagedObjectContext:self.context];
    
//    [newItem setAmount:recordItem.amount];
//    [newItem setRemark:recordItem.remark];
//    [newItem setRecordType:recordItem.recordType];
//    [newItem setCurrency:recordItem.currency];    
    
    [self.privateRecords addObject:newItem];
//

//    if(!dateSortDescriptor) {
//        dateSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"recordDate" ascending:NO];
//
//    }
//    
//    [self.privateRecords sortUsingDescriptors:@[dateSortDescriptor]];
    [self groupRecordsInDays];
    return newItem;
}

- (void)removeItem:(RecordItem *)item
{
    [self.context deleteObject:item];
    [self.privateRecords removeObjectIdenticalTo:item];
    [self groupRecordsInDays];
}

- (NSString *)itemArchivePath
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentDirectory = [documentDirectories firstObject];
    
    return [documentDirectory stringByAppendingPathComponent:@"store.data"];
}

- (BOOL)saveChanges
{
    NSError *error;
    BOOL successful = [self.context save:&error];
    if (!successful) {
        NSLog(@"Error saving: %@", [error localizedDescription]);
    }
    return successful;
}

- (void) groupRecordsInDays
{
    if (dateFormatter == nil) {
        NSCalendar * calendar = [NSCalendar currentCalendar];
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.locale = [NSLocale currentLocale];
        dateFormatter.timeZone = calendar.timeZone;
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    }
    
//    NSUInteger dateComponents = NSCalendarUnitYear | NSCalendarUnitMonth;
//    NSInteger previousYear = -1;
//    NSInteger previousMonth = -1;
//    NSMutableArray *tableViewCellsForSection = nil;
    _recordsInDate = [NSMutableDictionary dictionary];
    for(RecordItem *item in _privateRecords) {
        NSString *dateString = [dateFormatter stringFromDate:item.recordDate];
        
        NSMutableArray *recordsOnThisDay = [self.recordsInDate objectForKey:dateString];
        if (recordsOnThisDay == nil) {
            recordsOnThisDay = [NSMutableArray array];
            [_recordsInDate setObject:recordsOnThisDay forKey:dateString];
        }
        [recordsOnThisDay addObject:item];
        if(!dateSortDescriptor) {
            dateSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"recordDate" ascending:NO];
        }
        [recordsOnThisDay sortUsingDescriptors:@[dateSortDescriptor]];
    }

    NSArray *unsortedDays = [self.recordsInDate allKeys];
    _sectionsInDate = [unsortedDays sortedArrayUsingComparator:^NSComparisonResult(NSString *str1, NSString *str2) {
        return [str2 compare:str1];
    }];
    
}



@end
