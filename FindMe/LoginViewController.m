//
//  LoginViewController.m
//  FindMe
//
//  Created by mac on 14-9-2.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "LoginViewController.h"
#import "User.h"
@interface LoginViewController (){
    User *_user;
}

@end

@implementation LoginViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _user = [[User alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.phoneText becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.phoneText resignFirstResponder];
    [self.passwordText resignFirstResponder];
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)loginPressed:(id)sender {
    [self.view endEditing:YES];
    if (![self check]) {
        return;
    }
    [HDTool showHUD:@"登入中..."];
    __weak __typeof(&*self)weakSelf = self;
    [HDNet login:self.phoneText.text andPassword:self.passwordText.text andBack:@"0" success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *state = [responseObject objectForKey:@"state"];
        
        if ([state isEqualToString:@"20001"]) {
            [HDTool dismissHUD];
            _user._id = [responseObject objectForKey:@"userId"];
            
            [_user getUserInfo:^{
                [_user saveToNSUserDefaults];//保存登入信息
            }];
            
            [[Config sharedConfig] changeLoginState:@"1"];
            [[Config sharedConfig] changeOnlineState:@"1"];
            [[Config sharedConfig] friendNew:@"1"];
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@YES userInfo:@{@"isBack": @"0"}];
            [HDNet EaseMobLoginWithUsername:_user._id];//IM登入
            
        }else if ([state isEqualToString:@"20002"]){
            
            [HDTool dismissHUD];
            _user.userPhoneNumber = weakSelf.phoneText.text;
            _user.userPassword = weakSelf.passwordText.text;
            [_user saveToNSUserDefaults];
            [weakSelf performSegueWithIdentifier:@"chooseSchool2" sender:nil];
            
        }else if([state isEqualToString:@"10001"]){
            [HDTool errorHUD];
        }else if ([state isEqualToString:@"20003"]){
            [HDTool dismissHUD];
            [weakSelf showHint:@"此号码还未注册，请点击注册"];
        }else if ([state isEqualToString:@"20004"]){
            [HDTool dismissHUD];
            [weakSelf showHint:@"密码不正确"];
        }else{
            [HDTool errorHUD];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [HDTool errorHUD];
    }];
}

-(BOOL)check{
    if (self.phoneText.text.length!=11) {
        [self showHint:@"电话号码非法"];
        return NO;
    }
    if (self.passwordText.text.length<6) {
        [self showHint:@"密码非法"];
        return NO;
    }
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self loginPressed:nil];
    return NO;
}

@end
