//
//  SettingViewController.m
//  FindMe
//
//  Created by mac on 14-7-7.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "SettingViewController.h"
#import "JMWhenTapped.h"
#import "AFNetworking.h"
#import "EaseMob.h"
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
    NSString *urlStr = [NSString stringWithFormat:@"%@/data/user/login_out.do",Host];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *state = [responseObject objectForKey:@"state"];
        if ([state isEqualToString:@"20001"]) {
            [[Config sharedConfig] initBadge];
            [[Config sharedConfig] cleanUser];
            //注销环信,修改islogin  清除user  初始化badge
            [[EaseMob sharedInstance].chatManager asyncLogoffWithCompletion:^(NSDictionary *info, EMError *error) {
                if (error) {

                }
                else{
                    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
                }
            } onQueue:nil];
            NSLog(@"注销成功");
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



@end
