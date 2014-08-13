//
//  FansViewController.m
//  FindMe
//
//  Created by mac on 14-7-14.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "FansViewController.h"
#import "FansCell.h"
#import "User.h"
#import "UIScrollView+EmptyDataSet.h"
#import "FindMeDetailViewController.h"
@interface FansViewController ()<MCSwipeTableViewCellDelegate,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>{
    NSMutableArray *_dataArr;
}

@end

@implementation FansViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    [backgroundView setBackgroundColor:[UIColor colorWithRed:227.0 / 255.0 green:227.0 / 255.0 blue:227.0 / 255.0 alpha:1.0]];
    [self.tableView setBackgroundView:backgroundView];
    
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    
    self.tableView.tableHeaderView = [[UIView alloc] init];
    
    [self getFans];
}


-(void)getFans{
    __weak __typeof(&*self)weakSelf = self;
    [HDNet GET:@"/data/user/fans_list.do" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[Config sharedConfig] fansNew:nil]) {
            [[Config sharedConfig] fansNew:@"0"];
            weakSelf.fansItem.badgeValue = nil;
        }
        
        NSArray *userFans = [responseObject objectForKey:@"userFans"];
        if (userFans!=nil&&[userFans count]!=0) {
            _dataArr = [[User objectArrayWithKeyValuesArray:userFans] mutableCopy];
            [weakSelf.tableView reloadData];
        }else{
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        MJLog(@"获取粉丝失败");
    }];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArr count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"fansCell";
    FansCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[FansCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
        // iOS 7 separator
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            cell.separatorInset = UIEdgeInsetsZero;
        }
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        cell.contentView.backgroundColor = [UIColor whiteColor];
    }
    cell.user = _dataArr[indexPath.row];
    
    UIView *checkView = [self viewWithImageName:@"check"];
    UIColor *greenColor = [UIColor colorWithRed:85.0 / 255.0 green:213.0 / 255.0 blue:80.0 / 255.0 alpha:1.0];
    
    UIView *crossView = [self viewWithImageName:@"cross"];
    UIColor *redColor = [UIColor colorWithRed:232.0 / 255.0 green:61.0 / 255.0 blue:14.0 / 255.0 alpha:1.0];

    
    // Setting the default inactive state color to the tableView background color
    [cell setDefaultColor:self.tableView.backgroundView.backgroundColor];
    
    [cell setDelegate:self];
    __weak __typeof(&*self)weakSelf = self;
    [cell setSwipeGestureWithView:checkView color:greenColor mode:MCSwipeTableViewCellModeExit state:MCSwipeTableViewCellState1 completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
        
        [weakSelf like:((FansCell *)cell).user._id];
        [weakSelf deleteCell:cell];
        
    }];
    
    [cell setSwipeGestureWithView:crossView color:redColor mode:MCSwipeTableViewCellModeExit state:MCSwipeTableViewCellState3 completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
        [weakSelf pass:((FansCell *)cell).user._id];
        [weakSelf deleteCell:cell];
        
    }];
    

    return cell;
}

-(void)like:(NSString *)_id{
    NSDictionary *parameters = @{@"type":@"2",@"likeUserId": _id};
    
    [HDNet GET:@"/data/user/like_user.do" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *state = [responseObject objectForKey:@"state"];
        if ([state isEqualToString:@"20001"]) {
            MJLog(@"LIKE成功");
        }else if ([state isEqualToString:@"20002"]){
            MJLog(@"你们已经成为朋友了");
            [[NSNotificationCenter defaultCenter] postNotificationName:FriendChange object:nil];
        }else{
            MJLog(@"LIke失败");
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        MJLog(@"LIke失败");
    }];
}

-(void)pass:(NSString *)_id{
    NSDictionary *parameters = @{@"type":@"2",@"userMatchId": _id};;
    [HDNet GET:@"/data/user/match_info.do" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        MJLog(@"%@",[responseObject objectForKey:@"fansPass"]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        MJLog(@"pass失败");
    }];

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    FindMeDetailViewController *controller = [HDTool getControllerByStoryboardId:@"userDetailController"];
    controller.user = _dataArr[indexPath.row];
    [self.navigationController pushViewController:controller animated:YES];
    
}
- (UIView *)viewWithImageName:(NSString *)imageName {
    UIImage *image = [UIImage imageNamed:imageName];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.contentMode = UIViewContentModeCenter;
    return imageView;
}

- (void)deleteCell:(MCSwipeTableViewCell *)cell {
    NSParameterAssert(cell);

    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [_dataArr removeObjectAtIndex:indexPath.row];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - DZNEmptyDataSetSource Methods

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = nil;
    UIFont *font = nil;
    UIColor *textColor = nil;
    
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    text = @"暂无粉丝";
    font = [UIFont fontWithName:@"HelveticaNeue-Light" size:22.0];
//    textColor = HDRED;
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
    text = @"你不会丑到连粉丝都木有吧，赶快更换你的照片。";
    font = [UIFont systemFontOfSize:12.0];
//    textColor = HDRED;
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
- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIColor whiteColor];
}

@end
