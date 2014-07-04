//
//  LoginViewController.m
//  FindMe
//
//  Created by mac on 14-6-21.
//  Copyright (c) 2014年 mac. All rights reserved.
//
#import <ShareSDK/ShareSDK.h>
#import "FindMeViewController.h"
#import <AFNetworking.h>
#import "User.h"
#import "EaseMob.h"
#import "EMError.h"
#import "ChooseSchoolViewController.h"
#import "LoginView.h"
@interface FindMeViewController (){
    User *_user;
    LoginView *_loginView;
}

@end

@implementation FindMeViewController



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
//        if ([[Config sharedConfig] isLogin]) {
//            NSLog(@"已经登入");
//        }else{
//            NSLog(@"未登入，显示登入界面");
//            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomView" owner:self options:nil];
//            _loginView = [nib objectAtIndex:1];
//        }
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        if ([[Config sharedConfig] isLogin]) {
            NSLog(@"已经登入");
        }else{
            NSLog(@"未登入，显示登入界面");
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomView" owner:self options:nil];
            _loginView = [nib objectAtIndex:1];
            _loginView.delegate = self;
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"番迷";
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"findme"]];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginStateChange:)
                                                 name:KNOTIFICATION_LOGINCHANGE
                                               object:nil];
    if (_loginView!=nil) {
        [self.view addSubview:_loginView];
    }
}

-(void)loginStateChange:(NSNotification *)notification{
    NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
    BOOL isLogin = loginInfo && [loginInfo count] > 0;
    if (notification.object) {
        isLogin = [notification.object boolValue] && isLogin;
    }
    
    if (isLogin) {
        [_loginView moveToUpSide];
    }
    else{

    }
}



#pragma loginViewDelegate
- (void)login:(UIButton *)sender{
    [self showHudInView:self.view.window hint:@"登入中..."];
    ShareType type;
    NSString * sendType;
    if (sender.tag==101) {
        type = ShareTypeSinaWeibo;
        sendType = @"SinaWeibo";
    }else if(sender.tag==100){
        type = ShareTypeQQSpace;
        sendType = @"QZone";
    }
    
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:YES
                                                                scopes:nil
                                                         powerByHidden:YES
                                                        followAccounts:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                        [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"洪小东东"],
                                                                        SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
                                                                        nil]
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:self
                                               authManagerViewDelegate:nil];
    
    
    NSLog(@"是否授权%hhd",[ShareSDK hasAuthorizedWithType:type]);
    //    [ShareSDK authWithType:type                                              //需要授权的平台类型
    //                   options:authOptions                                          //授权选项，包括视图定制，自动授权
    //                    result:^(SSAuthState state, id<ICMErrorInfo> error) {       //授权返回后的回调方法
    //                        if (state == SSAuthStateSuccess)
    //                        {
    //                            [self showHudInView:self.view.window];
    //                            [self initUser:userInfo AndSendType:sendType];
    //                            [self isOauth:[userInfo uid] forType:sendType];
    //                        }
    //                        else if (state == SSAuthStateFail)
    //                        {
    //                            NSLog(@"失败");
    //                        }
    //                    }];
    __weak __typeof(&*self)weakSelf = self;
    [ShareSDK getUserInfoWithType:type
                      authOptions:authOptions
                           result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
                               
                               
                               if (result) {
                                   //[weakSelf showHudInView:self.view.window];
                                   [weakSelf initUser:userInfo AndSendType:sendType];
                                   
                                   [weakSelf isOauth:[userInfo uid] forType:sendType];
                                   
                               }else{
                                   
                               }
                               
                           }];
}



#pragma ShareSDKDelete
- (void)viewOnWillDisplay:(UIViewController *)viewController shareType:(ShareType)shareType{
    [self hideHud];
}
- (void)viewOnWillDismiss:(UIViewController *)viewController shareType:(ShareType)shareType{
    [self showHudInView:self.view hint:@"登入中..."];
}

- (void)initUser:(id<ISSPlatformUser>) userInfo AndSendType:(NSString *) sendType{
    _user = [[User alloc] init];
    _user.openId = [userInfo uid];
    _user.userNickName = [userInfo nickname];
    _user.userPhoto = [userInfo profileImage];
    NSString *sex;
    if ([userInfo gender]==0) {
        sex = @"男";
    }else if([userInfo gender]==1){
        sex = @"女";
    }else{
        sex = @"未知";
    }
    _user.userSex = sex;
    _user.type = sendType;
    
}

- (void)isOauth:(NSString *) uid forType:(NSString *) type{
    NSString *urlStr = [NSString stringWithFormat:@"%@/data/user/grant_user.do",Host];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"userOpenId"     : uid,
                                 @"userAuthType"       : type,
                                 @"equitNo"    : [[Config sharedConfig] getRegistrationID],
                                @"osType"      : @"1",
                                @"backLogin"   : @"0"};
        __weak __typeof(&*self)weakSelf = self;
    [manager POST:urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSString *state = [responseObject objectForKey:@"state"];
        if ([state isEqualToString:@"20001"]) {
            _user._id = [responseObject objectForKey:@"userId"];
            [_user getUserInfo];
            [_user saveToNSUserDefaults];//保存登入信息
            
            [weakSelf EaseMobLoginWithUsername:[responseObject objectForKey:@"userId"]];//IM登入
            
        }else if ([state isEqualToString:@"10001"]){
            
            [self hideHud];
            [self performSegueWithIdentifier:@"chooseSchool" sender:nil];
            
        }else if ([state isEqualToString:@"30001"]){
            
        }else{
            
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [weakSelf showResultWithType:ResultError];

    }];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"chooseSchool"])
    {
        ChooseSchoolViewController *controller=(ChooseSchoolViewController *)(segue.destinationViewController);;
        controller.user = _user;
    }
}


-(void)EaseMobLoginWithUsername:(NSString *)username{
    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:username
                                                        password:@"123456"
                                                      completion:
     ^(NSDictionary *loginInfo, EMError *error) {

         if (loginInfo && !error) {
            NSLog(@"IM登入成功");
            [self showResultWithType:ResultSuccess];
            [[Config sharedConfig] changeLoginState:@"1"];
             [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@YES];

//             [self moveToUpSide];

         }else {
             [self hideHud];
             switch (error.errorCode) {
                 case EMErrorServerNotReachable:
                     [HDTool ToastNotification:@"连接服务器失败!" andView:self.view andLoading:NO andIsBottom:NO];
                     break;
                 case EMErrorServerAuthenticationFailure:
                     [HDTool ToastNotification:@"用户名或密码错误" andView:self.view andLoading:NO andIsBottom:NO];
                     break;
                 case EMErrorServerTimeout:
                     [HDTool ToastNotification:@"连接服务器超时!" andView:self.view andLoading:NO andIsBottom:NO];
                     break;
                 default:
                     [HDTool ToastNotification:@"登录失败" andView:self.view andLoading:NO andIsBottom:NO];
                     break;
             }
         }
     } onQueue:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

-(void)dealloc{

    [[NSNotificationCenter defaultCenter] removeObserver:self name:KNOTIFICATION_LOGINCHANGE object:nil];
}

@end
