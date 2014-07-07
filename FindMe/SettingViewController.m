//
//  SettingViewController.m
//  FindMe
//
//  Created by mac on 14-7-7.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "SettingViewController.h"
#import "JMWhenTapped.h"
@interface SettingViewController ()

@end

@implementation SettingViewController

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
    __weak __typeof(&*self)weakSelf = self;
    [self.pjwmView whenTouchedDown:^{
        weakSelf.pjwmView.backgroundColor = [UIColor lightGrayColor];
    }];
    [self.pjwmView whenTouchedUp:^{
        weakSelf.pjwmView.backgroundColor = [UIColor whiteColor];
    }];
    
    [self.qchcView whenTouchedDown:^{
        weakSelf.qchcView.backgroundColor = [UIColor lightGrayColor];
    }];
    [self.qchcView whenTouchedUp:^{
        weakSelf.qchcView.backgroundColor = [UIColor whiteColor];
    }];
    
    [self.jcgxView whenTouchedDown:^{
        weakSelf.jcgxView.backgroundColor = [UIColor lightGrayColor];
    }];
    [self.jcgxView whenTouchedUp:^{
        weakSelf.jcgxView.backgroundColor = [UIColor whiteColor];
    }];
    
    [self.syxyView whenTouchedDown:^{
        weakSelf.syxyView.backgroundColor = [UIColor lightGrayColor];
    }];
    [self.syxyView whenTouchedUp:^{
        weakSelf.syxyView.backgroundColor = [UIColor whiteColor];
    }];
    
    [self.gywmView whenTouchedDown:^{
        weakSelf.gywmView.backgroundColor = [UIColor lightGrayColor];
    }];
    [self.gywmView whenTouchedUp:^{
        weakSelf.gywmView.backgroundColor = [UIColor whiteColor];
    }];
    
    [self.yyfkView whenTouchedDown:^{
        weakSelf.yyfkView.backgroundColor = [UIColor lightGrayColor];
    }];
    [self.yyfkView whenTouchedUp:^{
        weakSelf.yyfkView.backgroundColor = [UIColor whiteColor];
    }];
    
}
- (IBAction)signOutPressed:(id)sender {
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



@end
