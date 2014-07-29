//
//  LoginViewController.m
//  FindMe
//
//  Created by mac on 14-7-27.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "LoginViewController.h"
#import "AFNetworking.h"
#import "User.h"
#import "EaseMob.h"
@interface LoginViewController ()<UIScrollViewDelegate>{
    NSArray *_photoList;
    User *_user;
}

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
}
- (IBAction)loginPressed:(UIButton *)sender {
    [self showHudInView:self.view.window hint:@"请稍后..."];
    ShareType type = ShareTypeSinaWeibo;
    NSString * sendType;
    if (sender.tag==101) {
        type = ShareTypeSinaWeibo;
        sendType = @"SinaWeibo";
    } else if(sender.tag==100){
        type = ShareTypeQQSpace;
        sendType = @"QZone";
    }else{
        return;
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

- (void)initUser:(id<ISSPlatformUser>) userInfo AndSendType:(NSString *) sendType{
    _user = [[User alloc] init];
    _user.openId = [userInfo uid];
    _user.userNickName = [userInfo nickname];
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
            _user._id = [responseObject objectForKey:@"userId"];
            
            [_user getUserInfo:^{
                [_user saveToNSUserDefaults];//保存登入信息
            }];
            [[Config sharedConfig] changeLoginState:@"1"];
            [weakSelf EaseMobLoginWithUsername:_user._id];//IM登入
            
        }else if ([state isEqualToString:@"10001"]){
            [weakSelf hideHud];
            [weakSelf performSegueWithIdentifier:@"chooseSchool" sender:nil];
        }else{
            [weakSelf hideHud];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [weakSelf showResultWithType:ResultError];
        
    }];
}

-(void)EaseMobLoginWithUsername:(NSString *)username{
    __weak __typeof(&*self)weakSelf = self;
    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:username
                                                        password:@"123456"
                                                      completion:
     ^(NSDictionary *loginInfo, EMError *error) {
         
         if (loginInfo && !error) {
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
             
         }
     } onQueue:nil];
}

-(void)setupScrollView{
    _photoList = @[[UIImage imageNamed:@"int1"],[UIImage imageNamed:@"int2"],[UIImage imageNamed:@"int3"],[UIImage imageNamed:@"int4"]];
    NSInteger pageCount = [_photoList count];
    _pageControl.currentPage = 0;
    _pageControl.numberOfPages = pageCount;
    
    
    _srollView.delegate = self;
    for(NSInteger i=0;i<pageCount;i++)
    {
        CGRect frame;
        frame.origin.x = _srollView.frame.size.width * i;
        frame.origin.y = 0;
        frame.size = _srollView.frame.size;
        UIImageView *pageView = [[UIImageView alloc] initWithImage:[_photoList objectAtIndex:i]];
        pageView.contentMode = UIViewContentModeScaleAspectFill;
        pageView.frame = frame;
        [_srollView addSubview:pageView];
    }
    CGSize pageScrollViewSize = _srollView.frame.size;
    _srollView.contentSize = CGSizeMake(pageScrollViewSize.width * _photoList.count, 0);
}
- (IBAction)valueChange:(id)sender {
    // 更新Scroll View到正确的页面
    CGRect frame;
    frame.origin.x = _srollView.frame.size.width * _pageControl.currentPage;
    frame.origin.y = 0;
    frame.size = _srollView.frame.size;
    [_srollView scrollRectToVisible:frame animated:YES];
}
- (void)moveToUpSide {
    [UIView animateWithDuration:0.7 //速度0.7秒
                     animations:^{//修改rView坐标
                         self.view.frame = CGRectMake(self.view.frame.origin.x,
                                                 -self.view.frame.size.height-64,
                                                 self.view.frame.size.width,
                                                 self.view.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         [self.view removeFromSuperview];
                     }];
    
}

#pragma delegate
-(void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = _srollView.frame.size.width;
    // 在滚动超过页面宽度的50%的时候，切换到新的页面
    int page = floor((_srollView.contentOffset.x + pageWidth/2)/pageWidth) ;
    _pageControl.currentPage = page;
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
