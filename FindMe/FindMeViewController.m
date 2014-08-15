#import "FindMeViewController.h"
#import "User.h"
#import "ChooseSchoolViewController.h"
#import "JMWhenTapped.h"
#import "UIImageView+WebCache.h"
#import "FindMeDetailViewController.h"
#import "CoverView.h"
#import "BBBadgeBarButtonItem.h"
#import "MDCFocusView.h"
#import "MDCSpotlightView.h"
#import "FansViewController.h"
#import "UIView+Common.h"
#import "NSString+HD.h"
#import "LoginViewController.h"
#import "HYCircleLoadingView.h"
@interface FindMeViewController ()<CoverViewDelegate,LoginViewControllerDelegate>{
    User *_user;
    User *_matchUser;
    CoverView *_coverView;
    BBBadgeBarButtonItem *_fansItem;
    UIButton *_fansButton;
    MDCFocusView *_focusView;
    
    LoginViewController *_loginViewController;
    
    HYCircleLoadingView *_circleLoadingView;
}

@end

@implementation FindMeViewController

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        [self initCoverView];
        
        [self initFansItem];
        
        if ([[Config sharedConfig] isLogin]) {
            _user = [User getUserFromNSUserDefaults];
        }
        
    }
    return self;
}

-(void)initCoverView{
    _coverView = [HDTool loadCustomViewByIndex:CoverViewIndex];
    _coverView.delegate = self;
}

-(void)initFansItem{
    _fansButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [_fansButton addTarget:self action:@selector(fansButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_fansButton setImage:[UIImage imageNamed:@"fans"] forState:UIControlStateNormal];
    _fansItem = [[BBBadgeBarButtonItem alloc] initWithCustomUIButton:_fansButton];
    _fansItem.badgeOriginX = 10;
    _fansItem.badgeOriginY = -9;
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
    
    __weak __typeof(&*self)weakSelf = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginStateChange:)
                                                 name:KNOTIFICATION_LOGINCHANGE
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userChange:)
                                                 name:UserInfoChange
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(matchTime:)
                                                 name:MatchTime
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fansNew:) name:FansNew object:nil];

    
    _circleLoadingView = [[HYCircleLoadingView alloc]initWithFrame:CGRectMake(0, 0, 26, 26)];
    UIBarButtonItem *loadingItem = [[UIBarButtonItem alloc]initWithCustomView:_circleLoadingView];
    self.navigationItem.leftBarButtonItem = loadingItem;
    
    self.photo.layer.cornerRadius = 75.0f;
    self.photo.layer.masksToBounds = YES;
    

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
    if ([[Config sharedConfig] fansNew:nil]) {
        _fansItem.badgeValue = @"N";
        [self getMatch:nil andSender:nil];
    }
    
    if (![[Config sharedConfig] isLogin]) {
        _loginViewController = [HDTool getControllerByStoryboardId:@"loginViewController"];
        _loginViewController.delegate = self;
        [self.view addSubview:_loginViewController.view];
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
    }else if (_focusView.isFocused){
        [_focusView dismiss:^{
            [[Config sharedConfig] launchGuide:@"0"];
        }];
        return;
    }else if (![_user.userSex isEqualToString:@"女"]){
        [self showHint:@"目前只有女生开通了粉丝服务"];
        return;
    }
    [self performSegueWithIdentifier:@"fans" sender:_fansItem];
}

-(void)launchGuide:(UIView *)view andText:(NSString *)text{
    _focusView = [MDCFocusView new];
    _focusView.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.8f];
    _focusView.focalPointViewClass = [MDCSpotlightView class];
    [_focusView addSubview:[self buildLabelWithText:text]];
    [_focusView focus:view,nil];
}

