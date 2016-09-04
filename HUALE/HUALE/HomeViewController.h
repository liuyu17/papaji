//
//  HomeViewController.h
//  HUALE
//
//  Created by WEI WEI FAN on 16/8/6.
//  Copyright © 2016年 WEI WEI FAN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailViewController.h"

@interface HomeViewController : UIViewController

@property (strong, nonatomic) UIButton *addNewRecord;
@property (strong, nonatomic) UIButton *cancelEditing;
@property (strong, nonatomic) DetailViewController *dvc;
@property BOOL isNew;

- (void) reloadAmount;
- (void) showNumberKeyBoard;

@end
