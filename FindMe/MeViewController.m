//
//  MeViewController.m
//  FindMe
//
//  Created by mac on 14-7-4.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "MeViewController.h"
#import "User.h"
#import "UIImageView+WebCache.h"
#import "JMWhenTapped.h"
#import <AGCommon/UINavigationBar+Common.h>
#import <AGCommon/NSString+Common.h>
#import "UIView+Common.h"
@interface MeViewController (){
    User *_user;
}

@end

@implementation MeViewController

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

    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userInfoUpdate:) name:UserInfoChange object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginChange:) name:KNOTIFICATION_LOGINCHANGE object:nil];
    self.title = @"我的";
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"meTitleView"]];
    if (![[Config sharedConfig] isLogin]) {
        [self.view addSubview:[HDTool loadCustomViewByIndex:6]];
        return;
    }
    [self setup];
}


-(void)loginChange:(NSNotification *)notification{

    BOOL isLogin = [notification.object boolValue];
    if (isLogin) {
        [[self.view viewWithTag:100] removeFromSuperview];
        [self setup];
    }
    else{
        [self.view addSubview:[HDTool loadCustomViewByIndex:6]];
 }
}

-(void)setup{
    _user = [User getUserFromNSUserDefaults];
    self.photo.layer.cornerRadius = 25.0f;
    self.photo.layer.masksToBounds = YES;
    [self setData];
    
    
    __weak __typeof(&*self)weakSelf = self;
    [self.detailView whenTouchedDown:^{
        weakSelf.detailView.backgroundColor = [UIColor lightGrayColor];
    }];
    [self.detailView whenTouchedUp:^{
        weakSelf.detailView.backgroundColor = [UIColor whiteColor];
        [self performSegueWithIdentifier:@"editInfo" sender:nil];
    }];
    
    [self.photoWallView whenTouchedDown:^{
        weakSelf.photoWallView.backgroundColor = [UIColor lightGrayColor];
    }];
    [self.photoWallView whenTouchedUp:^{
        weakSelf.photoWallView.backgroundColor = [UIColor whiteColor];
        [weakSelf performSegueWithIdentifier:@"album" sender:nil];
    }];
    
    [self.addVView whenTouchedDown:^{
        weakSelf.addVView.backgroundColor = [UIColor lightGrayColor];
    }];
    [self.addVView whenTouchedUp:^{
        weakSelf.addVView.backgroundColor = [UIColor whiteColor];
        if ([_user.userAuth intValue]==1) {
            [weakSelf showHint:@"你已经认证过了"];
            return;
        }
        [weakSelf performSegueWithIdentifier:@"attestation" sender:nil];
    }];
    
    [self.shareView whenTouchedDown:^{
        weakSelf.shareView.backgroundColor = [UIColor lightGrayColor];
    }];
    [self.shareView whenTouchedUp:^{
        weakSelf.shareView.backgroundColor = [UIColor whiteColor];
        [self showShare];
    }];
    
    [self.settingView whenTouchedDown:^{
        weakSelf.settingView.backgroundColor = [UIColor lightGrayColor];
    }];
    [self.settingView whenTouchedUp:^{
        weakSelf.settingView.backgroundColor = [UIColor whiteColor];
        [weakSelf performSegueWithIdentifier:@"setting" sender:nil];
    }];
}

