  // //
//  DetailViewController.m
//  HUALE
//
//  Created by WEI WEI FAN on 16/8/6.
//  Copyright © 2016年 WEI WEI FAN. All rights reserved.
//

#import "DetailViewController.h"
#import "StaticDataHelper.h"

@interface DetailViewController () <UITextFieldDelegate>

{
    int defaultCurrency;
    int defaultType;
}

@end

@implementation DetailViewController

static NSDateFormatter *dateTimeFormatter = nil;

- (instancetype) initWithNewItem: (BOOL) isNew and: (RecordItem *) selectedRecord {
    self = [super init];
    if (self) {
        CGRect frame = CGRectMake(0, 667, self.view.bounds.size.width, self.view.bounds.size.height);
        self.view.frame = frame;
        self.amountField.delegate = self;
        self.remarkLabel.delegate = self;
        
        if(isNew) {
            defaultCurrency = 1;
            defaultType = 1;

        } else {
            _record = selectedRecord;
            defaultCurrency = _record.currency;
            defaultType = _record.recordType;
            
            [_currencyButton setTitle:[StaticDataHelper getCurrencyName:defaultCurrency] forState:UIControlStateNormal];
            [_remarkLabel setText:_record.remark];
            [_amountField setText:[_record.amount stringValue]];
        }
        
        for(UIView *subview in [self.view subviews]) {
            if (subview.tag == defaultType && [subview isKindOfClass:[UIButton class]]) {
                subview.backgroundColor = [UIColor yellowColor];
            }
        }
    }
    return self;
}
- (IBAction)changeCurrency:(id)sender
{
    if (defaultCurrency == 1) {
        [_currencyButton setTitle:[StaticDataHelper getCurrencyName:2] forState:UIControlStateNormal];
        defaultCurrency = 2;
    } else if (defaultCurrency == 2) {
        [_currencyButton setTitle:[StaticDataHelper getCurrencyName:1] forState:UIControlStateNormal];
        defaultCurrency = 1;
    }
}
- (IBAction)selectType:(id)sender
{
    UIButton *buttonTapped = (UIButton *)sender;
    
    defaultType = (int)buttonTapped.tag;
    
    buttonTapped.backgroundColor = [UIColor yellowColor];
    
    for(UIView *subview in [self.view subviews]) {
        if (subview.tag != defaultType && subview.tag < 9 && [subview isKindOfClass:[UIButton class]]) {
            subview.backgroundColor = [UIColor whiteColor];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    RecordItem *record = self.record;
    
    if (!dateTimeFormatter) {
        NSCalendar * calendar = [NSCalendar currentCalendar];
        dateTimeFormatter = [[NSDateFormatter alloc] init];
        dateTimeFormatter.locale = [NSLocale currentLocale];
        dateTimeFormatter.timeZone = calendar.timeZone;
        [dateTimeFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    self.dateLabel.text = [dateTimeFormatter stringFromDate:record.recordDate];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];
}

//- (IBAction)backgroundTapped:(id)sender {
//    [self.view endEditing:YES];
//}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag == 2) {
        [textField resignFirstResponder];
    }
    return YES;
}

- (void) saveRecord {
    RecordItem *record = self.record;
    record.amount = [NSDecimalNumber decimalNumberWithString:self.amountField.text];
    
    NSLog(@"amount is : %@", record.amount);
    
    record.remark = self.remarkLabel.text;
    record.currency = defaultCurrency;
    record.recordType = defaultType;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField.tag ==1) {
    
        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        NSArray  *arrayOfString = [newString componentsSeparatedByString:@"."];
    
        if ([arrayOfString count] > 2) {
            return NO;
        } else if ([arrayOfString count] == 2 && ((NSString*)arrayOfString[1]).length > 2) {
            return NO;
        } else if ([newString isEqualToString:@"."]) {
            return NO;
        } else if (newString.length == 2 && [[newString substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"0"] && ![newString isEqualToString:@"0."]) {
            [textField setText:nil];
            
            return YES;
        }
    }
    return YES;
}

@end
