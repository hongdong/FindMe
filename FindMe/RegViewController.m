//
//  RegViewController.m
//  FindMe
//
//  Created by mac on 14-9-1.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "RegViewController.h"
#import <SMS_SDK/SMS_SDK.h>
#import "User.h"
@interface RegViewController (){
    NSTimer *_timer;
    User *_user;
}

@end
static int count = 60;
@implementation RegViewController

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _user = [[User alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.timeLbl.hidden = YES;

}

-(void)updateTime
{
    count--;
    if (count<=0) {
        [_timer invalidate];
        [self showRepeatButton];
        return;
    }
    self.timeLbl.text=[NSString stringWithFormat:@"%i秒",count];
}

-(void)showRepeatButton{
    self.timeLbl.hidden=YES;
    self.getCodeBt.hidden=NO;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.phoneText becomeFirstResponder];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.phoneText resignFirstResponder];
    [self.passwordText resignFirstResponder];
    [self.codeText resignFirstResponder];
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
- (IBAction)getCodePressed:(UIButton *)sender {
    NSString* rule = @"^1(3|5|7|8|4)\\d{9}";
    NSPredicate* pred=[NSPredicate predicateWithFormat:@"SELF MATCHES %@",rule];
    BOOL isMatch=[pred evaluateWithObject:self.phoneText.text];
    if (!isMatch&&self.phoneText.text.length!=11) {
        //手机号码不正确
        [HDTool ToastNotification:@"手机号码非法，请重新填写" andView:self.view andLoading:NO andIsBottom:NO];
        return;
    }
    
    count = 60;
    NSTimer* timer=[NSTimer scheduledTimerWithTimeInterval:1
                                                    target:self
                                                  selector:@selector(updateTime)
                                                  userInfo:nil
                                                   repeats:YES];
    _timer = timer;
    self.getCodeBt.hidden = YES;
    self.timeLbl.text = @"60秒";
    self.timeLbl.hidden = NO;
    [self getCode];
}

- (void)getCode{
    [SMS_SDK getVerifyCodeByPhoneNumber:self.phoneText.text AndZone:@"86" result:^(enum SMS_GetVerifyCodeResponseState state) {
        if (1==state) {
            _user.userPhoneNumber = self.phoneText.text;
            [HDTool ToastNotification:@"验证码成功发送" andView:self.view andLoading:NO andIsBottom:NO];
        }
        else if(0==state)
        {
            [HDTool ToastNotification:@"验证码发送失败,请稍后重试" andView:self.view andLoading:NO andIsBottom:NO];
        }
        else if (SMS_ResponseStateMaxVerifyCode==state)//请求验证码超上限 请稍后重试
        {
            [HDTool ToastNotification:@"验证码发送失败,请稍后重试" andView:self.view andLoading:NO andIsBottom:NO];
        }
        else if(SMS_ResponseStateGetVerifyCodeTooOften==state)//客户端请求发送短信验证过于频繁
        {
            [HDTool ToastNotification:@"验证码发送失败,请稍后重试" andView:self.view andLoading:NO andIsBottom:NO];
        }
        
    }];

}
- (IBAction)submitPressed:(id)sender {
    [self.view endEditing:YES];
    if (![self check]) {
        return;
    }
    __weak __typeof(&*self)weakSelf = self;
    [HDTool showHDJGHUD:@"注册中..."];
    _user.userPassword = self.passwordText.text;
    [SMS_SDK commitVerifyCode:self.codeText.text result:^(enum SMS_ResponseState state) {
            if (1==state) {
                NSDictionary *parameters = @{@"userPhoneNumber": _user.userPhoneNumber,
                                             @"userPassword":_user.userPassword};
                
                [HDNet POST:@"/data/user/simple_rgst.do" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    NSString *state = responseObject[@"state"];
                    if ([state isEqualToString:@"20001"]) {
                        [HDTool dismissHDJGHUD];
                        _user._id = [responseObject objectForKey:@"id"];
                        [_user saveToNSUserDefaults];
                        [weakSelf performSegueWithIdentifier:@"chooseSchool" sender:nil];
                    }else if ([state isEqualToString:@"20002"]){
                        [HDTool dismissHDJGHUDWithHint:@"用户名已被注册，请返回直接登入"];
                    }else if ([state isEqualToString:@"10001"]){
                        [HDTool errorHDJGHUD];
                    }else{
                        [HDTool errorHDJGHUD];
                    }

                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    [HDTool errorHDJGHUD];
                }];
            }else if(0==state)
            {
                [HDTool errorHDJGHUD];

            }else{
                [HDTool errorHDJGHUD];
            }
        }];

}

- (BOOL)check{
    if (self.passwordText.text.length<6||self.passwordText.text.length>18) {
        [HDTool showHDJGHUDHint:@"密码非法"];
        return NO;
    }
    if (self.codeText.text.length!=4) {
        [HDTool showHDJGHUDHint:@"验证码非法"];
        return NO;
    }
    return YES;
}


@end
