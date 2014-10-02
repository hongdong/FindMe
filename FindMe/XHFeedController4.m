
#import "XHFeedController4.h"
#import "XHFeedCell4.h"
#import "XHFeedCell1.h"
#import "MJRefresh.h"
#import "User.h"
#import "BBBadgeBarButtonItem.h"
#import "PostDetailViewController.h"
#import "UIScrollView+EmptyDataSet.h"
#import "PostMessageViewController.h"
#import "UIViewController+ScrollingNavbar.h"

@interface XHFeedController4 ()<DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>{
    
    NSMutableArray *_dataArr;
    NSInteger _seletedRow;
    BBBadgeBarButtonItem *_postMessageItem;
    BOOL _freshing;
}

@end

@implementation XHFeedController4


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

-(void)changeRowWithPost:(Post *)post{
    _dataArr[_seletedRow] = post;
    NSIndexPath  *indexPath=[NSIndexPath indexPathForRow:_seletedRow inSection:0];
    NSArray      *indexArray=[NSArray  arrayWithObject:indexPath];
    [self.feedTableView   reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationNone];
}

- (UITableView *)feedTableView {
    if (!_feedTableView) {
        CGFloat padding = 0;
        if (iOS7) {
            padding = 64;
        } else {
            padding = 44;
        }
        _feedTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - padding) style:UITableViewStylePlain];
        _feedTableView.delegate = self;
        _feedTableView.dataSource = self;
        
        _feedTableView.emptyDataSetSource = self;
        _feedTableView.emptyDataSetDelegate = self;
        
        _feedTableView.backgroundColor = [UIColor whiteColor];
        _feedTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        
        [self.view addSubview:_feedTableView];
    }
    return _feedTableView;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData:) name:@"PostListwillRefresh" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(postNew:) name:PostNew object:nil];
    _dataArr = [[NSMutableArray alloc] init];

    [self followScrollView:self.feedTableView];
    
    self.title = @"秘圈";
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"postTitleView"]];
    UIButton *postMessage = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [postMessage addTarget:self action:@selector(postMessage:) forControlEvents:UIControlEventTouchUpInside];
    [postMessage setImage:[UIImage imageNamed:@"postMessage"] forState:UIControlStateNormal];
    _postMessageItem = [[BBBadgeBarButtonItem alloc] initWithCustomUIButton:postMessage];

    _postMessageItem.badgeOriginX = 13;
    _postMessageItem.badgeOriginY = -9;
    
    if ([[Config sharedConfig] postNew:nil]) {
            _postMessageItem.badgeValue = @"N";
    }
    
    UIButton *newPostButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [newPostButton addTarget:self action:@selector(newPost:) forControlEvents:UIControlEventTouchUpInside];
    [newPostButton setImage:[UIImage imageNamed:@"newPostButton"] forState:UIControlStateNormal];
    BBBadgeBarButtonItem *newPostButtonItem = [[BBBadgeBarButtonItem alloc] initWithCustomUIButton:newPostButton];
    newPostButtonItem.badgeOriginX = 13;
    newPostButtonItem.badgeOriginY = -9;
    
    

    
    self.navigationItem.leftBarButtonItem = _postMessageItem;
    self.navigationItem.rightBarButtonItem = newPostButtonItem;
    
    self.feedTableView.backgroundColor = [UIColor colorWithRed:242.0/255 green:235.0/255 blue:241.0/255 alpha:1.0];
    
    [self.feedTableView addHeaderWithTarget:self action:@selector(headerRereshing)];

    [self.feedTableView addFooterWithTarget:self action:@selector(footerRereshing)];
    
    [self headerRereshing];
    
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self showNavBarAnimated:NO];
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
	// This enables the user to scroll down the navbar by tapping the status bar.
	[self performSelector:@selector(showNavbar) withObject:nil afterDelay:0.1];
	
	return YES;
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"PostListwillRefresh" object:nil];
    
    _feedTableView.delegate = nil;
    _feedTableView.dataSource = nil;
    
    _feedTableView.emptyDataSetSource = nil;
    _feedTableView.emptyDataSetDelegate = nil;
}
-(void)refreshData:(NSNotification *)note{
    if ([[note.userInfo objectForKey:@"isHead"] isEqualToString:@"1"]) {

        if (!_freshing) {
            [self showNavBarAnimated:NO];
            [self.feedTableView headerBeginRefreshing];
        }
    }else{
        [self loadDataWithPostId:nil];
    }
    
}

