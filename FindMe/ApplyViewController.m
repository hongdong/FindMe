//
//  ApplyViewController.m
//  ChatDemo-UI
//
//  Created by dhcdht on 14-5-15.
//  Copyright (c) 2014年 djp. All rights reserved.
//

#import "ApplyViewController.h"

#import "ApplyFriendCell.h"
#import "EMError.h"
#import "EaseMob.h"

@interface ApplyViewController ()<ApplyFriendCellDelegate>

@end

@implementation ApplyViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        _dataSource = [[NSMutableArray alloc] init];
        
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    self.title = @"好友申请";
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ApplyFriendCell";
    ApplyFriendCell *cell = (ApplyFriendCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[ApplyFriendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.delegate = self;
    }
    
    NSDictionary *dic = [self.dataSource objectAtIndex:indexPath.row];
    if (dic) {
        cell.indexPath = indexPath;
         cell.titleLabel.text = [dic objectForKey:@"title"];
        BOOL isGroup = [[dic objectForKey:@"isGroup"] boolValue];
        if (isGroup) {
            cell.headerImageView.image = [UIImage imageNamed:@"groupHeader"];
        }
        else{
            cell.headerImageView.image = [UIImage imageNamed:@"chatListCellHead"];
        }
        cell.contentLabel.text = [dic objectForKey:@"applyMessage"];
    }
    
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = [self.dataSource objectAtIndex:indexPath.row];
    return [ApplyFriendCell heightWithContent:[dic objectForKey:@"applyMessage"]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - ApplyFriendCellDelegate

- (void)removeDataFromDataSource:(NSDictionary *)dic
{
    [self.dataSource removeObject:dic];
    [self.tableView reloadData];
}

- (void)applyCellAddFriendAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < [self.dataSource count]) {
        [self showHudInView:self.view hint:@"正在发送申请..."];
        NSMutableDictionary *dic = [self.dataSource objectAtIndex:indexPath.row];
        BOOL isGroup = [[dic objectForKey:@"isGroup"] boolValue];
        EMError *error;
        if (isGroup) {
            [[EaseMob sharedInstance].chatManager acceptInvitationFromGroup:[dic objectForKey:@"id"] error:&error];
        }
        else{
            [[EaseMob sharedInstance].chatManager acceptBuddyRequest:[dic objectForKey:@"username"] error:&error];
        }
        
        [self hideHud];
        if (!error) {
            [self removeDataFromDataSource:dic];
        }
        else{
            [self showHint:@"接受失败"];
        }
    }
}

- (void)applyCellRefuseFriendAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < [self.dataSource count]) {
        [self showHudInView:self.view hint:@"正在发送申请..."];
        NSMutableDictionary *dic = [self.dataSource objectAtIndex:indexPath.row];
        BOOL isGroup = [[dic objectForKey:@"isGroup"] boolValue];
        EMError *error;
        if (isGroup) {
            [[EaseMob sharedInstance].chatManager rejectInvitationForGroup:[dic objectForKey:@"id"] toInviter:[dic objectForKey:@"username"] reason:@""];
        }
        else{
            [[EaseMob sharedInstance].chatManager rejectBuddyRequest:[dic objectForKey:@"username"] reason:@"" error:&error];
        }
        
        [self hideHud];
        if (!error) {
            [self removeDataFromDataSource:dic];
        }
        else{
            [self showHint:@"拒绝失败"];
        }
    }
}

@end
