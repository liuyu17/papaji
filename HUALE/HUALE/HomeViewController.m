//
//  HomeViewController.m
//  HUALE
//
//  Created by WEI WEI FAN on 16/8/6.
//  Copyright © 2016年 WEI WEI FAN. All rights reserved.
//

#import "HomeViewController.h"
#import "SpendListTableViewController.h"
#import "RecordItem.h"
#import "RecordStore.h"
#import "MyAmount.h"
#import "MyConstants.h"
#import "StaticDataHelper.h"

@interface HomeViewController ()
{
    BOOL flag;
    BOOL isKeyBoardShow;
    int currencyType;
    NSDecimalNumber *totalAmount;
}

@property (strong, nonatomic) SpendListTableViewController *svc;
@property (weak, nonatomic) IBOutlet UILabel *dollarsLabel;
@property (weak, nonatomic) IBOutlet UIButton *currencyShiftButton;


@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self reloadAmount];
    _isNew = true;
    isKeyBoardShow = false;
    flag = false;
    currencyType = 1;

    _svc = [[SpendListTableViewController alloc] init];
    [self addChildViewController:_svc];
    [self.view addSubview:_svc.tableView];

    _addNewRecord = [UIButton buttonWithType:UIButtonTypeCustom];
    [_addNewRecord setFrame:CGRectMake(187.5-20, 597, 40, 40)];
    [_addNewRecord setBackgroundColor:[UIColor colorWithRed:44/255.0 green:178/255.0 blue:219/255.0 alpha:1.0]];
    [_addNewRecord setTitle:@"+" forState:UIControlStateNormal];
    _addNewRecord.layer.cornerRadius = 20;
    _addNewRecord.layer.borderWidth = 0;
    _addNewRecord.layer.shadowOffset = CGSizeMake(1, 1);
    _addNewRecord.layer.shadowOpacity = 0.5;
    _addNewRecord.layer.shadowColor = [UIColor blackColor].CGColor;
    
    [_addNewRecord addTarget:self action:@selector(addNewRecord:) forControlEvents:UIControlEventTouchUpInside];
    
    _cancelEditing = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cancelEditing setFrame:CGRectMake(187.5-20, 597, 40, 40)];
    [_cancelEditing setBackgroundColor:[UIColor redColor]];
    [_cancelEditing setTitle:@"-" forState:UIControlStateNormal];
    _cancelEditing.layer.cornerRadius = 20;
    _cancelEditing.layer.borderWidth = 0;
    
    [_cancelEditing addTarget:self action:@selector(cancelEditing:) forControlEvents:UIControlEventTouchUpInside];
    
    [_cancelEditing setHidden:YES];
    [self.view addSubview:_addNewRecord];
    [self.view addSubview:_cancelEditing];
    [self.view bringSubviewToFront:_cancelEditing];
    [self.view bringSubviewToFront:_addNewRecord];
}

- (void) viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void) viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (IBAction) shiftCurrency:(id)sender {
    if (currencyType == 1) {
        currencyType = 2;
        totalAmount = [totalAmount decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:cnytotwd]];
        
    } else if (currencyType == 2) {
        currencyType = 1;
        totalAmount = [totalAmount decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:twdtocny]];
    }
    [_currencyShiftButton setTitle:[StaticDataHelper getCurrencyName:currencyType] forState:UIControlStateNormal];
    [self showTotalAmountWithAnimation: currencyType];
}


#pragma mark - keyboard movements
- (void)keyboardWillShow:(NSNotification *)notification
{
    NSLog(@"Keyboard show");
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    CGRect f = self.addNewRecord.frame;
    f.origin.y = 667 - (keyboardSize.height + 50);
    if(!CGRectEqualToRect(self.addNewRecord.frame, f)) {
    
        [UIView animateWithDuration:0.3 animations:^{
            CGRect f = self.addNewRecord.frame;
            f.origin.y = 667 - (keyboardSize.height + 50);
            if(f.origin.x == 167.5) {
                f.origin.x = 187.5 - 20 + 130;
            }
            self.addNewRecord.frame = f;

            
            CGRect f2 = self.cancelEditing.frame;
            f2.origin.y = 667 - (keyboardSize.height + 50);
            if(f2.origin.x == 167.5) {
                f2.origin.x = 187.5 - 20 - 130;
                [_cancelEditing setHidden:NO];
                _cancelEditing.layer.shadowOffset = CGSizeMake(1, 1);
                _cancelEditing.layer.shadowOpacity = 0.5;
                _cancelEditing.layer.shadowColor = [UIColor blackColor].CGColor;
            }
            self.cancelEditing.frame = f2;
        }];
    }
}

