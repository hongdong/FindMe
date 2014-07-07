//
//  AppDelegate.m
//  FindMe
//
//  Created by mac on 14-6-18.
//  Copyright (c) 2014年 ___FULLUSERNAME___. All rights reserved.
//
#import <ShareSDK/ShareSDK.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"
#import "AppDelegate.h"
#import "EaseMob.h"
#import "APService.h"
@implementation AppDelegate


#pragma mark 一个类只会调用一次
+ (void)initialize
{
    // 1.取出设置主题的对象
    UINavigationBar *navBar = [UINavigationBar appearance];
    
    // 2.设置导航栏的背景图片
    NSString *navBarBg = nil;
    if (iOS7) { // iOS7
        navBarBg = @"NavBar64";
        navBar.tintColor = [UIColor whiteColor];
    } else { // 非iOS7
        navBarBg = @"NavBar";
        //[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    }
    [navBar setBackgroundImage:[UIImage imageNamed:navBarBg] forBarMetrics:UIBarMetricsDefault];
    
    // 3.标题
    [navBar setTitleTextAttributes:@{
                                     UITextAttributeTextColor : [UIColor whiteColor]
                                     }];
    
    if ([HDTool isFirstLoad]) {
        NSLog(@"这个版本第一次启动");
        [[Config sharedConfig] initBadge];
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];

    [self initShareSDK];

    [self initEaseMobSDK:application and:launchOptions];
    
    [self initJpushSDK:launchOptions];
    

    [[Config sharedConfig] saveRegistrationID:[APService registrionID]];
    if ([launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey]) {
        //表示用户点击apn 通知导致app被启动运行
        NSDictionary *remoteNotification = [launchOptions objectForKey: UIApplicationLaunchOptionsRemoteNotificationKey];
    }else{
        NSLog(@"点击ICON打开软件");
    }
    return YES;
}

- (void)kAPNetworkDidRegister:(NSNotification *)notification {
    NSDictionary * userInfo = [notification userInfo];
    NSString *registrationID = [userInfo valueForKey:@"RegistrationID"];
    [[Config sharedConfig] saveRegistrationID:registrationID];
    NSLog(@"registrationID:%@",registrationID);
}

-(void)initShareSDK{
    [ShareSDK registerApp:@"1a81fc29a7db"];
    
    [ShareSDK connectQZoneWithAppKey:@"101073798"
                           appSecret:@"fc7c38c8f9f087c1a3c4b4cce0eef8d8"
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
    
    [ShareSDK connectSinaWeiboWithAppKey:@"570703814"
                               appSecret:@"a806fb887bc2cfbd8cfb9e8a8bf06317"
                             redirectUri:@"http://www.ifanmi.cn"];
    
    [ShareSDK connectWeChatWithAppId:@"wx2913cf7663ee3b2f"
                           wechatCls:[WXApi class]];
}

-(void)initJpushSDK:(NSDictionary *)launchOptions{
    
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(kAPNetworkDidRegister:) name:kAPNetworkDidRegisterNotification object:nil];
    // Required
    [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                   UIRemoteNotificationTypeSound |
                                                   UIRemoteNotificationTypeAlert)];
    // Required
    [APService setupWithOption:launchOptions];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url wxDelegate:nil];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:self];
}

-(void)initEaseMobSDK:(UIApplication *)application and:(NSDictionary *)launchOptions{
    
//#if !TARGET_IPHONE_SIMULATOR
//    UIRemoteNotificationType notificationTypes = UIRemoteNotificationTypeBadge |
//    UIRemoteNotificationTypeSound |
//    UIRemoteNotificationTypeAlert;
//    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:notificationTypes];
//#endif
    
    NSString *apnsCertName = nil;
#if DEBUG
    apnsCertName = @"findmepushdev";
#else
    apnsCertName = @"findmepushpro";
#endif
    [[EaseMob sharedInstance] registerSDKWithAppKey:@"fjhongdong#findme" apnsCertName:apnsCertName];
    [[EaseMob sharedInstance] enableBackgroundReceiveMessage];
    
    [[EaseMob sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    

    [[EaseMob sharedInstance].chatManager removeDelegate:self];
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];

}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
   
    [APService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    [APService handleRemoteNotification:userInfo];
    if (application.applicationState==UIApplicationStateInactive) {
        NSLog(@"IApplicationStateInactive时收到推送");
    }else if (application.applicationState==UIApplicationStateActive) {
        NSLog(@"UIApplicationStateActive时收到推送");
        if ([[userInfo objectForKey:@"type"] isEqualToString:@"10001"]) {
            NSLog(@"强退,注销");
        }
    }else if(application.applicationState==UIApplicationStateBackground){
        NSLog(@"UIApplicationStateBackground时收到推送");
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // 让SDK得到App目前的各种状态，以便让SDK做出对应当前场景的操作
	[[EaseMob sharedInstance] applicationWillResignActive:application];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // 让SDK得到App目前的各种状态，以便让SDK做出对应当前场景的操作
	[[EaseMob sharedInstance] applicationDidEnterBackground:application];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // 让SDK得到App目前的各种状态，以便让SDK做出对应当前场景的操作
	[[EaseMob sharedInstance] applicationWillEnterForeground:application];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // 让SDK得到App目前的各种状态，以便让SDK做出对应当前场景的操作
	[[EaseMob sharedInstance] applicationDidBecomeActive:application];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // 让SDK得到App目前的各种状态，以便让SDK做出对应当前场景的操作
	[[EaseMob sharedInstance] applicationWillTerminate:application];
}

@end
