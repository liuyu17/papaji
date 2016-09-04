//
//  RecordItem.m
//  HUALE
//
//  Created by WEI WEI FAN on 16/8/10.
//  Copyright © 2016年 WEI WEI FAN. All rights reserved.
//

#import "RecordItem.h"

@implementation RecordItem

// Insert code here to add functionality to your managed object subclass
- (void) awakeFromInsert
{
    [super awakeFromInsert];
    
    self.recordDate = [NSDate date];

    self.itemKey = [[[NSUUID alloc] init] UUIDString];
}

@end