-(void)setData{

    [self.photo sd_setImageWithURL:[NSURL URLWithString:_user.userPhoto] placeholderImage:[UIImage imageNamed:@"defaultImage"]];
    self.nickname.text = _user.userNickName;
    CGSize size = CGSizeMake(320,2000);
    CGSize realsize = [_user.userNickName sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    self.nickname.frame = CGRectMake(self.nickname.frame.origin.x, self.nickname.frame.origin.y, realsize.width, realsize.height);
    
    self.sex.frame = CGRectMake(self.nickname.right + 5, self.sex.top, self.sex.width, self.sex.height);
    if ([_user.userSex isEqualToString:@"男"]) {
        self.sex.image = [UIImage imageNamed:@"boy"];
    }
    
    self.vUserImg.frame = CGRectMake(self.sex.right+5, self.vUserImg.top, self.vUserImg.width, self.vUserImg.height);
    
    self.qianming.text = _user.userSignature;
    
    if ([_user.userAuth intValue]==1) {
        self.addVView.userInteractionEnabled = NO;
        self.isAuthBt.hidden = NO;
        self.vUserImg.hidden = NO;
    }
}
-(void)userInfoUpdate:(NSNotification *)note{
    _user = [User getUserFromNSUserDefaults];
    [self setData];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UserInfoChange object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KNOTIFICATION_LOGINCHANGE object:nil];
}
-(void)showShare{
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"findme" ofType:@"png"];
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:@"我一直在寻找，油腻的师姐在哪里"
                                       defaultContent:@""
                                                image:[ShareSDK imageWithPath:imagePath]
                                                title:@"番迷"
                                                  url:@"http://www.ifanmi.cn"
                                          description:NSLocalizedString(@"TEXT_TEST_MSG", @"这是一条测试信息")
                                            mediaType:SSPublishContentMediaTypeNews];
    
    ///////////////////////
    //以下信息为特定平台需要定义分享内容，如果不需要可省略下面的添加方法
    
    
    
    //定制QQ空间信息
    [publishContent addQQSpaceUnitWithTitle:NSLocalizedString(@"TEXT_HELLO_QZONE", @"Hello QQ空间")
                                        url:INHERIT_VALUE
                                       site:nil
                                    fromUrl:nil
                                    comment:INHERIT_VALUE
                                    summary:INHERIT_VALUE
                                      image:INHERIT_VALUE
                                       type:INHERIT_VALUE
                                    playUrl:nil
                                       nswb:nil];
    
    //定制微信好友信息
    [publishContent addWeixinSessionUnitWithType:INHERIT_VALUE
                                         content:INHERIT_VALUE
                                           title:NSLocalizedString(@"TEXT_HELLO_WECHAT_SESSION", @"Hello 微信好友!")
                                             url:INHERIT_VALUE
                                      thumbImage:[ShareSDK imageWithUrl:@"http://img1.bdstatic.com/img/image/67037d3d539b6003af38f5c4c4f372ac65c1038b63f.jpg"]
                                           image:INHERIT_VALUE
                                    musicFileUrl:nil
                                         extInfo:nil
                                        fileData:nil
                                    emoticonData:nil];
    
    //定制微信朋友圈信息
    [publishContent addWeixinTimelineUnitWithType:[NSNumber numberWithInteger:SSPublishContentMediaTypeMusic]
                                          content:INHERIT_VALUE
                                            title:NSLocalizedString(@"TEXT_HELLO_WECHAT_TIMELINE", @"Hello 微信朋友圈!")
                                              url:@"http://y.qq.com/i/song.html#p=7B22736F6E675F4E616D65223A22E4BDA0E4B88DE698AFE79C9FE6ADA3E79A84E5BFABE4B990222C22736F6E675F5761704C69766555524C223A22687474703A2F2F74736D7573696332342E74632E71712E636F6D2F586B303051563558484A645574315070536F4B7458796931667443755A68646C2F316F5A4465637734356375386355672B474B304964794E6A3770633447524A574C48795333383D2F3634363232332E6D34613F7569643D32333230303738313038266469723D423226663D312663743D3026636869643D222C22736F6E675F5769666955524C223A22687474703A2F2F73747265616D31382E71716D757369632E71712E636F6D2F33303634363232332E6D7033222C226E657454797065223A2277696669222C22736F6E675F416C62756D223A22E5889BE980A0EFBC9AE5B08FE5B7A8E89B8B444E414C495645EFBC81E6BC94E594B1E4BC9AE5889BE7BAAAE5BD95E99FB3222C22736F6E675F4944223A3634363232332C22736F6E675F54797065223A312C22736F6E675F53696E676572223A22E4BA94E69C88E5A4A9222C22736F6E675F576170446F776E4C6F616455524C223A22687474703A2F2F74736D757369633132382E74632E71712E636F6D2F586C464E4D31354C5569396961495674593739786D436534456B5275696879366A702F674B65356E4D6E684178494C73484D6C6A307849634A454B394568572F4E3978464B316368316F37636848323568413D3D2F33303634363232332E6D70333F7569643D32333230303738313038266469723D423226663D302663743D3026636869643D2673747265616D5F706F733D38227D"
                                       thumbImage:[ShareSDK imageWithUrl:@"http://img1.bdstatic.com/img/image/67037d3d539b6003af38f5c4c4f372ac65c1038b63f.jpg"]
                                            image:INHERIT_VALUE
                                     musicFileUrl:@"http://mp3.mwap8.com/destdir/Music/2009/20090601/ZuiXuanMinZuFeng20090601119.mp3"
                                          extInfo:nil
                                         fileData:nil
                                     emoticonData:nil];
    
    
    
    //定制QQ分享信息
    [publishContent addQQUnitWithType:INHERIT_VALUE
                              content:INHERIT_VALUE
                                title:@"Hello QQ!"
                                  url:INHERIT_VALUE
                                image:INHERIT_VALUE];
    
    
    
    
    
    //结束定制信息
    ////////////////////////
    
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:YES
                                                                scopes:nil
                                                         powerByHidden:YES
                                                        followAccounts:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                        [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"洪小东东"],
                                                                        SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
                                                                        nil]
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:nil
                                               authManagerViewDelegate:nil];
    
    
    //自定义新浪微博分享菜单项
    id<ISSShareActionSheetItem> sinaItem = [ShareSDK shareActionSheetItemWithTitle:[ShareSDK getClientNameWithType:ShareTypeSinaWeibo]
                                                                              icon:[ShareSDK getClientIconWithType:ShareTypeSinaWeibo]
                                                                      clickHandler:^{
                                                                          [ShareSDK shareContent:publishContent
                                                                                            type:ShareTypeSinaWeibo
                                                                                     authOptions:authOptions
                                                                                   statusBarTips:NO
                                                                                          result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                                                                              
                                                                                              if (state == SSPublishContentStateSuccess)
                                                                                              {
                                                                                                  NSLog(NSLocalizedString(@"TEXT_SHARE_SUC", @"分享成功"));
                                                                                              }
                                                                                              else if (state == SSPublishContentStateFail)
                                                                                              {
                                                                                                  NSLog(NSLocalizedString(@"TEXT_SHARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
                                                                                              }
                                                                                          }];
                                                                      }];
    
    
    //自定义QQ空间分享菜单项
    id<ISSShareActionSheetItem> qzoneItem = [ShareSDK shareActionSheetItemWithTitle:[ShareSDK getClientNameWithType:ShareTypeQQSpace]
                                                                               icon:[ShareSDK getClientIconWithType:ShareTypeQQSpace]
                                                                       clickHandler:^{
                                                                           [ShareSDK shareContent:publishContent
                                                                                             type:ShareTypeQQSpace
                                                                                      authOptions:authOptions
                                                                                    statusBarTips:YES
                                                                                           result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                                                                               
                                                                                               if (state == SSPublishContentStateSuccess)
                                                                                               {
                                                                                                   NSLog(NSLocalizedString(@"TEXT_SHARE_SUC", @"分享成功"));
                                                                                               }
                                                                                               else if (state == SSPublishContentStateFail)
                                                                                               {
                                                                                                   NSLog(NSLocalizedString(@"TEXT_SHARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
                                                                                               }
                                                                                           }];
                                                                       }];
    
    
    
    
    //创建自定义分享列表
    NSArray *shareList = [ShareSDK customShareListWithType:
                          sinaItem,
                          qzoneItem,
                          SHARE_TYPE_NUMBER(ShareTypeWeixiSession),
                          SHARE_TYPE_NUMBER(ShareTypeWeixiTimeline),
                          SHARE_TYPE_NUMBER(ShareTypeQQ),nil];
    
    [ShareSDK showShareActionSheet:container
                         shareList:shareList
                           content:publishContent
                     statusBarTips:YES
                       authOptions:authOptions
                      shareOptions:[ShareSDK defaultShareOptionsWithTitle:nil
                                                          oneKeyShareList:[NSArray defaultOneKeyShareList]
                                                           qqButtonHidden:NO
                                                    wxSessionButtonHidden:NO
                                                   wxTimelineButtonHidden:NO
                                                     showKeyboardOnAppear:NO
                                                        shareViewDelegate:self
                                                      friendsViewDelegate:self
                                                    picViewerViewDelegate:nil]
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                
                                if (state == SSPublishContentStateSuccess)
                                {
                                    NSLog(NSLocalizedString(@"TEXT_SHARE_SUC", @"发表成功"));
                                }
                                else if (state == SSPublishContentStateFail)
                                {
                                    NSLog(NSLocalizedString(@"TEXT_SHARE_FAI", @"发布失败!error code == %d, error code == %@"), [error errorCode], [error errorDescription]);
                                }
                            }];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}
