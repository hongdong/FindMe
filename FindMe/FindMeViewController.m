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
#import "JMWhenTapped.h"
#import "UIImageView+WebCache.h"
#import "FindMeDetailViewController.h"
#import "CoverView.h"
#import "BBBadgeBarButtonItem.h"
#import "MDCFocusView.h"
#import "MDCSpotlightView.h"
@interface FindMeViewController (){
    User *_user;
    User *_matchUser;
    LoginView *_loginView;
    CoverView *_coverView;
    BBBadgeBarButtonItem *_fansItem;
    MDCFocusView *_focusView;
}

@end

@implementation FindMeViewController



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _coverView = [HDTool loadCustomViewByIndex:4];
        UIButton *fansButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        [fansButton addTarget:self action:@selector(fansButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [fansButton setImage:[UIImage imageNamed:@"postMessage"] forState:UIControlStateNormal];
        _fansItem = [[BBBadgeBarButtonItem alloc] initWithCustomUIButton:fansButton];
        _fansItem.badgeValue = @"2";
        _fansItem.badgeOriginX = 10;
        _fansItem.badgeOriginY = -9;
        if ([[Config sharedConfig] isLogin]) {
            _user = [User getUserFromNSUserDefaults];
        }else{
            NSLog(@"未登入，显示登入界面");
            _loginView = [HDTool loadCustomViewByIndex:1];
            _loginView.delegate = self;
        }
        
        if ([HDTool isFirstLoad]) {
            _focusView = [MDCFocusView new];
            _focusView.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.8f];
            _focusView.focalPointViewClass = [MDCSpotlightView class];
            [_focusView addSubview:[self buildLabelWithText:@"番迷君每天至多给你推荐三个有缘人，当你点击了pass后就能看到下一个人，切记不能回头。"]];
        }
    }
    return self;
}

- (UILabel *)buildLabelWithText:(NSString *)text {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, 200, 300)];
    label.numberOfLines = 10;
    label.font = [UIFont boldSystemFontOfSize:16.0f];
    label.shadowColor = [UIColor grayColor];
    label.shadowOffset = CGSizeMake(0, 1);
    label.text = text;
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    
    return label;
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
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userChange:)
                                                 name:UserInfoChange
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(easeMobShouldLogin:)
                                                 name:EaseMobShouldLogin
                                               object:nil];
    
    self.photo.layer.cornerRadius = 75.0f;
    self.photo.layer.masksToBounds = YES;
    __weak __typeof(&*self)weakSelf = self;

    [self.photo whenTouchedDown:^{
        [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                        weakSelf.photo.transform = CGAffineTransformMakeScale(0.8f, 0.8f);
        } completion:nil];
    }];
    
    [self.photo whenTouchedUp:^{
        [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            weakSelf.photo.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        } completion:nil];
        [self performSegueWithIdentifier:@"findmeDetail" sender:_matchUser];
    }];
    
    [self.view addSubview:_coverView];
    self.navigationItem.rightBarButtonItem = _fansItem;
    
    if (_loginView!=nil) {
        [self.view addSubview:_loginView];
    }else{
        if ([[Config sharedConfig] isOnline]) {
            [self getMatch:nil];
        }else{
            NSLog(@"还在登入中");
        }
    }

}

-(void)fansButtonPressed:(id)sender{
    if (![[Config sharedConfig] isOnline]) {
        [self showHint:@"你还没登入"];
        return;
    }else if (![_user.userSex isEqualToString:@"女"]){
        [self showHint:@"目前只有女生开通了粉丝服务"];
        return;
    }
    [self performSegueWithIdentifier:@"fans" sender:nil];
}
- (IBAction)likePressed:(id)sender {
    [self showCover];
    NSString *urlStr = [NSString stringWithFormat:@"%@/data/user/like_user.do",Host];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"type":@"1",@"likeUserId": _matchUser._id};
    [manager GET:urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *state = [responseObject objectForKey:@"state"];
        if ([state isEqualToString:@"20001"]) {
            NSLog(@"LIKE成功");
        }else if ([state isEqualToString:@"20002"]){
            NSLog(@"你们已经成为朋友了");
        }else{
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"请求失败");
    }];
}
- (IBAction)passPressed:(id)sender {
    [self showCover];
    [self getMatch:_matchUser._id];
}

-(void)hideCover{
    [UIView animateWithDuration:0.7 //速度0.7秒
                     animations:^{//修改rView坐标
                         _coverView.frame = CGRectMake(_coverView.frame.origin.x,
                                                       -_coverView.frame.size.height-64,
                                                       _coverView.frame.size.width,
                                                       _coverView.frame.size.height);
                     }
                     completion:^(BOOL finished){
//                                 [_coverView removeFromSuperview];
                     }];
}
-(void)showCover{
    [UIView animateWithDuration:0.7 //速度0.7秒
                     animations:^{//修改rView坐标
                         _coverView.frame = CGRectMake(_coverView.frame.origin.x,
                                                       0,
                                                       _coverView.frame.size.width,
                                                       _coverView.frame.size.height);
                     }
                     completion:^(BOOL finished){
//                                 [_coverView removeFromSuperview];
                     }];
}

