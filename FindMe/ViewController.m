//
//  ViewController.m
//  FindMe
//
//  Created by mac on 14-6-18.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "ViewController.h"
#import "EaseMob.h"
@interface ViewController ()

@end

@implementation ViewController

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
        [self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"tb0s"]
                      withFinishedUnselectedImage:[UIImage imageNamed:@"tb0"]];
        

    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tabBarItem.badgeValue = @"Hi";
}

-(void)dealloc{


}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