-(void)keyboardWillHide:(NSNotification *)notification
{
    NSLog(@"Keyboard hide");
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect f = self.addNewRecord.frame;
        f.origin.y = 597;
        self.addNewRecord.frame = f;
        
        CGRect f2 = self.cancelEditing.frame;
        f2.origin.y = 597;
        self.cancelEditing.frame = f2;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) showNumberKeyBoard
{
    [_dvc.amountField becomeFirstResponder];
}


- (void)addNewRecord:(id)sender {
    UIButton *myButton = (UIButton *) sender;
    if (_isNew) {
        if(!flag) {
        
            _dvc = [[DetailViewController alloc] initWithNewItem:YES and:nil];
            _dvc.record = [[RecordStore sharedStore] addRecord];
            [self addChildViewController:_dvc];
            [self.view insertSubview:_dvc.view belowSubview:_cancelEditing];
            [_cancelEditing setHidden:NO];
            _cancelEditing.layer.shadowOffset = CGSizeMake(1, 1);
            _cancelEditing.layer.shadowOpacity = 0.5;
            _cancelEditing.layer.shadowColor = [UIColor blackColor].CGColor;
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                [myButton setFrame:CGRectMake(187.5-20 + 130, 597, 40, 40)];
                [myButton setBackgroundColor:[UIColor colorWithRed:0.4 green:0.8 blue:0.6 alpha:1]];
                [_cancelEditing setFrame:CGRectMake(187.5-20 -130, 597, 40, 40)];
                
            }completion:^(BOOL finished) {
                [self showNumberKeyBoard];
                [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.0 options:0 animations:^{
                    
                    CGRect frame = CGRectMake(0, 120, self.view.bounds.size.width, self.view.bounds.size.height);
                    _dvc.view.frame = frame;
                    
                    } completion:^(BOOL finished) {
                }];
            }];
        
            flag = true;
      
            [myButton setTitle:[NSString stringWithFormat:@"OK"] forState:UIControlStateNormal];
        
        } else {

            myButton.enabled = NO;
            [_dvc saveRecord];
            [_dvc.view endEditing:YES];
        
            [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                CGRect frame = CGRectMake(0, 667, self.view.bounds.size.width, self.view.bounds.size.height);
                _dvc.view.frame = frame;
                [myButton setTitle:[NSString stringWithFormat:@"+"] forState:UIControlStateNormal];
                [myButton setFrame:CGRectMake(187.5-20, 597, 40, 40)];
                [myButton setBackgroundColor:[UIColor colorWithRed:44/255.0 green:178/255.0 blue:219/255.0 alpha:1.0]];
                [_cancelEditing setFrame:CGRectMake(187.5-20, 597, 40, 40)];

            }completion:^(BOOL finished){
                [_dvc.view removeFromSuperview];
            
                [_dvc removeFromParentViewController];
                flag = false;
                RecordItem *newRecord = _dvc.record;
                if(!newRecord.amount || [newRecord.amount isEqualToNumber:[NSDecimalNumber notANumber]]) {
                    [[RecordStore sharedStore] removeItem:newRecord];
                } else {
//                    [_svc.tableView beginUpdates];
//                    NSIndexPath * newIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                    
//                    [_svc.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
//                    
//                    [_svc.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
                    
//                    [_svc.tableView endUpdates];
                    [_svc.tableView reloadData];
                    [self reloadAmount];
                }
                myButton.enabled = YES;
                [_cancelEditing setHidden:YES];

            }];
        }
    } else {
        myButton.enabled = NO;
        [_dvc saveRecord];
        [_dvc.view endEditing:YES];
        
        
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            CGRect frame = CGRectMake(0, 667, self.view.bounds.size.width, self.view.bounds.size.height);
            _dvc.view.frame = frame;
            [myButton setTitle:[NSString stringWithFormat:@"+"] forState:UIControlStateNormal];
            [myButton setFrame:CGRectMake(187.5-20, 597, 40, 40)];
            [myButton setBackgroundColor:[UIColor colorWithRed:44/255.0 green:178/255.0 blue:219/255.0 alpha:1.0]];
            [_cancelEditing setFrame:CGRectMake(187.5-20, 597, 40, 40)];

        }completion:^(BOOL finished){
            [_dvc.view removeFromSuperview];
            
            [_dvc removeFromParentViewController];
            flag = false;
            _isNew = true;

            
//            [_svc.tableView beginUpdates];
//            [_svc.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
            
//            [_svc.tableView endUpdates];
            [_svc.tableView reloadData];
            [self reloadAmount];
            myButton.enabled = YES;
            [_cancelEditing setHidden:YES];
            
        }];
    }
}

