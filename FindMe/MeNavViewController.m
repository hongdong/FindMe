//
//  MeNavViewController.m
//  FindMe
//
//  Created by mac on 14-6-28.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "MeNavViewController.h"

@interface MeNavViewController ()

@end

@implementation MeNavViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"tb4s"]
                      withFinishedUnselectedImage:[UIImage imageNamed:@"tb4"]];
        
        self.tabBarItem.tag = 4;
        
        self.navigationBar.translucent = NO;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
