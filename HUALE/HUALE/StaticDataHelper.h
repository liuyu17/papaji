//
//  CurrencyHelper.h
//  HUALE
//
//  Created by WEI WEI FAN on 16/8/7.
//  Copyright © 2016年 WEI WEI FAN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StaticDataHelper : NSObject

+ (NSString *) getCurrencyName: (int) currencyIndex;
+ (NSString *)getRecordType:(int)typeIndex;

@end
