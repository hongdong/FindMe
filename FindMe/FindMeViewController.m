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
#import "FansViewController.h"
#import "UIView+Common.h"
@interface FindMeViewController ()<CoverViewDelegate>{
    User *_user;
    User *_matchUser;
    LoginView *_loginView;
    CoverView *_coverView;
    BBBadgeBarButtonItem *_fansItem;
    UIButton *_fansButton;
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
        _coverView.delegate = self;
        _fansButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        [_fansButton addTarget:self action:@selector(fansButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_fansButton setImage:[UIImage imageNamed:@"fans"] forState:UIControlStateNormal];
        _fansItem = [[BBBadgeBarButtonItem alloc] initWithCustomUIButton:_fansButton];
        _fansItem.badgeOriginX = 10;
        _fansItem.badgeOriginY = -9;
        if ([[Config sharedConfig] isLogin]) {
            _user = [User getUserFromNSUserDefaults];
        }else{
            NSLog(@"未登入，显示登入界面");
            _loginView = [HDTool loadCustomViewByIndex:1];
            _loginView.delegate = self;
        }
        

        
    }
    return self;
}

- (UILabel *)buildLabelWithText:(NSString *)text {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, 200, 300)];
    label.tag = 1000;
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
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(matchTime:)
                                                 name:MatchTime
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fansNew:) name:FansNew object:nil];
    
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

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (_focusView.isFocused) {
        [_focusView dismiss:nil];
    }
}

-(void)fansButtonPressed:(id)sender{
    if (![[Config sharedConfig] isOnline]) {
        [self showHint:@"你还没登入"];
        return;
    }else if ([[Config sharedConfig] launchGuide:nil]&&_focusView.isFocused){
        [_focusView dismiss:^{
//            [[Config sharedConfig] launchGuide:@"0"];
        }];
        return;
    }else if (![_user.userSex isEqualToString:@"女"]){
        [self showHint:@"目前只有女生开通了粉丝服务"];
        return;
    }
    [self performSegueWithIdentifier:@"fans" sender:_fansItem];
}

-(void)launchGuide:(UIView *)view andText:(NSString *)text{
    ((UILabel *)[_focusView viewWithTag:1000]).text = text;
    [_focusView focus:view,nil];
}

- (IBAction)likePressed:(id)sender {
    __weak __typeof(&*self)weakSelf = self;
    if ([[Config sharedConfig] launchGuide:nil]&&_focusView.isFocused) {
        [_focusView dismiss:^{
            [weakSelf launchGuide:weakSelf.passBt andText:@"你点击了pass后你将会看到番迷君给你推荐的下一个人。"];
        }];
        return;
    }
    [self showCover];
    NSString *urlStr = [NSString stringWithFormat:@"%@/data/user/like_user.do",Host];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"type":@"1",@"likeUserId": _matchUser._id};

    [manager GET:urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [[Config sharedConfig] matchNew:@"0"];
        weakSelf.navigationController.tabBarItem.badgeValue = nil;
        NSString *state = [responseObject objectForKey:@"state"];
        if ([state isEqualToString:@"20001"]) {
            if ([_user.userSex isEqualToString:@"男"]) {
                [weakSelf getMatch:nil];
            }else if ([_user.userSex isEqualToString:@"女"]){
                [weakSelf showHint:@"番迷君知道该怎么做了"];
            }else{
                
            }
        }else if ([state isEqualToString:@"20002"]){
            [[NSNotificationCenter defaultCenter] postNotificationName:FriendChange object:nil];
            if ([_user.userSex isEqualToString:@"男"]) {
                [weakSelf showHint:@"番迷君得知她喜欢你已久"];
                [weakSelf getMatch:nil];
            }else if ([_user.userSex isEqualToString:@"女"]){
                [weakSelf showHint:@"番迷君得知他喜欢你已久"];
            }else{
                
            }
        }else{
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [weakSelf showHint:@"错误"];
    }];
}
- (IBAction)passPressed:(id)sender {
        __weak __typeof(&*self)weakSelf = self;
    if ([[Config sharedConfig] launchGuide:nil]&&_focusView.isFocused) {
        [_focusView dismiss:^{
            [weakSelf launchGuide:_fansButton andText:@"你还会拥有你自己的粉丝，让番迷君给你找到更适合的人。"];
        }];
        return;
    }
    [self showCover];
    [self getMatch:_matchUser._id];
}

