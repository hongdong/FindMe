//
//  MainTabViewController.m
//  FindMe
//
//  Created by mac on 14-6-29.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "MainTabViewController.h"
#import "EaseMob.h"
#import "ChatListViewController.h"
#import "ContactsViewController.h"
#import "User.h"
//两次提示的默认间隔
const CGFloat kDefaultPlaySoundInterval = 3.0;
@interface MainTabViewController ()<IChatManagerDelegate>{
      ChatListViewController *_chatListVC;
}
@property (strong, nonatomic)NSDate *lastPlaySoundDate;
@end

@implementation MainTabViewController

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
    //获取未读消息数，此时并没有把self注册为SDK的delegate，读取出的未读数是上次退出程序时的
    [self didUnreadMessagesCountChanged];
    [self registerNotifications];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addUnreadMatch:) name:MatchTime object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addUnreadFriend:) name:FriendChange object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addUnreadPostMsg:) name:PostNew object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginChange:) name:KNOTIFICATION_LOGINCHANGE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(forceSignOut:) name:ForceSignOut object:nil];
    if ([[Config sharedConfig] matchNew:nil]) {
        [self addUnreadMatch:nil];
    }
    
    if ([[Config sharedConfig] friendNew:nil]) {
        [self addUnreadFriend:nil];
    }
    

}
- (void)dealloc
{
    [self unregisterNotifications];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MatchTime object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:FriendChange object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PostNew object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KNOTIFICATION_LOGINCHANGE object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ForceSignOut object:nil];
}

