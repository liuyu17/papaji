//
//  MyAmount.m
//  HUALE
//
//  Created by WEI WEI FAN on 16/8/7.
//  Copyright © 2016年 WEI WEI FAN. All rights reserved.
//

#import "MyAmount.h"

@implementation MyAmount



- (instancetype) initWithNSDecimalNumber: (NSDecimalNumber *) amount andCurrencyCode: (NSString *) currencyCode andCurrencySize: (CGFloat) fontSize andFractionSize: (CGFloat) fractionSize;
{
    self = [super init];
    if(self) {
        
            static NSNumberFormatter *currencyFormatter = nil;
            if (currencyFormatter == nil) {
                currencyFormatter = [[NSNumberFormatter alloc] init];
                currencyFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
                NSLocale *lcl = [[NSLocale alloc] initWithLocaleIdentifier:@"zh-Hans"];
                currencyFormatter.locale = lcl;
            }
            currencyFormatter.currencyCode = currencyCode;
            
            
            NSString *currencySymbol = [NSString stringWithFormat:@"%@",[currencyFormatter.locale displayNameForKey:NSLocaleCurrencySymbol value:currencyCode]];
            
            _dollars = [currencyFormatter stringFromNumber:amount];
            
            _money = [[NSMutableAttributedString alloc] initWithString:_dollars];
            
            NSRange currencyRange = NSMakeRange(0, currencySymbol.length);
            
            [_money addAttribute:NSFontAttributeName value:[UIFont fontWithName: @"Helvetica" size: fontSize] range:currencyRange];
        
        NSRange fractionRange = NSMakeRange(_dollars.length -3, 3);
        
        [_money addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica" size:fractionSize] range:fractionRange];
        
            NSMutableAttributedString *space = [[NSMutableAttributedString alloc] initWithString:@" "];
            [_money insertAttributedString: space atIndex: currencySymbol.length] ;

        
    }
    
    return self;
}

@end
