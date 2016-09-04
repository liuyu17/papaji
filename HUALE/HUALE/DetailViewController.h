//
//  DetailViewController.h
//  HUALE
//
//  Created by WEI WEI FAN on 16/8/6.
//  Copyright © 2016年 WEI WEI FAN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecordItem.h"

@interface DetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *amountField;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *currencyButton;
@property (weak, nonatomic) IBOutlet UITextField *remarkLabel;

@property (nonatomic, strong) RecordItem *record;

- (instancetype) initWithNewItem: (BOOL) isNew and: (RecordItem *) selectedItem;
- (void) saveRecord;
@end
