
#import "XHFeedController4.h"
#import "XHFeedCell4.h"
#import "MJRefresh.h"
#import <AFNetworking.h>
#import "User.h"
#import "Post.h"
#import "BBBadgeBarButtonItem.h"
#import "PostDetailViewController.h"
@interface XHFeedController4 (){
    NSArray *_dataArr;
}

@end

@implementation XHFeedController4


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (UITableView *)feedTableView {
    if (!_feedTableView) {
        CGFloat padding = 0;
        if ([UIDevice currentDevice].systemVersion.integerValue >= 7.0) {
            padding = 64;
        } else {
            padding = 44;
        }
        _feedTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - padding) style:UITableViewStylePlain];
        _feedTableView.delegate = self;
        _feedTableView.dataSource = self;
        _feedTableView.backgroundColor = [UIColor whiteColor];
        _feedTableView.separatorColor = [UIColor clearColor];
        [self.view addSubview:_feedTableView];
    }
    return _feedTableView;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData:) name:@"PostListwillRefresh" object:nil];
	
    _dataArr = [[NSArray alloc] init];
    
    self.title = @"圈子";
    UIButton *postMessage = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [postMessage addTarget:self action:@selector(newPost:) forControlEvents:UIControlEventTouchUpInside];
    [postMessage setImage:[UIImage imageNamed:@"postMessage"] forState:UIControlStateNormal];
    BBBadgeBarButtonItem *postMessageItem = [[BBBadgeBarButtonItem alloc] initWithCustomUIButton:postMessage];
    postMessageItem.badgeValue = @"2";
    postMessageItem.badgeOriginX = 13;
    postMessageItem.badgeOriginY = -9;
    
    
    UIButton *newPostButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [newPostButton addTarget:self action:@selector(newPost:) forControlEvents:UIControlEventTouchUpInside];
    [newPostButton setImage:[UIImage imageNamed:@"newPostButton"] forState:UIControlStateNormal];
    BBBadgeBarButtonItem *newPostButtonItem = [[BBBadgeBarButtonItem alloc] initWithCustomUIButton:newPostButton];
//    newPostButtonItem.badgeValue = @"2";
    newPostButtonItem.badgeOriginX = 13;
    newPostButtonItem.badgeOriginY = -9;
    
    

    
    self.navigationItem.leftBarButtonItem = postMessageItem;
    self.navigationItem.rightBarButtonItem = newPostButtonItem;
    
    self.feedTableView.backgroundColor = [UIColor colorWithRed:242.0/255 green:235.0/255 blue:241.0/255 alpha:1.0];
    
    [self.feedTableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    [self.feedTableView headerBeginRefreshing];
    [self.feedTableView addFooterWithTarget:self action:@selector(footerRereshing)];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"PostListwillRefresh" object:nil];
}
-(void)refreshData:(id)object{
    [self loadDataWithPostId:nil];
}
-(void)newPost:(id)sender{
    [self performSegueWithIdentifier:@"newPost" sender:nil];
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
    NSString *urlStr = [NSString stringWithFormat:@"%@/data/post/post_list.do",Host];
    NSString *type = (postId?@"ol":@"nl");
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:@{@"type": type}];
    if ([type isEqualToString:@"nl"]) {
        _dataArr = [[NSArray alloc] init];
    }else{
        [parameters setValue:postId forKey:@"postId"];
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    __weak __typeof(&*self)weakSelf = self;
    [manager GET:urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *postList = [responseObject objectForKey:@"postList"];
        if (postList!=nil) {
            _dataArr = [_dataArr arrayByAddingObjectsFromArray:[Post objectArrayWithKeyValuesArray:postList]];
            [weakSelf.feedTableView reloadData];
            [weakSelf.feedTableView headerEndRefreshing];
            [weakSelf.feedTableView footerEndRefreshing];
        }else{
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [weakSelf.feedTableView headerEndRefreshing];
        [weakSelf.feedTableView footerEndRefreshing];
        
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 337;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [_dataArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"FeedCell4";
    XHFeedCell4* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[XHFeedCell4 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.post = _dataArr[indexPath.row];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //[self.feedTableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"postDetail" sender:_dataArr[indexPath.row]];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"postDetail"]) {
        PostDetailViewController *controller = (PostDetailViewController *)segue.destinationViewController;
        controller.post = sender;
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}
@end