-(void)getMatch:(NSString *)userMatchId{
//    //现实心灵鸡汤
//    UIView *view = [HDTool loadCustomViewByIndex:4];
//    [self.view addSubview:view];
    NSString *urlStr = [NSString stringWithFormat:@"%@/data/user/match_info.do",Host];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    NSMutableDictionary *parameters = [@{@"type": @"1"} mutableCopy];
    if (userMatchId!=nil) {
        [parameters setValue:userMatchId forKey:@"userMatchId"];
    }
    __weak __typeof(&*self)weakSelf = self;
    [manager GET:urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *userMatch = [responseObject objectForKey:@"userMatch"];
        if (userMatch!=nil&&userMatch.count!=0) {
        _matchUser = [User objectWithKeyValues:userMatch];
            [weakSelf setMatchPeople];
            
                //隐藏心灵鸡汤
            [weakSelf hideCover];
        }else{
            NSLog(@"今天没了");
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"请求失败");
    }];
}

-(void)setMatchPeople{
    if (_matchUser!=nil) {
        [self.photo sd_setImageWithURL:[NSURL URLWithString:_matchUser.userPhoto] placeholderImage:[UIImage imageNamed:@"defaultImage"]];
        self.nickname.text = _matchUser.userNickName;
        self.grade.text = _matchUser.userGrade;
        if ([_matchUser.userSex isEqualToString:@"男"]) {
            self.sex.image = [UIImage imageNamed:@"boy"];
        }else{
            self.sex.image = [UIImage imageNamed:@"girl"];
        }
        self.xzLbl.text = _matchUser.userConstellation;
        self.schoolLbl.text = [_matchUser getSchoolName];
        self.departmentLbl.text = [_matchUser getDepartmentName];
        self.qianmingLbl.text = _matchUser.userSignature;
        if ([_matchUser.userAuth intValue]==1) {
            self.xzimg.hidden = NO;
        }
    }

    
}

-(void)easeMobShouldLogin:(NSNotification *)notification{
    if ([notification.userInfo objectForKey:@"_id"]!=nil) {
        [self showHudInView:[UIApplication sharedApplication].keyWindow hint:@"登入中..."];
        [self EaseMobLoginWithUsername:[notification.userInfo objectForKey:@"_id"]];
    }

}
-(void)userChange:(NSNotification *)notification{
    _user = [User getUserFromNSUserDefaults];
}
-(void)loginStateChange:(NSNotification *)notification{
//    NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
//    BOOL isLogin = loginInfo && [loginInfo count] > 0;
//    if (notification.object) {
//        isLogin = [notification.object boolValue] && isLogin;
//    }
    BOOL isLogin = [notification.object boolValue];
    if (isLogin) {
        if (_loginView!=nil) {
            [_loginView moveToUpSide];
        }
        [self getMatch:nil];
    }
    else{

    }
}



#pragma loginViewDelegate
- (void)login:(UIButton *)sender{
    [self showHudInView:self.view.window hint:@"登入中..."];
    ShareType type = ShareTypeSinaWeibo;
    NSString * sendType;
    if (sender.tag==101) {
        type = ShareTypeSinaWeibo;
        sendType = @"SinaWeibo";
    } else {
        type = ShareTypeQQSpace;
        sendType = @"QZone";
    }
        __weak __typeof(&*self)weakSelf = self;
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

    [ShareSDK getUserInfoWithType:type
                      authOptions:authOptions
                           result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
                               
                               
                               if (result) {

                                   [weakSelf initUser:userInfo AndSendType:sendType];
                                   
                                   [weakSelf isOauth:[userInfo uid] forType:sendType andBack:@"0"];
                                   
                               }else{
                                   [weakSelf hideHud];
                               }
                               
                           }];
}



#pragma ShareSDKDelete
- (void)viewOnWillDisplay:(UIViewController *)viewController shareType:(ShareType)shareType{
    [self hideHud];
}
- (void)viewOnWillDismiss:(UIViewController *)viewController shareType:(ShareType)shareType{
    [self showHudInView:[UIApplication sharedApplication].keyWindow hint:@"登入中..."];
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
    _user.userAuthType = sendType;
    
}

- (void)isOauth:(NSString *) uid forType:(NSString *) type andBack:(NSString *) back{
    NSString *urlStr = [NSString stringWithFormat:@"%@/data/user/grant_user.do",Host];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"userOpenId"     : uid,
                                 @"userAuthType"       : type,
                                 @"equitNo"    : [[Config sharedConfig] getRegistrationID],
                                @"osType"      : @"1",
                                @"backLogin"   : back};
        __weak __typeof(&*self)weakSelf = self;
    [manager POST:urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSString *state = [responseObject objectForKey:@"state"];
        if ([state isEqualToString:@"20001"]) {
            NSLog(@"登入成功");
            _user._id = [responseObject objectForKey:@"userId"];
            
            [_user getUserInfo:^{
                [_user saveToNSUserDefaults];//保存登入信息
            }];
            
            [[Config sharedConfig] changeLoginState:@"1"];
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
    }else if ([segue.identifier isEqualToString:@"findmeDetail"]) {
        FindMeDetailViewController *controller = segue.destinationViewController;
        controller.user = sender;
    }
}


-(void)EaseMobLoginWithUsername:(NSString *)username{
    __weak __typeof(&*self)weakSelf = self;
    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:username
                                                        password:@"123456"
                                                      completion:
     ^(NSDictionary *loginInfo, EMError *error) {

         if (loginInfo && !error) {
            NSLog(@"IM登入成功");
            [weakSelf showResultWithType:ResultSuccess];
             [[Config sharedConfig] changeOnlineState:@"1"];
             [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@YES];
         }else {
             [weakSelf hideHud];
            NSLog(@"%u",error.errorCode);
             NSLog(@"%@",error.description);
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
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NSUserDefaultsUserChange" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"EaseMobShouldLogin" object:nil];
    
}

@end
