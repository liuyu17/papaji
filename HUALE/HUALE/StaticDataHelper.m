//
//  CurrencyHelper.m
//  HUALE
//
//  Created by WEI WEI FAN on 16/8/7.
//  Copyright © 2016年 WEI WEI FAN. All rights reserved.
//

#import "StaticDataHelper.h"

@implementation StaticDataHelper

+ (NSString *) getCurrencyName: (int) currencyIndex{
    NSString *currency = @"CNY";
    
    switch (currencyIndex) {
        case 1:
            currency = @"CNY";
            break;
        case 2:
            currency = @"TWD";
            break;
        default:
            break;
    }
    return currency;
}

+ (NSString *)getRecordType:(int)typeIndex
{
    NSString *type = @"餐饮";
    
    switch (typeIndex) {
        case 1:
            type = @"餐饮";
            break;
        case 2:
            type = @"娱乐";
            break;
        case 3:
            type = @"交通";
            break;
        case 4:
            type = @"机票";
            break;
        case 5:
            type = @"住宿";
            break;
        case 6:
            type = @"购物";
            break;
        case 7:
            type = @"通讯";
            break;
        case 8:
            type = @"其他";
            break;
        default:
            break;
    }
    return type;
}

@end