-(void)postNew:(NSNotification *)note{
    _postMessageItem.badgeValue = @"N";
}
-(void)newPost:(id)sender{
    if (![[Config sharedConfig] isOnline]) {
        [HDTool showHDJGHUDHint:@"你还没登入"];
        return;
    }
    [self performSegueWithIdentifier:@"newPost" sender:nil];
}
-(void)postMessage:(id)sender{
    if (![[Config sharedConfig] isOnline]) {
        [HDTool showHDJGHUDHint:@"你还没登入"];
        return;
    }
   [self performSegueWithIdentifier:@"postMessage" sender:_postMessageItem];
}



#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
        [self loadDataWithPostId:nil];

}

- (void)footerRereshing
{

    [self loadDataWithPostId:((Post *)[_dataArr lastObject])._id];

}

-(void)loadDataWithPostId:(NSString *)postId{
    _freshing = YES;
    NSString *type = (postId?@"ol":@"nl");
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:@{@"type": type}];
    if ([type isEqualToString:@"nl"]) {
//        [_dataArr removeAllObjects];
    }else{
        [parameters setValue:postId forKey:@"postId"];
    }
    __weak __typeof(&*self)weakSelf = self;
    
    [HDNet GET:@"/data/post/post_list.do" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *postList = [responseObject objectForKey:@"postList"];
        if (postList!=nil) {
            if ([type isEqualToString:@"nl"]) {
                [_dataArr removeAllObjects];
            }
            [_dataArr addObjectsFromArray:[Post objectArrayWithKeyValuesArray:postList]];
            [weakSelf.feedTableView reloadData];
            
        }else{
            
        }
        [weakSelf.feedTableView headerEndRefreshing];
        [weakSelf.feedTableView footerEndRefreshing];
        _freshing = NO;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [weakSelf.feedTableView headerEndRefreshing];
        [weakSelf.feedTableView footerEndRefreshing];
        _freshing = NO;
    }];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 337;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier1 = @"FeedCell1";
    static NSString *cellIdentifier4 = @"FeedCell4";
    id cell;
    Post *post = _dataArr[indexPath.row];
    if (post.postPhoto==nil) {
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier1];
        if (!cell) {
            cell = [[XHFeedCell1 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier1];
        }
        ((XHFeedCell1 *)cell).post = post;
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier4];
        if (!cell) {
            cell = [[XHFeedCell4 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier4];
        }
        ((XHFeedCell4 *)cell).post = post;
    }

    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //[self.feedTableView deselectRowAtIndexPath:indexPath animated:YES];
    _seletedRow = indexPath.row;
    [self performSegueWithIdentifier:@"postDetail" sender:_dataArr[indexPath.row]];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"postDetail"]) {
        PostDetailViewController *controller = (PostDetailViewController *)segue.destinationViewController;
        controller.post = sender;
        controller.delegate = self;
    }else if ([segue.identifier isEqualToString:@"postMessage"]){
        PostMessageViewController *controller = (PostMessageViewController *)segue.destinationViewController;
        controller.postMessageItem = sender;
    }
}

#pragma mark - DZNEmptyDataSetSource Methods

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{

    return [[NSAttributedString alloc] initWithString:@"吐槽星人" attributes:nil];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{

    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"怎么能不吐槽" attributes:nil];
    return attributedString;
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"face"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}
@end
