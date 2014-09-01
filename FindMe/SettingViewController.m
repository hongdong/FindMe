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
#import "User.h"
#import "iVersion.h"
#import <ShareSDK/ShareSDK.h>
@interface SettingViewController ()<iVersionDelegate>

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

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
       [[iVersion sharedInstance] setDelegate:self];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginChange:) name:KNOTIFICATION_LOGINCHANGE object:nil];
    
    __weak __typeof(&*self)weakSelf = self;
    [self.pjwmView whenTouchedDown:^{
        weakSelf.pjwmView.backgroundColor = [UIColor lightGrayColor];
    }];
    [self.pjwmView whenTouchedUp:^{
        weakSelf.pjwmView.backgroundColor = [UIColor whiteColor];
        [[iVersion sharedInstance] openAppPageInAppStore];
    }];
    
    [self.qchcView whenTouchedDown:^{
        weakSelf.qchcView.backgroundColor = [UIColor lightGrayColor];
    }];
    [self.qchcView whenTouchedUp:^{
        weakSelf.qchcView.backgroundColor = [UIColor whiteColor];
        [weakSelf showHint:@"清理完成"];
    }];
    
    [self.jcgxView whenTouchedDown:^{
        weakSelf.jcgxView.backgroundColor = [UIColor lightGrayColor];
    }];
    [self.jcgxView whenTouchedUp:^{
        weakSelf.jcgxView.backgroundColor = [UIColor whiteColor];
        [HDTool showHUD:@"检测中..."];
        [[iVersion sharedInstance] checkForNewVersion];
    }];
    
    [self.syxyView whenTouchedDown:^{
        weakSelf.syxyView.backgroundColor = [UIColor lightGrayColor];
    }];
    [self.syxyView whenTouchedUp:^{
        weakSelf.syxyView.backgroundColor = [UIColor whiteColor];
        [weakSelf performSegueWithIdentifier:@"syxy" sender:nil];
    }];
    
    [self.gywmView whenTouchedDown:^{
        weakSelf.gywmView.backgroundColor = [UIColor lightGrayColor];
    }];
    [self.gywmView whenTouchedUp:^{
        weakSelf.gywmView.backgroundColor = [UIColor whiteColor];
        [weakSelf performSegueWithIdentifier:@"gywm" sender:nil];
    }];
    
    [self.yyfkView whenTouchedDown:^{
        weakSelf.yyfkView.backgroundColor = [UIColor lightGrayColor];
    }];
    [self.yyfkView whenTouchedUp:^{
        weakSelf.yyfkView.backgroundColor = [UIColor whiteColor];
        [weakSelf performSegueWithIdentifier:@"yhfk" sender:nil];
    }];
    
}
#pragma delegate
- (void)iVersionDidNotDetectNewVersion{
    [HDTool dismissHUD];
    [self showHint:@"已经是最新版本了"];
}
- (void)iVersionDidDetectNewVersion:(NSString *)version details:(NSString *)versionDetails{
    [HDTool dismissHUD];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KNOTIFICATION_LOGINCHANGE object:nil];
}
-(void)loginChange:(NSNotification *)notification{
    BOOL isLogin = [notification.object boolValue];
    if (isLogin) {

    }
    else{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (IBAction)signOutPressed:(id)sender {
    [HDTool showHUD:@"注销中..."];
    NSString *urlStr = [NSString stringWithFormat:@"%@/data/user/login_out.do",Host];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *state = [responseObject objectForKey:@"state"];
        if ([state isEqualToString:@"20001"]) {
            [HDTool dismissHUD];
            [[Config sharedConfig] initBadge];
            [[Config sharedConfig] changeLoginState:@"0"];
            [[Config sharedConfig] changeOnlineState:@"0"];
            [[Config sharedConfig] friendNew:@"0"];
            [[Config sharedConfig] matchNew:@"0"];
            [[Config sharedConfig] fansNew:@"0"];
            [[Config sharedConfig] postNew:@"0"];
            [User removeDbObjectsWhere:@"1=1"];
            User *user = [User getUserFromNSUserDefaults];
            ShareType type = ShareTypeSinaWeibo;
            if ([user.userAuthType isEqualToString:@"QZone"]) {
                type = ShareTypeQQSpace;
            }
            [ShareSDK cancelAuthWithType:type];
            [[Config sharedConfig] cleanUser];

            self.tabBarController.selectedIndex = 0;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
            
            [[EaseMob sharedInstance].chatManager asyncLogoffWithCompletion:^(NSDictionary *info, EMError *error) {
                if (!error) {
                }
                else{
                    
                }
            } onQueue:nil];
        }else{
            [HDTool errorHUD];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        [HDTool errorHUD];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



@end