-(void)hideCover{
        __weak __typeof(&*self)weakSelf = self;
    [UIView animateWithDuration:0.7 //速度0.7秒
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{//修改rView坐标
                         _coverView.frame = CGRectMake(_coverView.frame.origin.x,
                                                       -_coverView.frame.size.height-64,
                                                       _coverView.frame.size.width,
                                                       _coverView.frame.size.height);
                     }
                     completion:^(BOOL finished){
//                                 [_coverView removeFromSuperview];
                         if (finished==YES&&[[Config sharedConfig] launchGuide:nil]) {
                             _focusView = [MDCFocusView new];
                             _focusView.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.8f];
                             _focusView.focalPointViewClass = [MDCSpotlightView class];
                             [_focusView addSubview:[self buildLabelWithText:@"番迷君每天至多给你推荐三个有缘人，当你点击了like后就看不到下一个人了。"]];
                             [_focusView focus:weakSelf.likeBt,nil];
                         }
                     }];
    

}
-(void)showCover{

    [UIView animateWithDuration:0.7 //速度0.7秒
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{//修改rView坐标
                         _coverView.frame = CGRectMake(_coverView.frame.origin.x,
                                                       0,
                                                       _coverView.frame.size.width,
                                                       _coverView.frame.size.height);
                     }
                     completion:^(BOOL finished){

                     }];
}

-(void)getMatch:(NSString *)userMatchId{

    NSString *urlStr = [NSString stringWithFormat:@"%@/data/user/match_info.do",Host];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    NSMutableDictionary *parameters = [@{@"type": @"1"} mutableCopy];
    if (userMatchId!=nil) {
        [parameters setValue:userMatchId forKey:@"userMatchId"];
    }
    __weak __typeof(&*self)weakSelf = self;
    [manager GET:urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *userMatch = [responseObject objectForKey:@"userMatch"];
        NSDictionary *userDic = [userMatch objectForKey:@"user"];
        if (userDic!=nil) {
        _matchUser = [User objectWithKeyValues:userDic];
            [weakSelf setMatchPeople];
            [weakSelf hideCover];
        }else{
//            [self showHint:@"今天没了"];
            if ([[Config sharedConfig] matchNew:nil]) {
                [[Config sharedConfig] matchNew:@"0"];
                weakSelf.navigationController.tabBarItem.badgeValue = nil;
            }
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"请求失败");
    }];
}

-(void)setMatchPeople{
    if (_matchUser!=nil) {
        [self.photo sd_setImageWithURL:[NSURL URLWithString:_matchUser.userPhoto] placeholderImage:[UIImage imageNamed:@"defaultImage"]];
        CGSize size = CGSizeMake(320,2000);
        CGSize realsize = [_matchUser.userNickName sizeWithFont:[UIFont systemFontOfSize:16.0f] constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
        self.nickname.bounds = (CGRect){{0,0},realsize};
        self.nickname.center = CGPointMake(0.5*self.view.width, self.nickname.center.y);
        
        
        self.nickname.text = _matchUser.userNickName;
        self.grade.text = _matchUser.userGrade;
        
        self.sex.center = CGPointMake(self.nickname.left-20, self.sex.center.y);
        
        if ([_matchUser.userSex isEqualToString:@"男"]) {
            self.sex.image = [UIImage imageNamed:@"boy"];
        }else{
            self.sex.image = [UIImage imageNamed:@"girl"];
        }
        self.xzLbl.frame = CGRectMake(self.nickname.right+2, self.xzLbl.y, self.xzLbl.width, self.xzLbl.height);
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

-(void)fansNew:(NSNotification *)notification{
    _fansItem.badgeValue = @"N";
}

-(void)loginStateChange:(NSNotification *)notification{
//    NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
//    BOOL isLogin1 = loginInfo && [loginInfo count] > 0;
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
        if (_loginView==nil) {
            _loginView = [HDTool loadCustomViewByIndex:1];
            _loginView.delegate = self;
        }
        _loginView.frame = CGRectMake(0, 0, 320, 455);
        [self.view addSubview:_loginView];
    }
}

-(void)matchTime:(NSNotification *)note{
    [self getMatch:nil];
}


#pragma loginViewDelegate
- (void)login:(UIButton *)sender{
    [self showHudInView:self.view.window hint:@"请稍后..."];
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
                                                         allowCallback:NO
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
            [weakSelf EaseMobLoginWithUsername:_user._id];//IM登入
            
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
    }else if ([segue.identifier isEqualToString:@"fans"]){
        FansViewController *controller = segue.destinationViewController;
        controller.fansItem = sender;
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
             [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
             
            EMPushNotificationOptions *options = [[EaseMob sharedInstance].chatManager pushNotificationOptions];
            options.displayStyle = ePushNotificationDisplayStyle_messageSummary;
             options.nickname = _user.userNickName;
             [[EaseMob sharedInstance].chatManager asyncUpdatePushOptions:options];
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

#pragma delegate
-(void)coverViewRefreshPressed{
    [self getMatch:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

-(void)dealloc{

    [[NSNotificationCenter defaultCenter] removeObserver:self name:KNOTIFICATION_LOGINCHANGE object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UserInfoChange object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EaseMobShouldLogin object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MatchTime object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:FansNew object:nil];
    
}

@end
