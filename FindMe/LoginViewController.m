//
//  LoginViewController.m
//  FindMe
//
//  Created by mac on 14-8-8.
//  Copyright (c) 2014年 mac. All rights reserved.
//
#import <ShareSDK/ShareSDK.h>
#import "LoginViewController.h"
#import "ChooseSchoolViewController.h"
#import "User.h"
@interface LoginViewController (){
    User *_user;
}

@end

@implementation LoginViewController

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
    [self setupScrollView];
}
-(void)setupScrollView{
    NSArray *_photoList = @[[UIImage imageNamed:@"int1"],[UIImage imageNamed:@"int2"],[UIImage imageNamed:@"int3"],[UIImage imageNamed:@"int4"]];
    NSInteger pageCount = [_photoList count];
    _pageControl.currentPage = 0;
    _pageControl.numberOfPages = pageCount;
    for(NSInteger i=0;i<pageCount;i++)
    {
        CGRect frame;
        frame.origin.x = _scrollView.frame.size.width * i;
        frame.origin.y = 0;
        frame.size = _scrollView.frame.size;
        UIImageView *pageView = [[UIImageView alloc] initWithImage:[_photoList objectAtIndex:i]];
        pageView.contentMode = UIViewContentModeScaleAspectFill;
        pageView.frame = frame;
        [_scrollView addSubview:pageView];
    }
    CGSize pageScrollViewSize = _scrollView.frame.size;
    _scrollView.contentSize = CGSizeMake(pageScrollViewSize.width * _photoList.count, 0);
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}
- (IBAction)valueChanged:(id)sender {
    // 更新Scroll View到正确的页面
    CGRect frame;
    frame.origin.x = _scrollView.frame.size.width * _pageControl.currentPage;
    frame.origin.y = 0;
    frame.size = _scrollView.frame.size;
    [_scrollView scrollRectToVisible:frame animated:YES];
}

- (IBAction)loginPressed:(UIButton *)sender {
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
                                                          viewDelegate:nil
                                               authManagerViewDelegate:nil];
    
    [ShareSDK authWithType:type options:authOptions result:^(SSAuthState state, id<ICMErrorInfo> error) {
        switch (state) {
            case SSAuthStateBegan:
                MJLog(@"SSAuthStateBegan");
                break;
            case SSAuthStateSuccess:{
                MJLog(@"SSAuthStateSuccess");
                [HDTool showHUD:@"请稍后..."];
                
                [ShareSDK getUserInfoWithType:type
                                  authOptions:authOptions
                                       result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
                                           if (result) {
                                               
                                               [weakSelf initUser:userInfo AndSendType:sendType];
                                               
                                               [HDNet isOauth:[userInfo uid] forType:sendType andBack:@"0" handle:^(id responseObject, NSError *error) {
                                                   if (responseObject==nil) {
                                                       [HDTool errorHUD];
                                                       return;
                                                   }
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
//                                                       [[NSNotificationCenter defaultCenter] postNotificationName:FriendChange object:nil];
                                                       [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@YES userInfo:@{@"isBack": @"0"}];
                                                       [HDNet EaseMobLoginWithUsername:_user._id];//IM登入
                                                       
                                                   }else if ([state isEqualToString:@"10001"]){
                                                       
                                                       [HDTool dismissHUD];
                                                       if (_delegate && [_delegate respondsToSelector:@selector(shouldShowChooseSchool:)]) {
                                                           [_delegate shouldShowChooseSchool:_user];
                                                       }
                                                       
                                                   }else{
                                                       [HDTool errorHUD];
                                                   }
                                                   
                                               }];
                                               
                                           }else{
                                               
                                               [HDTool dismissHUD];
                                               
                                               [HDTool ToastNotification:@"网络太糟糕了" andView:weakSelf.view andLoading:NO andIsBottom:NO];
                                           }
                                           
                                       }];
            }
                break;
            case SSAuthStateFail:
                MJLog(@"SSAuthStateFail");
                break;
            case SSAuthStateCancel:
                MJLog(@"SSAuthStateCancel");
                break;
            default:
                break;
        }
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

- (void)initUser:(id<ISSPlatformUser>) userInfo AndSendType:(NSString *) sendType{
    _user = [[User alloc] init];
    _user.openId = [userInfo uid];
    _user.userNickName = [userInfo nickname];
    _user.userAuthType = sendType;
    
}



#pragma delegate
-(void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = _scrollView.frame.size.width;
    // 在滚动超过页面宽度的50%的时候，切换到新的页面
    int page = floor((_scrollView.contentOffset.x + pageWidth/2)/pageWidth);
    _pageControl.currentPage = page;
    
}
@end
