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
    [self showHudInView:self.view.window hint:@"请稍后..."];
    NSString *urlStr = [NSString stringWithFormat:@"%@/data/user/auth_code.do",Host];
    NSString *urlStr1 = [NSString stringWithFormat:@"%@/data/user/user_auth.do",Host];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    __weak __typeof(&*self)weakSelf = self;
    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *hasCode = [responseObject objectForKey:@"hasCode"];
        if ([hasCode isEqualToString:@"1"]) {
            [weakSelf hideHud];
            NSString *codeName = [responseObject objectForKey:@"codeName"];
            if (codeName!=nil) {
                NSString *codeUrl = [NSString stringWithFormat:@"%@/upload/code/%@",Host,codeName];
                HDCodeView *codeView = [HDCodeView HDCodeViewWithAfterDismiss:^(int buttonIndex, NSString *text) {
                    if (buttonIndex==1) {
                        NSDictionary *parameters = @{@"username": weakSelf.schoolId.text,
                                                     @"pwd":weakSelf.schoolPwd.text,
                                                     @"code":text};
                        [manager GET:urlStr1 parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            NSString *state = [[responseObject objectForKey:@"authInfo"] objectForKey:@"state"];
                            if ([state isEqualToString:@"20001"]) {
                                NSLog(@"授权成功");
                                //发送加V通知
                            }
                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            
                        }];
                    }
                } andUrl:codeUrl];
                [codeView show];
            }else{
                NSLog(@"请求验证码失败");
            }
            
        }else{
            NSLog(@"没有验证码直接登入");
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.schoolId becomeFirstResponder];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.schoolId resignFirstResponder];
    [self.schoolPwd resignFirstResponder];
    [self.view endEditing:YES];
}

@end
