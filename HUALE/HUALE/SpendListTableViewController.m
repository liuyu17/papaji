//
//  SpendListTableViewController.m
//  HUALE
//
//  Created by WEI WEI FAN on 16/8/6.
//  Copyright © 2016年 WEI WEI FAN. All rights reserved.
//

#import "SpendListTableViewController.h"
#import "RecordStore.h"
#import "RecordItem.h"
#import "SpendListTableViewCell.h"
#import "StaticDataHelper.h"
#import "MyAmount.h"
#import "HomeViewController.h"
#import "DetailViewController.h"

@interface SpendListTableViewController ()
{
}
@end

static NSDateFormatter * dateFormatter = nil;

@implementation SpendListTableViewController

- (instancetype)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        CGRect frame = CGRectMake(0, 120, self.view.bounds.size.width, self.view.bounds.size.height - 100);
        self.tableView.frame = frame;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINib *nib = [UINib nibWithNibName:@"SpendListTableViewCell" bundle:nil];
    
    [self.tableView registerNib:nib forCellReuseIdentifier:@"SpendListTableViewCell"];
    
    [self didMoveToParentViewController:self.parentViewController];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    NSUInteger number = [[[RecordStore sharedStore] sectionsInDate] count];
    if (number == 0) {
        number = 1;
    }
    return number;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSUInteger number = [[[RecordStore sharedStore] sectionsInDate] count];
    if (number == 0) {
        return 0;
    }
    
    NSString *dateString = [[[RecordStore sharedStore] sectionsInDate] objectAtIndex:section];
    NSArray *recordsOnthisDay = [[[RecordStore sharedStore] recordsInDate] objectForKey:dateString];
    return [recordsOnthisDay count];
}


- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSUInteger number = [[[RecordStore sharedStore] sectionsInDate] count];
    if (number == 0) {
        if (dateFormatter == nil) {
            NSCalendar * calendar = [NSCalendar currentCalendar];
            dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.locale = [NSLocale currentLocale];
            dateFormatter.timeZone = calendar.timeZone;
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        }
        return [dateFormatter stringFromDate:[NSDate date]];
    }
    NSString *dateString = [[[RecordStore sharedStore] sectionsInDate] objectAtIndex:section];
    return dateString;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SpendListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SpendListTableViewCell" forIndexPath:indexPath];
    
    NSString *dateString = [[[RecordStore sharedStore] sectionsInDate] objectAtIndex:indexPath.section];
    NSArray *recordsOnthisDay = [[[RecordStore sharedStore] recordsInDate] objectForKey:dateString];
    
    RecordItem *record = [recordsOnthisDay objectAtIndex:indexPath.row];

    NSDecimalNumber *amount = record.amount;
    MyAmount *myAmount = [[MyAmount alloc] initWithNSDecimalNumber:amount andCurrencyCode:[StaticDataHelper getCurrencyName: record.currency] andCurrencySize:15 andFractionSize:15];
    
    cell.amountInt.attributedText = myAmount.money;
    
    cell.recordType.text = [StaticDataHelper getRecordType:record.recordType];
    cell.title.text = record.remark;
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    

}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        NSString *dateString = [[[RecordStore sharedStore] sectionsInDate] objectAtIndex:indexPath.section];
        NSArray *recordsOnthisDay = [[[RecordStore sharedStore] recordsInDate] objectForKey:dateString];
        
        RecordItem *item = [recordsOnthisDay objectAtIndex:indexPath.row];
        [[RecordStore sharedStore] removeItem:item];
        if([recordsOnthisDay count] == 1 && indexPath.section != 0){
            [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
        } else {
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
        [(HomeViewController *)[self parentViewController] reloadAmount];
            
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *dateString = [[[RecordStore sharedStore] sectionsInDate] objectAtIndex:indexPath.section];
    NSArray *recordsOnthisDay = [[[RecordStore sharedStore] recordsInDate] objectForKey:dateString];
    
    RecordItem *selectedItem = [recordsOnthisDay objectAtIndex:indexPath.row];
    
    
    DetailViewController *detailViewController = [[DetailViewController alloc] initWithNewItem:NO and:selectedItem];

    HomeViewController *parentController = (HomeViewController *)[self parentViewController];
    [parentController addChildViewController:detailViewController];
    parentController.dvc = detailViewController;
    parentController.isNew = false;
    [parentController.view insertSubview:detailViewController.view belowSubview:parentController.cancelEditing];

    [parentController showNumberKeyBoard];
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.7 initialSpringVelocity:0.0 options:0 animations:^{
        CGRect frame = CGRectMake(0, 120, self.view.bounds.size.width, self.view.bounds.size.height);
        detailViewController.view.frame = frame;
        [parentController.addNewRecord setBackgroundColor:[UIColor colorWithRed:0.4 green:0.8 blue:0.6 alpha:1]];

    } completion:^(BOOL finished) {
//        [parentController showNumberKeyBoard];
    }];
    
    [parentController.addNewRecord setTitle:[NSString stringWithFormat:@"OK"] forState:UIControlStateNormal];
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
