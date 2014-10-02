//
//  IdentifyViewController.m
//  FindMe
//
//  Created by mac on 14-7-8.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "IdentifyViewController.h"
#import "User.h"
#import "XYAlertViewHeader.h"
@interface IdentifyViewController (){
    User *_user;
}

@end

@implementation IdentifyViewController

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
    _user = [User getUserFromNSUserDefaults];
    self.schoolLbl.text = [_user getSchoolName];
    [self setupForDismissKeyboard];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.schoolId becomeFirstResponder];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)idenButtonPressed:(id)sender {
    if (![self isOK]) {
        return;
    }
    
    [self.view endEditing:YES];
    [HDTool showHDJGHUD:@"加载中..."];
    __weak __typeof(&*self)weakSelf = self;
    
    [HDNet GET:@"/data/user/auth_code.do" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *codeInfo = [responseObject objectForKey:@"codeInfo"];
        if ([[codeInfo objectForKey:@"hashCode"] boolValue]) {
            [HDTool dismissHDJGHUD];
            NSString *codeName = [codeInfo objectForKey:@"codeName"];
            if (codeName!=nil) {
                NSString *codeUrl = [NSString stringWithFormat:@"%@/upload/code/%@",Host,codeName];
                HDCodeView *codeView = [HDCodeView HDCodeViewWithAfterDismiss:^(int buttonIndex, NSString *text) {
                    if (buttonIndex==1) {
                        [HDTool showHDJGHUD:@"认证中..."];
                        NSDictionary *parameters = @{@"username": weakSelf.schoolId.text,
                                                     @"pwd":weakSelf.schoolPwd.text,
                                                     @"code":text};
                        [weakSelf user_authParameters:parameters];
                    }
                } andUrl:codeUrl];
                [codeView show];
            }else{
                [HDTool errorHDJGHUD];
            }
            
        }else{
            NSDictionary *parameters = @{@"username": weakSelf.schoolId.text,
                                         @"pwd":weakSelf.schoolPwd.text};
            [weakSelf user_authParameters:parameters];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [HDTool errorHDJGHUD];
    }];

}

-(void)user_authParameters:(id)parameters{
    __weak __typeof(&*self)weakSelf = self;
    
    [HDNet GET:@"/data/user/user_auth.do" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *state = [[responseObject objectForKey:@"authInfo"] objectForKey:@"state"];
        if ([state isEqualToString:@"20001"]) {
            [_user getUserInfo:^{
                [_user saveToNSUserDefaults];
                [HDTool successHDJGHUD];
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }];
            
        }else{
            NSString *msg = [[responseObject objectForKey:@"authInfo"] objectForKey:@"msg"];
            [HDTool dismissHDJGHUDWithHint:msg];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [HDTool errorHDJGHUD];
    }];
    
}

-(BOOL)isOK{
    NSString *temp = [self.schoolId.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if(temp.length==0)
    {
        [HDTool ToastNotification:@"学号不能为空" andView:self.view andLoading:NO andIsBottom:NO];
        return NO;
    }
    
    temp = [self.schoolPwd.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if(temp.length==0)
    {
        [HDTool ToastNotification:@"密码不能为空" andView:self.view andLoading:NO andIsBottom:NO];
        return NO;
    }
    return YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.schoolId resignFirstResponder];
    [self.schoolPwd resignFirstResponder];
    [self.view endEditing:YES];
}

@end
