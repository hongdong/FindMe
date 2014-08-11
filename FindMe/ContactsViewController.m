#import "ContactsViewController.h"
#import "BaseTableViewCell.h"
#import "RealtimeSearchUtil.h"
#import "ChineseToPinyin.h"
#import "EMBuddy.h"
#import "EaseMob.h"
#import "ChatViewController.h"
#import "MJRefresh.h"
#import <AFNetworking.h>
#import "User.h"
#import "UIImageView+WebCache.h"
#import "UIScrollView+EmptyDataSet.h"
#import "BlocksKit+UIKit.h"
#import "ChatSendHelper.h"
@interface ContactsViewController ()<UITableViewDataSource, UITableViewDelegate,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (strong, nonatomic) NSMutableArray *contactsSource;
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) NSMutableArray *sectionTitles;
@property (strong, nonatomic) UITableView *tableView;


@end

@implementation ContactsViewController

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
        _dataSource = [NSMutableArray array];
        _contactsSource = [NSMutableArray array];
        _sectionTitles = [NSMutableArray array];
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(myReloadDataSource) name:FriendChange object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginChange:) name:KNOTIFICATION_LOGINCHANGE object:nil];
    
    self.title = @"好友";
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"friendTitleView"]];
    __weak __typeof(&*self)weakSelf = self;
    self.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    UIView *headView = [HDTool loadCustomViewByIndex:RandomHiViewIndex];
    [((UIButton *)[headView viewWithTag:1000]) bk_addEventHandler:^(id sender) {
        if (![[Config sharedConfig] isOnline]) {
            [weakSelf showHint:@"请先登入"];
            return;
        }
        NSMutableArray *allUsers = [User allDbObjects];
        int i = arc4random()%[allUsers count];
        [ChatSendHelper sendTextMessageWithString:@"HI" toUser:allUsers[i]];
        [weakSelf showHint:@"已经帮你随机问候了"];
        
    } forControlEvents:UIControlEventTouchUpInside];
    headView.backgroundColor = HDRED;
    self.tableView.tableHeaderView = headView;
    [self.view addSubview:self.tableView];
    [self.tableView addHeaderWithTarget:self action:@selector(myReloadDataSource)];

    if ([[Config sharedConfig] isLogin]) {
        [self loadLocalFriends];
    }
    
    if ([[Config sharedConfig] friendNew:nil]) {
        [self myReloadDataSource];
    }
}


-(void)loginChange:(NSNotification *)notification{
    
    BOOL isLogin = [notification.object boolValue];
    if (isLogin) {
        [self myReloadDataSource];
    }else{
        [self.dataSource removeAllObjects];
        [self.contactsSource removeAllObjects];
        [self.sectionTitles removeAllObjects];
        [self.tableView reloadData];
        self.navigationController.tabBarItem.badgeValue = nil;
    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:FriendChange object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KNOTIFICATION_LOGINCHANGE object:nil];
    _tableView.delegate = nil;
}

