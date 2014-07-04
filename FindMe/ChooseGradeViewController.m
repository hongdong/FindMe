//
//  ChooseGradeViewController.m
//  FindMe
//
//  Created by mac on 14-4-30.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "ChooseGradeViewController.h"
#import "AMSmoothAlertView.h"
#import "PersonInfoViewController.h"
@interface ChooseGradeViewController (){
    AMSmoothAlertView *_alert;
}

@end

@implementation ChooseGradeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationItem.title = @"入学年份";
    self.title = @"入学年份";
    self.tableView.dataSource = self;
    self.tableView.delegate = self;

    NSDate *now = [NSDate date];

    

    NSCalendar *calendar = [NSCalendar currentCalendar];

    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;

    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];

    _lastestYear = [dateComponent year];

    int month = [dateComponent month];

    int day = [dateComponent day];

    int hour = [dateComponent hour];

    int minute = [dateComponent minute];

    int second = [dateComponent second];


    _dataArray = @[@"2008",@"2009",@"2010",@"2011",@"2012",@"2013",@"2014",@"2015"];
    
//    _alert = [[AMSmoothAlertView alloc]initDropAlertWithTitle:@"提醒" andText:@"" andCancelButton:YES forAlertType:AlertInfo andColor:[UIColor colorWithRed:0.607 green:0.372 blue:0.862 alpha:1]];
//    [_alert.defaultButton setTitle:@"确认" forState:UIControlStateNormal];
//    [_alert.defaultButton addTarget:self action:@selector(submitPressed:) forControlEvents:UIControlEventTouchUpInside];
//    [_alert.cancelButton setTitle:@"重填" forState:UIControlStateNormal];
//    [_alert setTitleFont:[UIFont fontWithName:@"Verdana" size:25.0f]];
//    _alert.cornerRadius = 3.0f;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

}
#pragma UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

        return _lastestYear-2008+1;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

        cell.textLabel.text = [NSString stringWithFormat:@"%d",_lastestYear-indexPath.row];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    _user.userGrade = [NSString stringWithFormat:@"%d",_lastestYear-indexPath.row];

    NSString *checkInfoStr = [NSString stringWithFormat:@"你是%@%@%@级的童鞋",_user.userScName, _user.userDeptName,     _user.userGrade];
    _alert = [[AMSmoothAlertView alloc]initDropAlertWithTitle:@"提醒" andText:checkInfoStr andCancelButton:YES forAlertType:AlertInfo andColor:[UIColor colorWithRed:0.607 green:0.372 blue:0.862 alpha:1]];
    [_alert.defaultButton setTitle:@"确认" forState:UIControlStateNormal];
    [_alert.defaultButton addTarget:self action:@selector(submitPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_alert.cancelButton setTitle:@"重填" forState:UIControlStateNormal];
    [_alert setTitleFont:[UIFont fontWithName:@"Verdana" size:25.0f]];
    _alert.cornerRadius = 3.0f;
    //        [self.view addSubview:alert];
    _alert.textLabel.text = checkInfoStr;
    [_alert show];
}
-(void) submitPressed:(id)sender{
    [self performSegueWithIdentifier:@"personInfo" sender:_user];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue identifier] isEqualToString:@"personInfo"])
    {
        
        PersonInfoViewController *controller=(PersonInfoViewController *)segue.destinationViewController;
        controller.user = _user;
    }
}

@end
