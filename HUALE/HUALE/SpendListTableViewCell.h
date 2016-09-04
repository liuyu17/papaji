//
//  SpendListTableViewCell.h
//  HUALE
//
//  Created by WEI WEI FAN on 16/8/6.
//  Copyright © 2016年 WEI WEI FAN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SpendListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *recordType;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *amountInt;

@end