- (void)cancelEditing:(id)sender {

    _addNewRecord.enabled = NO;
    [_dvc.view endEditing:YES];
    
    if(_isNew) {
        [[RecordStore sharedStore] removeItem:_dvc.record];
    }
    
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        CGRect frame = CGRectMake(0, 667, self.view.bounds.size.width, self.view.bounds.size.height);
        _dvc.view.frame = frame;
        [_addNewRecord setTitle:[NSString stringWithFormat:@"+"] forState:UIControlStateNormal];
        [_addNewRecord setFrame:CGRectMake(187.5-20, 597, 40, 40)];
        [_addNewRecord setBackgroundColor:[UIColor colorWithRed:44/255.0 green:178/255.0 blue:219/255.0 alpha:1.0]];
        [_cancelEditing setFrame:CGRectMake(187.5-20, 597, 40, 40)];
    }completion:^(BOOL finished){
        [_dvc.view removeFromSuperview];
        
        [_dvc removeFromParentViewController];
        flag = false;
        
        _addNewRecord.enabled = YES;
        _isNew = true;
        [_cancelEditing setHidden:YES];

    }];
}

- (void) reloadAmount
{
    totalAmount = [NSDecimalNumber decimalNumberWithString:@"0"];
    NSArray *recordArray = [[RecordStore sharedStore] allRecords];
    for(RecordItem *item in recordArray) {
        int currency = item.currency;
        if (currency == 1) {
            totalAmount = [totalAmount decimalNumberByAdding:item.amount];
        }
        else if (currency == 2) {
            NSDecimalNumber *exRate = [NSDecimalNumber decimalNumberWithString:twdtocny];
            totalAmount = [totalAmount decimalNumberByAdding:[item.amount decimalNumberByMultiplyingBy:exRate]];
        }
    }
    
    if (currencyType == 2) {
        totalAmount = [totalAmount decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:cnytotwd]];
    }
    
    [self showTotalAmountWithAnimation: currencyType];
}

- (void) showTotalAmountWithAnimation: (int) currencyCode {
    MyAmount *myAmount = [[MyAmount alloc] initWithNSDecimalNumber:totalAmount andCurrencyCode:[StaticDataHelper getCurrencyName:currencyType] andCurrencySize:25 andFractionSize:30];
    if (![[myAmount.money string] isEqualToString:_dollarsLabel.text]) {
    [UIView animateKeyframesWithDuration:0.5 delay:0.0 options:0 animations:^{
        
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            [_dollarsLabel setAlpha:0];
        }completion:^(BOOL finished){
            [_dollarsLabel setAttributedText:myAmount.money];
        }];
        
        [UIView addKeyframeWithRelativeStartTime:0.2 relativeDuration:0.4 animations:^{
            
            [_dollarsLabel setAlpha:1];
        }];
    } completion:nil];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (BOOL) shouldAutorotate
{
    return NO;
}

@end
