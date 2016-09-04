//
//  MyAmount.h
//  HUALE
//
//  Created by WEI WEI FAN on 16/8/7.
//  Copyright © 2016年 WEI WEI FAN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MyAmount : NSObject

@property (nonatomic, readonly) NSString *dollars;
@property (nonatomic, readonly) NSString *cents;
@property (nonatomic, readonly) NSMutableAttributedString *money;

- (instancetype) initWithNSDecimalNumber: (NSDecimalNumber *) amount andCurrencyCode: (NSString *) currencyCode andCurrencySize: (CGFloat) fontSize andFractionSize: (CGFloat) fractionSize;

@end
