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
#import <AFNetworking.h>
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
    [HDTool showHUD:@"加载中..."];
    NSString *urlStr = [NSString stringWithFormat:@"%@/data/user/auth_code.do",Host];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    __weak __typeof(&*self)weakSelf = self;
    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *codeInfo = [responseObject objectForKey:@"codeInfo"];
        if ([[codeInfo objectForKey:@"hashCode"] boolValue]) {
            [HDTool dismissHUD];
            NSString *codeName = [codeInfo objectForKey:@"codeName"];
            if (codeName!=nil) {
                NSString *codeUrl = [NSString stringWithFormat:@"%@/upload/code/%@",Host,codeName];
                HDCodeView *codeView = [HDCodeView HDCodeViewWithAfterDismiss:^(int buttonIndex, NSString *text) {
                    if (buttonIndex==1) {
                        [HDTool showHUD:@"认证中..."];
                        NSDictionary *parameters = @{@"username": weakSelf.schoolId.text,
                                                     @"pwd":weakSelf.schoolPwd.text,
                                                     @"code":text};
                        [weakSelf user_auth:manager parameters:parameters];
                    }
                } andUrl:codeUrl];
                [codeView show];
            }else{
                [HDTool errorHUD];
            }
            
        }else{
            NSDictionary *parameters = @{@"username": weakSelf.schoolId.text,
                                         @"pwd":weakSelf.schoolPwd.text};
            [weakSelf user_auth:manager parameters:parameters];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [HDTool errorHUD];
    }];
}

-(void)user_auth:(AFHTTPRequestOperationManager *)manager parameters:(id)parameters{
        NSString *urlStr = [NSString stringWithFormat:@"%@/data/user/user_auth.do",Host];
    __weak __typeof(&*self)weakSelf = self;
    [manager GET:urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *state = [[responseObject objectForKey:@"authInfo"] objectForKey:@"state"];
        if ([state isEqualToString:@"20001"]) {
            [_user getUserInfo:^{
                [_user saveToNSUserDefaults];
                [HDTool successHUD];
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }];
            
        }else{
            NSString *msg = [[responseObject objectForKey:@"authInfo"] objectForKey:@"msg"];
            [HDTool dismissHUD];
            [weakSelf showHint:msg];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [HDTool errorHUD];
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