#pragma mark - ISSShareViewDelegate

- (void)viewOnWillDisplay:(UIViewController *)viewController shareType:(ShareType)shareType
{
    
    if (iOS7)
    {
        UIButton *leftBtn = (UIButton *)viewController.navigationItem.leftBarButtonItem.customView;
        UIButton *rightBtn = (UIButton *)viewController.navigationItem.rightBarButtonItem.customView;
        
        [leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        label.text = viewController.title;
        label.font = [UIFont boldSystemFontOfSize:18];
        [label sizeToFit];
        
        viewController.navigationItem.titleView = label;
        
    }

        if (UIInterfaceOrientationIsLandscape(viewController.interfaceOrientation))
        {
            if (IS_IPHONE_5)
            {
                [viewController.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"iPhoneLandscapeNavigationBarBG-568h.png"]];
            }
            else
            {
                [viewController.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"iPhoneLandscapeNavigationBarBG.png"]];
            }
        }
        else
        {
            [viewController.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"iPhoneNavigationBarBG.png"]];
        }
    
}

- (void)view:(UIViewController *)viewController autorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation shareType:(ShareType)shareType
{

        if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation))
        {
            if (IS_IPHONE_5)
            {
                [viewController.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"iPhoneLandscapeNavigationBarBG-568h.png"]];
            }
            else
            {
                [viewController.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"iPhoneLandscapeNavigationBarBG.png"]];
            }
        }
        else
        {
            [viewController.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"iPhoneNavigationBarBG.png"]];
        }
    
}

@end