-(void)forceSignOut:(NSNotification *)note{
    NSDictionary *parameters = @{@"type": @"1"};
    [HDNet POST:@"/data/user/login_out.do" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *state = [responseObject objectForKey:@"state"];
        if ([state isEqualToString:@"20001"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
            [[Config sharedConfig] changeLoginState:@"0"];
            [[Config sharedConfig] changeOnlineState:@"0"];
            [[Config sharedConfig] friendNew:@"0"];
            [[Config sharedConfig] matchNew:@"0"];
            [[Config sharedConfig] fansNew:@"0"];
            [[Config sharedConfig] postNew:@"0"];
            [User removeDbObjectsWhere:@"1=1"];
            [[Config sharedConfig] cleanUser];

        }else{
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

-(void)addUnreadMatch:(NSNotification *)note{

    UIViewController *vc = [self.viewControllers objectAtIndex:0];
    vc.tabBarItem.badgeValue = @"HI";
}

-(void)addUnreadFriend:(NSNotification *)note{
    UIViewController *vc = [self.viewControllers objectAtIndex:2];
    vc.tabBarItem.badgeValue = @"HI";
}
-(void)addUnreadPostMsg:(NSNotification *)note{
    UIViewController *vc = [self.viewControllers objectAtIndex:3];
    vc.tabBarItem.badgeValue = @"N";
}

-(void)loginChange:(NSNotification *)notification{
    
    BOOL isLogin = [notification.object boolValue];
    UINavigationController *nav = (UINavigationController *)[self.viewControllers objectAtIndex:2];
    ContactsViewController *contactsViewController = nav.viewControllers[0];
    if (isLogin) {
        if ([notification.userInfo[@"isBack"] isEqualToString:@"0"]) {

            [contactsViewController myReloadDataSource];
        }

    }else{
        [contactsViewController cleanFriend];
        nav.tabBarItem.badgeValue = nil;
//        self.selectedIndex = 0;
        self.selectedViewController = self.viewControllers[0];
    }
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    if(item.tag == 0){
        
    }else if(item.tag == 1){
    }else if(item.tag == 2){//点击好友的时候 如果有更新  把HI给去掉
        if (self.selectedIndex!=2) {
            if ([[Config sharedConfig] friendNew:nil]) {
//                UIViewController *vc = [self.viewControllers objectAtIndex:2];
//                vc.tabBarItem.badgeValue = nil;
            }

        }

    }else if(item.tag == 3){
        if (self.selectedIndex==3) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"PostListwillRefresh" object:nil userInfo:@{@"isHead": @"1"}];
        }
    }else if(item.tag == 4){
        
    }else {
    }
    
}

#pragma mark - private

-(void)registerNotifications
{
    [self unregisterNotifications];
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
}

-(void)unregisterNotifications
{
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
}

// 统计未读消息数
-(void)setupUnreadMessageCount
{
    NSArray *conversations = [[[EaseMob sharedInstance] chatManager] conversations];
    NSInteger unreadCount = 0;
    for (EMConversation *conversation in conversations) {
        unreadCount += conversation.unreadMessagesCount;
    }
    if (_chatListVC) {
        if (unreadCount > 0) {
            _chatListVC.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d",unreadCount];
        }else{
            _chatListVC.navigationController.tabBarItem.badgeValue = nil;
        }
    }
}

#pragma mark - IChatManagerDelegate 消息变化

- (void)didUpdateConversationList:(NSArray *)conversationList
{
    UINavigationController *nav = (UINavigationController *)[self.viewControllers objectAtIndex:1];
    _chatListVC = (ChatListViewController *)(nav.viewControllers[0]);
    [_chatListVC refreshDataSource];
}

// 未读消息数量变化回调
-(void)didUnreadMessagesCountChanged
{
    [self setupUnreadMessageCount];
}

// 收到消息回调
-(void)didReceiveMessage:(EMMessage *)message{
    
#if !TARGET_IPHONE_SIMULATOR
    [self playSoundAndVibration];
    
    BOOL isAppActivity = [[UIApplication sharedApplication] applicationState] == UIApplicationStateActive;
    if (!isAppActivity) {
        [self showNotificationWithMessage:message];
    }
#endif
}

- (void)playSoundAndVibration{
    
    //如果距离上次响铃和震动时间太短, 则跳过响铃
    MJLog(@"%@, %@", [NSDate date], self.lastPlaySoundDate);
    NSTimeInterval timeInterval = [[NSDate date]
                                   timeIntervalSinceDate:self.lastPlaySoundDate];
    if (timeInterval < kDefaultPlaySoundInterval) {
        return;
    }
    //保存最后一次响铃时间
    self.lastPlaySoundDate = [NSDate date];
    
    // 收到消息时，播放音频
    [[EaseMob sharedInstance].deviceManager asyncPlayNewMessageSound];
    // 收到消息时，震动
    [[EaseMob sharedInstance].deviceManager asyncPlayVibration];
}


- (void)showNotificationWithMessage:(EMMessage *)message{
    id<IEMMessageBody> messageBody = [message.messageBodies firstObject];
    NSString *messageStr = nil;
    switch (messageBody.messageBodyType) {
        case eMessageBodyType_Text:
        {
            messageStr = ((EMTextMessageBody *)messageBody).text;
        }
            break;
        case eMessageBodyType_Image:
        {
            messageStr = @"[图片]";
        }
            break;
        case eMessageBodyType_Location:
        {
            messageStr = @"[位置]";
        }
            break;
        case eMessageBodyType_Voice:
        {
            messageStr = @"[音频]";
        }
            break;
        case eMessageBodyType_Video:{
            messageStr = @"[视频]";
        }
            break;
        default:
            break;
    }
    
    //发送本地推送
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = [NSDate date]; //触发通知的时间
    NSString *sql = [NSString stringWithFormat:@"_id='%@'",message.from];
    User *user = [User dbObjectsWhere:sql orderby:nil][0];
    NSString *title = user.userNickName;
    notification.alertBody = [NSString stringWithFormat:@"%@:%@", title, messageStr];
    notification.alertAction = @"打开";
    notification.timeZone = [NSTimeZone defaultTimeZone];
    //发送通知
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    UIApplication *application = [UIApplication sharedApplication];
    application.applicationIconBadgeNumber += 1;
}

#pragma mark - IChatManagerDelegate 登录状态变化

- (void)didLoginFromOtherDevice
{
    [[EaseMob sharedInstance].chatManager asyncLogoffWithCompletion:^(NSDictionary *info, EMError *error) {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
//                                                            message:@"你的账号已在其他地方登录"
//                                                           delegate:self
//                                                  cancelButtonTitle:@"确定"
//                                                  otherButtonTitles:nil,nil];
//        alertView.tag = 100;
//        [alertView show];
    } onQueue:nil];
}

- (void)didRemovedFromServer {
    [[EaseMob sharedInstance].chatManager asyncLogoffWithCompletion:^(NSDictionary *info, EMError *error) {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
//                                                            message:@"你的账号已被从服务器端移除"
//                                                           delegate:self
//                                                  cancelButtonTitle:@"确定"
//                                                  otherButtonTitles:nil,
//                                  nil];
//        alertView.tag = 101;
//        [alertView show];
    } onQueue:nil];
}

- (void)didConnectionStateChanged:(EMConnectionState)connectionState
{
    [_chatListVC networkChanged:connectionState];
}

#pragma mark -

- (void)willAutoReconnect{
//    [self showHudInView:self.view hint:@"正在重连中..."];
}

- (void)didAutoReconnectFinishedWithError:(NSError *)error{
//    [self hideHud];
    if (error) {
//        [self showHint:@"重连失败，稍候将继续重连"];
    }else{
//        [self showHint:@"重连成功！"];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



@end