-(void)loadLocalFriends{
    [self.dataSource removeAllObjects];
    [self.contactsSource removeAllObjects];
     self.contactsSource = [User allDbObjects];
    [self.dataSource addObjectsFromArray:[self sortDataArray:self.contactsSource]];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

#pragma mark - getter
- (UITableView *)tableView
{
    if (_tableView == nil)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if (iOS7) {
          _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
        }

        _tableView.sectionIndexColor = HDRED;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    
    return _tableView;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.dataSource count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [[self.dataSource objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BaseTableViewCell *cell;

        static NSString *CellIdentifier = @"ContactListCell";
        cell = (BaseTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
            User *user = [[self.dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:user.userPhoto] placeholderImage:[UIImage imageNamed:@"chatListCellHead.png"]];
            cell.textLabel.text = user.userNickName;
    
    
    
    return cell;
}



#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([[self.dataSource objectAtIndex:section] count] == 0)
    {
        return 0;
    }
    else{
        return 22;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ([[self.dataSource objectAtIndex:section] count] == 0)
    {
        return nil;
    }
    
    UIView *contentView = [[UIView alloc] init];
    [contentView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 22)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor lightGrayColor];
    [label setText:[self.sectionTitles objectAtIndex:section]];
    [contentView addSubview:label];
    return contentView;
}
//索引
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{

    NSMutableArray * existTitles = [NSMutableArray array];
    //section数组为空的title过滤掉，不显示
    for (int i = 0; i < [self.sectionTitles count]; i++) {
        if ([[self.dataSource objectAtIndex:i] count] > 0) {
            [existTitles addObject:[self.sectionTitles objectAtIndex:i]];
        }
    }
    return existTitles;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

        User *user = [[self.dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
//        NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
//        NSString *loginUsername = [loginInfo objectForKey:kSDKUsername];
        ChatViewController *chatVC = [[ChatViewController alloc] initWithChatter:user._id andPhoto:user.userPhoto];
        chatVC.title = user.userNickName;
        [self.navigationController pushViewController:chatVC animated:YES];
    
}


#pragma mark - private

- (NSMutableArray *)sortDataArray:(NSArray *)dataArray
{
    //建立索引的核心
    UILocalizedIndexedCollation *indexCollation = [UILocalizedIndexedCollation currentCollation];
    
    [self.sectionTitles removeAllObjects];
    [self.sectionTitles addObjectsFromArray:[indexCollation sectionTitles]];
    
    //返回27，是a－z和＃
    NSInteger highSection = [self.sectionTitles count];
    //tableView 会被分成27个section
    NSMutableArray *sortedArray = [NSMutableArray arrayWithCapacity:highSection];
    for (int i = 0; i <= highSection; i++) {
        NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:1];
        [sortedArray addObject:sectionArray];
    }
    
    //名字分section
    for (User *user in dataArray) {
        //getUserName是实现中文拼音检索的核心，见NameIndex类
        NSString *firstLetter = [ChineseToPinyin pinyinFromChineseString:user.userNickName];
        NSInteger section = [indexCollation sectionForObject:[firstLetter substringToIndex:1] collationStringSelector:@selector(uppercaseString)];
        
        NSMutableArray *array = [sortedArray objectAtIndex:section];
        [array addObject:user];
    }
    
    //每个section内的数组排序
    for (int i = 0; i < [sortedArray count]; i++) {
        NSArray *array = [[sortedArray objectAtIndex:i] sortedArrayUsingComparator:^NSComparisonResult(User *obj1, User *obj2) {
            NSString *firstLetter1 = [ChineseToPinyin pinyinFromChineseString:obj1.userNickName];
            firstLetter1 = [[firstLetter1 substringToIndex:1] uppercaseString];
            
            NSString *firstLetter2 = [ChineseToPinyin pinyinFromChineseString:obj2.userNickName];
            firstLetter2 = [[firstLetter2 substringToIndex:1] uppercaseString];
            
            return [firstLetter1 caseInsensitiveCompare:firstLetter2];
        }];
        
        
        [sortedArray replaceObjectAtIndex:i withObject:[NSMutableArray arrayWithArray:array]];
    }
    
    return sortedArray;
}

#pragma mark - dataSource
- (void)myReloadDataSource
{
    [self.dataSource removeAllObjects];
    [self.contactsSource removeAllObjects];
    
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/data/user/user_friend.do",Host];

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    __weak __typeof(&*self)weakSelf = self;
    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[Config sharedConfig] friendNew:nil]) {
            [[Config sharedConfig] friendNew:@"0"];
            weakSelf.navigationController.tabBarItem.badgeValue = nil;
        }
        NSArray *friendList = [responseObject objectForKey:@"friendList"];
        if (friendList!=nil) {
            weakSelf.contactsSource = [[NSMutableArray alloc] initWithArray:[User objectArrayWithKeyValuesArray:friendList]];
            [User removeDbObjectsWhere:@"1=1"];
            for (User *user in weakSelf.contactsSource) {
                if (![User existDbObjectsWhere:[NSString stringWithFormat:@"_id='%@'",user._id]]) {
                        [user insertToDb];
                }

            }
            [weakSelf.dataSource addObjectsFromArray:[self sortDataArray:self.contactsSource]];
            [weakSelf.tableView reloadData];
            [weakSelf.tableView headerEndRefreshing];
            
        }else{
            [weakSelf.tableView headerEndRefreshing];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [weakSelf.tableView headerEndRefreshing];
    }];
    
}


#pragma mark - DZNEmptyDataSetSource Methods

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = nil;
    UIFont *font = nil;
    UIColor *textColor = nil;
    
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    text = @"暂无好友";
    font = [UIFont fontWithName:@"HelveticaNeue-Light" size:22.0];
    if (font) [attributes setObject:font forKey:NSFontAttributeName];
    if (textColor) [attributes setObject:textColor forKey:NSForegroundColorAttributeName];
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = nil;
    UIFont *font = nil;
    UIColor *textColor = nil;
    
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    text = @"你还没有好友，赶快更换照片了。";
    font = [UIFont systemFontOfSize:13.0];
    paragraph.lineSpacing = 4.0;
    if (font) [attributes setObject:font forKey:NSFontAttributeName];
    if (textColor) [attributes setObject:textColor forKey:NSForegroundColorAttributeName];
    if (paragraph) [attributes setObject:paragraph forKey:NSParagraphStyleAttributeName];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text attributes:attributes];
    return attributedString;
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"graylogo"];
}
- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state{
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    [attributes setObject:[UIColor lightGrayColor] forKey:NSForegroundColorAttributeName];
    return [[NSAttributedString alloc] initWithString:@"重新加载" attributes:attributes];
}
- (void)emptyDataSetDidTapButton:(UIScrollView *)scrollView
{
    if (![[Config sharedConfig] isOnline]) {
        [self showHint:@"请先登入"];
        return;
    }
    [self myReloadDataSource];
}

@end
