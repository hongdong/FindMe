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
}
- (void)dealloc
{
    [self unregisterNotifications];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MatchTime object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:FriendChange object:nil];
}

-(void)addUnreadMatch:(NSNotification *)note{

    UIViewController *vc = [self.viewControllers objectAtIndex:0];
    vc.tabBarItem.badgeValue = @"HI";
}

-(void)addUnreadFriend:(NSNotification *)note{
    UIViewController *vc = [self.viewControllers objectAtIndex:0];
    vc.tabBarItem.badgeValue = @"HI";
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    if(item.tag == 0){

    }else if(item.tag == 1){
    }else if(item.tag == 2){
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
    UIViewController *vc = [self.viewControllers objectAtIndex:1];
    if (unreadCount > 0) {
        vc.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d",unreadCount];
    }else{
        vc.tabBarItem.badgeValue = nil;
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
    NSLog(@"%@, %@", [NSDate date], self.lastPlaySoundDate);
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
    
    NSString *title = message.from;
    if (message.isGroup) {
        NSArray *groupArray = [[EaseMob sharedInstance].chatManager groupList];
        for (EMGroup *group in groupArray) {
            if ([group.groupId isEqualToString:message.conversation.chatter]) {
                title = [NSString stringWithFormat:@"%@(%@)", message.groupSenderName, group.groupSubject];
                break;
            }
        }
    }
    
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
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"你的账号已在其他地方登录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alertView.tag = 100;
        [alertView show];

    } onQueue:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



@end
