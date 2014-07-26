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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)idenButtonPressed:(id)sender {
    [self.view endEditing:YES];
    if (![self isOK]) {
        return;
    }
    [self showHudInView:self.view.window hint:@"请稍后..."];
    NSString *urlStr = [NSString stringWithFormat:@"%@/data/user/auth_code.do",Host];
    NSString *urlStr1 = [NSString stringWithFormat:@"%@/data/user/user_auth.do",Host];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    __weak __typeof(&*self)weakSelf = self;
    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *codeInfo = [responseObject objectForKey:@"codeInfo"];
        if ([[codeInfo objectForKey:@"hashCode"] boolValue]) {
            [weakSelf hideHud];
            NSString *codeName = [codeInfo objectForKey:@"codeName"];
            if (codeName!=nil) {
                NSString *codeUrl = [NSString stringWithFormat:@"%@/upload/code/%@",Host,codeName];
                HDCodeView *codeView = [HDCodeView HDCodeViewWithAfterDismiss:^(int buttonIndex, NSString *text) {
                    if (buttonIndex==1) {
                        [weakSelf showHudInView:weakSelf.view.window hint:@"认证中..."];
                        NSDictionary *parameters = @{@"username": weakSelf.schoolId.text,
                                                     @"pwd":weakSelf.schoolPwd.text,
                                                     @"code":text};
                        [manager GET:urlStr1 parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            NSString *state = [[responseObject objectForKey:@"authInfo"] objectForKey:@"state"];
                            if ([state isEqualToString:@"20001"]) {
                                [_user getUserInfo:^{
                                    [_user saveToNSUserDefaults];
                                    [weakSelf showResultWithType:ResultSuccess];
                                    [weakSelf.navigationController popViewControllerAnimated:YES];
                                }];

                            }else{
                                NSString *msg = [[responseObject objectForKey:@"authInfo"] objectForKey:@"msg"];
                                [weakSelf hideHud];
                                [weakSelf showHint:msg];
                            }
                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            [weakSelf showResultWithType:ResultError];
                        }];
                    }
                } andUrl:codeUrl];
                [codeView show];
            }else{
                [weakSelf showResultWithType:ResultError];
            }
            
        }else{
            NSLog(@"没有验证码直接登入");
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [weakSelf showResultWithType:ResultError];
    }];
}

-(BOOL)isOK{
    NSString *temp = [self.schoolId.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if(temp.length==0)
    {
        [self showHint:@"学号不能为空"];
        return NO;
    }
    
    temp = [self.schoolPwd.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if(temp.length==0)
    {
        [self showHint:@"密码不能为空"];
        return NO;
    }
    return YES;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.schoolId resignFirstResponder];
    [self.schoolPwd resignFirstResponder];
    [self.view endEditing:YES];
}

@end