- (IBAction)likePressed:(id)sender {
    __weak __typeof(&*self)weakSelf = self;
    if (_focusView.isFocused) {
        [_focusView dismiss:^{
            [weakSelf launchGuide:weakSelf.passBt andText:@"你点击了pass意味着你放弃这次认识的机会，你将会看到番迷君给你推荐的下一个人。"];
        }];
        return;
    }
    [self showCover];
    NSDictionary *parameters = @{@"type":@"1",@"likeUserId": _matchUser._id};
    [HDNet GET:@"/data/user/like_user.do" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [[Config sharedConfig] matchNew:@"0"];
        weakSelf.navigationController.tabBarItem.badgeValue = nil;
        NSString *state = [responseObject objectForKey:@"state"];
        if ([state isEqualToString:@"20001"]) {
            if ([_user.userSex isEqualToString:@"男"]) {
                [weakSelf getMatch:nil andSender:nil];
            }else if ([_user.userSex isEqualToString:@"女"]){
                [weakSelf showHint:@"番迷君知道该怎么做了"];
            }else{
                
            }
        }else if ([state isEqualToString:@"20002"]){
            [[NSNotificationCenter defaultCenter] postNotificationName:FriendChange object:nil];
            if ([_user.userSex isEqualToString:@"男"]) {
                [weakSelf showHint:@"番迷君得知她喜欢你已久"];
                [weakSelf getMatch:nil andSender:sender];
            }else if ([_user.userSex isEqualToString:@"女"]){
                [weakSelf showHint:@"番迷君得知他喜欢你已久"];
            }else{
                
            }
        }else if([state isEqualToString:@"10003"]){
            [weakSelf showHint:@"用户已经失效，正在帮你刷新"];
            [weakSelf getMatch:nil andSender:nil];
            
        }else{
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [weakSelf showHint:@"错误"];
    }];

}
- (IBAction)passPressed:(id)sender {
        __weak __typeof(&*self)weakSelf = self;
    if (_focusView.isFocused) {
        [_focusView dismiss:^{
            [weakSelf launchGuide:_fansButton andText:@"你还会拥有你自己的粉丝，让番迷君给你找到更适合的人。他们都真心想和你交朋友，只等你一个准字。（操作指导：右滑YES，左滑NO哦）"];
        }];
        return;
    }
    [self showCover];
    [self getMatch:_matchUser._id andSender:nil];
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
                         if (finished==YES&&[[Config sharedConfig] launchGuide:nil]&&self.navigationController.tabBarController.selectedIndex==0) {
                             NSString *info;
                             if ([_user.userSex isEqualToString:@"男"]) {
                                 info = @"番迷君每天至少都会给你推荐一个有缘人，点击了like意味着你想尝试认识一下Ta。";
                             }else{
                                 info = @"番迷君每天至多给你推荐三个有缘人，点击了like意味着你想尝试认识一下Ta。并结束今天的推荐。";
                             }
                             [weakSelf launchGuide:weakSelf.likeBt andText:info];
                             
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

-(void)getMatch:(NSString *)userMatchId andSender:(UIButton *)sender{
    [_circleLoadingView startAnimation];
    NSMutableDictionary *parameters = [@{@"type": @"1"} mutableCopy];
    if (userMatchId!=nil) {
        [parameters setValue:userMatchId forKey:@"userMatchId"];
    }
    __weak __typeof(&*self)weakSelf = self;
    [HDNet GET:@"/data/user/match_info.do" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [_circleLoadingView stopAnimation];
        if (sender!=nil) {
            sender.enabled = YES;
        }
        NSDictionary *userMatch = [responseObject objectForKey:@"userMatch"];
        NSDictionary *userDic = [userMatch objectForKey:@"user"];
        if (userDic!=nil) {
            _matchUser = [User objectWithKeyValues:userDic];
            [weakSelf setMatchPeople];
            [weakSelf hideCover];
        }else{
            [HDTool ToastNotification:@"番迷君也需要休息" andView:weakSelf.view andLoading:NO andIsBottom:NO];
            if ([[Config sharedConfig] matchNew:nil]) {
                [[Config sharedConfig] matchNew:@"0"];
                weakSelf.navigationController.tabBarItem.badgeValue = nil;
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [HDTool ToastNotification:@"番迷君出故障了" andView:weakSelf.view andLoading:NO andIsBottom:NO];
        [_circleLoadingView stopAnimation];
        if (sender!=nil) {
            sender.enabled = YES;
        }
    }];
    
}

-(void)setMatchPeople{
    if (_matchUser!=nil) {
        [self.photo sd_setImageWithURL:[NSURL URLWithString:_matchUser.userPhoto] placeholderImage:[UIImage imageNamed:@"defaultImage"]];
        CGSize size = CGSizeMake(320,2000);
        CGSize realsize = [_matchUser.userNickName getRealSize:size andFont:[UIFont systemFontOfSize:16.0f]];
        self.nickname.bounds = (CGRect){{0,0},realsize};
        self.nickname.center = CGPointMake(0.5*self.view.width, self.nickname.center.y);
        
        
        self.nickname.text = _matchUser.userNickName;
        self.grade.text = _matchUser.userGrade;
        
        self.sex.center = CGPointMake(self.nickname.left-10, self.sex.center.y);
        
        if ([_matchUser.userSex isEqualToString:@"男"]) {
            self.sex.image = [UIImage imageNamed:@"boy"];
        }else if([_matchUser.userSex isEqualToString:@"男"]){
            self.sex.image = [UIImage imageNamed:@"girl"];
        }else{
            [HDTool autoSex:self.sex];
        }
        self.xzLbl.frame = CGRectMake(self.nickname.right+2, self.xzLbl.y, self.xzLbl.width, self.xzLbl.height);
        self.xzLbl.text = _matchUser.userConstellation;
        self.schoolLbl.text = [_matchUser getSchoolName];
        self.departmentLbl.text = [_matchUser getDepartmentName];
        self.qianmingLbl.text = _matchUser.userSignature;
        if ([_matchUser.userAuth intValue]==1) {
            self.xzimg.center = CGPointMake(self.sex.left-10, self.xzimg.centerY);
            self.xzimg.hidden = NO;
        }else{
            self.xzimg.hidden = YES;
        }
        
    }

    
}


-(void)userChange:(NSNotification *)notification{
    _user = [User getUserFromNSUserDefaults];
}

-(void)fansNew:(NSNotification *)notification{
    _fansItem.badgeValue = @"N";
}

-(void)loginStateChange:(NSNotification *)notification{
    BOOL isLogin = [notification.object boolValue];
    if (isLogin) {
        if (_loginViewController!=nil) {
            [_loginViewController.view removeFromSuperview];
            _loginViewController=nil;
        }
//        [self getMatch:nil andSender:nil];
    }
    else{
        if (_loginViewController==nil) {
            _loginViewController = [HDTool getControllerByStoryboardId:@"loginViewController"];
            _loginViewController.delegate = self;
        }
        [self showCover];
        [self.view addSubview:_loginViewController.view];
        self.navigationController.tabBarItem.badgeValue = nil;
    }
}

-(void)matchTime:(NSNotification *)note{
    [self getMatch:nil andSender:nil];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"chooseSchool"])
    {
        ChooseSchoolViewController *controller=(ChooseSchoolViewController *)(segue.destinationViewController);;
        controller.user = sender;
    }else if ([segue.identifier isEqualToString:@"findmeDetail"]) {
        FindMeDetailViewController *controller = segue.destinationViewController;
        controller.user = sender;
    }else if ([segue.identifier isEqualToString:@"fans"]){
        FansViewController *controller = segue.destinationViewController;
        controller.fansItem = sender;
    }
}

#pragma delegate
-(void)coverViewRefreshPressed:(UIButton *)sender{
    sender.enabled = NO;
    [self getMatch:nil andSender:sender];
}
- (void)shouldShowChooseSchool:(User *)user{
    [self performSegueWithIdentifier:@"chooseSchool" sender:user];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

-(void)dealloc{

    [[NSNotificationCenter defaultCenter] removeObserver:self name:KNOTIFICATION_LOGINCHANGE object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UserInfoChange object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MatchTime object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:FansNew object:nil];
    
}

@end
