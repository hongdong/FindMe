//
//  PostDetailViewController.m
//  FindMe
//
//  Created by mac on 14-7-2.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "PostDetailViewController.h"
#import "PostDetailHeadView.h"
#import "PostDetailHeadView1.h"
#import "CommentCell.h"
#import "UIImageView+WebCache.h"
#import "Comment.h"
#import "UIScrollView+EmptyDataSet.h"
#import "MJRefresh.h"
#import "MCFireworksButton.h"
#import "NSString+HD.h"
#import "HYCircleLoadingView.h"
@interface PostDetailViewController ()<DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>{
    
    NSMutableArray *_dataArr;
    double animationDuration;
    CGRect keyboardRect;
    id _head;
    NSString *_didChange;
    NSDictionary *_index;
    ZBMessageViewState _nowState;
    HYCircleLoadingView *_circleLoadingView;
}
@property (weak, nonatomic) IBOutlet MCFireworksButton *likeButton;

@end

@implementation PostDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _circleLoadingView = [[HYCircleLoadingView alloc]initWithFrame:CGRectMake(0, 0, 26, 26)];
    UIBarButtonItem *loadingItem = [[UIBarButtonItem alloc]initWithCustomView:_circleLoadingView];
    self.navigationItem.rightBarButtonItem = loadingItem;
    
    _dataArr = [[NSMutableArray alloc] init];
    
    
//	self.likeButton.particleImage = [UIImage imageNamed:@"Sparkle"];
	self.likeButton.particleScale = 0.05;
    self.likeButton.particleScaleRange = 0.02;
    self.likeButton.enabled = NO;
    [self.likeButton setImage:[UIImage imageNamed:@"marks"] forState:UIControlStateSelected];
    
    if (self.post.postPhoto==nil) {
        _head = [HDTool loadCustomViewByIndex:PostDetailHeadView1Index];
        [(PostDetailHeadView1 *)_head setDataWithPost:self.post];
    }else{
        _head = [HDTool loadCustomViewByIndex:PostDetailHeadViewIndex];
        [(PostDetailHeadView *)_head setDataWithPost:self.post];
        
    }
    self.tableView.tableHeaderView = _head;
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    
    self.navigationItem.title = @"小秘密";
    _didChange = @"0";
    [self initilzer];
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    
    [self getCommentByType:@"nl"];
    
}

- (void)footerRereshing
{
    [self getCommentByType:@"ol"];
}


-(void)getCommentByType:(NSString *)type{
    [_circleLoadingView startAnimation];
    NSString *index;
    if ([type isEqualToString:@"ol"]) {
        index = [_index objectForKey:@"endIndex"];
    }else{
        index = @"0";
    }
    if (index==nil) {
        [self.tableView footerEndRefreshing];
        return;
    }
    NSDictionary *parameters = @{@"postId": self.post._id,
                                 @"type":type,
                                 @"index":index,
                                 @"isNews":@"0"};
    __weak __typeof(&*self)weakSelf = self;
    [HDNet GET:@"/data/post/post_msg_list.do" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [_circleLoadingView stopAnimation];
        [weakSelf.tableView footerEndRefreshing];
        NSDictionary *postMsg = [responseObject objectForKey:@"postMsg"];
        if (postMsg!=nil) {
            if ([[postMsg objectForKey:@"isPraise"] boolValue]) {
                weakSelf.likeButton.selected = YES;
            }
            weakSelf.likeButton.enabled = YES;
            _index = [postMsg objectForKey:@"index"];
            NSArray *arr = [postMsg objectForKey:@"postMsgList"];
            if (arr!=nil) {
                if ([type isEqualToString:@"nl"]) {
                    [_dataArr removeAllObjects];
                }
                [_dataArr addObjectsFromArray:[Comment objectArrayWithKeyValuesArray:arr]];
                [weakSelf.tableView reloadData];
            }else{
            }
            
        }else{
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_circleLoadingView stopAnimation];
        [weakSelf.tableView footerEndRefreshing];
    }];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.messageToolView.messageInputTextView resignFirstResponder];
    [self hideInputBar];
}
- (IBAction)closeButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)replyPressed:(id)sender {
    if (![[Config sharedConfig] isOnline]) {
        [self showHint:@"请先登入"];
        return;
    }
    [self.messageToolView.messageInputTextView becomeFirstResponder];
}
- (IBAction)prisePressed:(id)sender {
    if (![[Config sharedConfig] isOnline]) {
        [self showHint:@"请先登入"];
        return;
    }
    self.likeButton.enabled = NO;
    NSString *type;
    if (self.likeButton.selected) {
        type = @"c";
        [self.likeButton popInsideWithDuration:0.4];
    }else{
        type = @"p";
        [self.likeButton popOutsideWithDuration:0.5];
        [self.likeButton animate];
    }
    
    NSDictionary *parameters = @{@"postId": self.post._id,
                                 @"type":type};
    __weak __typeof(&*self)weakSelf = self;
    
    [HDNet GET:@"/data/post/post_praise.do" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *state = [responseObject objectForKey:@"state"];
        if ([state isEqualToString:@"20001"]) {
            _didChange = @"1";
            weakSelf.likeButton.selected = !weakSelf.likeButton.selected;
            if (weakSelf.likeButton.selected) {
                weakSelf.post.postPraise = [NSNumber numberWithInt:[weakSelf.post.postPraise intValue]+1];
            }else{
                weakSelf.post.postPraise = [NSNumber numberWithInt:[weakSelf.post.postPraise intValue]-1];
            }
            
            [weakSelf resetHead];
            weakSelf.likeButton.enabled = YES;
        }else{
            
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}
-(void)resetHead{
    if (_post.postPhoto==nil) {
        
        [((PostDetailHeadView1 *)_head) setDataWithPost:self.post];
    }else{
        
        [((PostDetailHeadView *)_head) setDataWithPost:self.post];
    }
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(keyboardWillShow:)
                                                name:UIKeyboardWillShowNotification
                                              object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(keyboardWillHide:)
                                                name:UIKeyboardWillHideNotification
                                              object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(keyboardChange:)
                                                name:UIKeyboardDidChangeFrameNotification
                                              object:nil];
}

- (void)dealloc{
    self.messageToolView = nil;
    self.faceView = nil;
    self.delegate = nil;
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardDidChangeFrameNotification object:nil];
}
#pragma mark -keyboard
- (void)keyboardWillHide:(NSNotification *)notification{
    
    keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    animationDuration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
}

- (void)keyboardWillShow:(NSNotification *)notification{
    [HDTool noGes:self];
    keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    animationDuration= [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
}

- (void)keyboardChange:(NSNotification *)notification{
    if ([[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y<CGRectGetHeight(self.view.frame)) {//如果键盘不是收起来
        [self messageViewAnimationWithMessageRect:[[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue]
                         withMessageInputViewRect:self.messageToolView.frame
                                      andDuration:0.25
                                         andState:ZBMessageViewStateShowNone];
    }
}

-(void)hideInputBar{
    __weak __typeof(&*self)weakSelf = self;
    [UIView animateWithDuration:animationDuration animations:^{
        weakSelf.messageToolView.frame = CGRectMake(0.0f,self.view.frame.size.height,CGRectGetWidth(self.view.frame),CGRectGetHeight(self.messageToolView.frame));
    } completion:^(BOOL finished) {
            [HDTool ges:weakSelf];
    }];
}

-(void)hideFaceView{
    [UIView animateWithDuration:animationDuration animations:^{

        self.faceView.frame = CGRectMake(0.0f,CGRectGetHeight(self.view.frame),CGRectGetWidth(self.view.frame),CGRectGetHeight(self.faceView.frame));
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - messageView animation
- (void)messageViewAnimationWithMessageRect:(CGRect)rect  withMessageInputViewRect:(CGRect)inputViewRect andDuration:(double)duration andState:(ZBMessageViewState)state{
    
    [UIView animateWithDuration:duration animations:^{
        self.messageToolView.frame = CGRectMake(0.0f,CGRectGetHeight(self.view.frame)-CGRectGetHeight(rect)-CGRectGetHeight(inputViewRect),CGRectGetWidth(self.view.frame),CGRectGetHeight(inputViewRect));
        
        switch (state) {
            case ZBMessageViewStateShowFace:
            {
                self.faceView.frame = CGRectMake(0.0f,CGRectGetHeight(self.view.frame)-CGRectGetHeight(rect),CGRectGetWidth(self.view.frame),CGRectGetHeight(rect));
                
            }
                break;
            case ZBMessageViewStateShowNone:
            {
                self.faceView.frame = CGRectMake(0.0f,CGRectGetHeight(self.view.frame),CGRectGetWidth(self.view.frame),CGRectGetHeight(self.faceView.frame));
                
            }
                break;
            case ZBMessageViewStateShowShare:
            {
                
                self.faceView.frame = CGRectMake(0.0f,CGRectGetHeight(self.view.frame),CGRectGetWidth(self.view.frame),CGRectGetHeight(self.faceView.frame));
            }
                break;
                
            default:
                break;
        }
        
    } completion:^(BOOL finished) {
        
    }];
}
#pragma end

#pragma mark - 初始化
- (void)initilzer{
    
    CGFloat inputViewHeight;
    
    if (iOS7) {
        inputViewHeight = 45.0f;
    }
    else{
        inputViewHeight = 40.0f;
    }
    self.messageToolView = [[ZBMessageInputView alloc]initWithFrame:CGRectMake(0.0f,
                                                                               self.view.frame.size.height,self.view.frame.size.width,inputViewHeight)];
    self.messageToolView.delegate = self;
    [self.view addSubview:self.messageToolView];
    
    [self shareFaceView];
    
}

- (void)shareFaceView{
    
    if (!self.faceView)
    {
        self.faceView = [[ZBMessageManagerFaceView alloc]initWithFrame:CGRectMake(0.0f,
                                                                                  CGRectGetHeight(self.view.frame), CGRectGetWidth(self.view.frame), 196)];
        self.faceView.delegate = self;
        [self.view addSubview:self.faceView];
        
    }
}

- (void)didSendTextAction:(ZBMessageTextView *)messageInputTextView{
    [self.messageToolView.messageInputTextView resignFirstResponder];
    
    [self hideInputBar];
    [self hideFaceView];
    [HDTool showHUD:@"发送中..."];

    NSDictionary *parameters = @{@"postId": self.post._id,
                                 @"postMsgContent":self.messageToolView.messageInputTextView.text};
    __weak __typeof(&*self)weakSelf = self;
    
    [HDNet POST:@"/data/post/post_msg.do" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *state = [responseObject objectForKey:@"state"];
        if ([state isEqualToString:@"20001"]) {
            [HDTool dismissHUD];
            weakSelf.post.postMsgNumber = [NSNumber numberWithInt:[weakSelf.post.postMsgNumber intValue]+1];
            _didChange = @"1";
            [weakSelf resetHead];
            
            [weakSelf getCommentByType:@"nl"];
            
            weakSelf.messageToolView.messageInputTextView.text = @"";
            weakSelf.messageToolView.sendButton.enabled = NO;
            
        }else{
            [HDTool errorHUD];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [HDTool errorHUD];
    }];
    
}

- (void)didSendFaceAction:(BOOL)sendFace{//切换表情键盘
    if (sendFace) {
        [self messageViewAnimationWithMessageRect:self.faceView.frame
                         withMessageInputViewRect:self.messageToolView.frame
                                      andDuration:animationDuration
                                         andState:ZBMessageViewStateShowFace];
    }
    else{
        [self messageViewAnimationWithMessageRect:keyboardRect
                         withMessageInputViewRect:self.messageToolView.frame
                                      andDuration:animationDuration
                                         andState:ZBMessageViewStateShowNone];
    }
}

/*
 * 点击输入框代理方法
 */
- (void)inputTextViewWillBeginEditing:(ZBMessageTextView *)messageInputTextView{
    
}

- (void)inputTextViewDidBeginEditing:(ZBMessageTextView *)messageInputTextView
{
    [self messageViewAnimationWithMessageRect:keyboardRect
                     withMessageInputViewRect:self.messageToolView.frame
                                  andDuration:animationDuration
                                     andState:ZBMessageViewStateShowNone];
    
    if (!self.previousTextViewContentHeight)
    {
        self.previousTextViewContentHeight = messageInputTextView.contentSize.height;
    }
}

- (void)inputTextViewDidChange:(ZBMessageTextView *)messageInputTextView
{

    if ([messageInputTextView.text isOK]) {
        _messageToolView.sendButton.enabled = YES;
    }else{
        _messageToolView.sendButton.enabled = NO;
    }
    
    CGFloat maxHeight = [ZBMessageInputView maxHeight];
    CGSize size = [messageInputTextView sizeThatFits:CGSizeMake(CGRectGetWidth(messageInputTextView.frame), maxHeight)];
    CGFloat textViewContentHeight = size.height;
    
    // End of textView.contentSize replacement code
    BOOL isShrinking = textViewContentHeight < self.previousTextViewContentHeight;
    CGFloat changeInHeight = textViewContentHeight - self.previousTextViewContentHeight;
    
    if(!isShrinking && self.previousTextViewContentHeight == maxHeight) {
        changeInHeight = 0;
    }
    else {
        changeInHeight = MIN(changeInHeight, maxHeight - self.previousTextViewContentHeight);
    }
    
    if(changeInHeight != 0.0f) {
        
        [UIView animateWithDuration:0.01f
                         animations:^{
                             
                             if(isShrinking) {
                                 // if shrinking the view, animate text view frame BEFORE input view frame
                                 [self.messageToolView adjustTextViewHeightBy:changeInHeight];
                             }
                             
                             CGRect inputViewFrame = self.messageToolView.frame;
                             self.messageToolView.frame = CGRectMake(0.0f,
                                                                     inputViewFrame.origin.y - changeInHeight,
                                                                     inputViewFrame.size.width,
                                                                     inputViewFrame.size.height + changeInHeight);
                             
                             if(!isShrinking) {
                                 [self.messageToolView adjustTextViewHeightBy:changeInHeight];
                             }
                         }
                         completion:^(BOOL finished) {
                             
                         }];
        
        self.previousTextViewContentHeight = MIN(textViewContentHeight, maxHeight);
    }
}

#pragma mark - ZBMessageFaceViewDelegate
- (void)SendTheFaceStr:(NSString *)faceStr isDelete:(BOOL)dele
{
    
    NSString *chatText = self.messageToolView.messageInputTextView.text;
    
    if (!dele && faceStr.length > 0) {
        self.messageToolView.messageInputTextView.text = [NSString stringWithFormat:@"%@%@",chatText,faceStr];
    }
    else {
        if (chatText.length >= 4)
        {
            NSString *subStr = [chatText substringFromIndex:chatText.length-4];
            NSString *plistStr = [[NSBundle mainBundle] pathForResource:@"expression" ofType:@"plist"];
            NSDictionary *plistDic = [[NSDictionary  alloc]initWithContentsOfFile:plistStr];

            if ([[plistDic allKeys] containsObject:subStr]) {
                self.messageToolView.messageInputTextView.text = [chatText substringToIndex:chatText.length-4];
                [self inputTextViewDidChange:self.messageToolView.messageInputTextView];
                return;
            }
        }
        
        if (chatText.length > 0) {
            self.messageToolView.messageInputTextView.text = [chatText substringToIndex:chatText.length-1];
        }
    }
    
//    self.messageToolView.messageInputTextView.text = [self.messageToolView.messageInputTextView.text stringByAppendingString:faceStr];
    [self inputTextViewDidChange:self.messageToolView.messageInputTextView];
    
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


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}


-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self hideInputBar];
    [self.view endEditing:YES];
    [self hideFaceView];
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{//计算行高
    
    return [((Comment *)_dataArr[indexPath.row]) getMatch].height + 40;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseID = @"commentCell";
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[CommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
    NSString *commentUserId = [((Comment *)_dataArr[indexPath.row]).postMsgUser objectForKey:@"_id"];
    if ([commentUserId isEqualToString:[self.post.postUser objectForKey:@"_id"]]) {
        cell.hostLbl.hidden = NO;
    }
    cell.comment = _dataArr[indexPath.row];
    cell.row = indexPath.row;

    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];

    if ([_didChange isEqualToString:@"1"]&&self.delegate) {
        [self.delegate changeRowWithPost:self.post];
    }

}


#pragma mark - DZNEmptyDataSetSource Methods

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView{
    return YES;
}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = nil;
    UIFont *font = nil;
    UIColor *textColor = nil;
    
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    text = @"吐槽星人";
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
    text = @"怎么能不吐槽";
    font = [UIFont systemFontOfSize:13.0];
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
    return [UIImage imageNamed:@"face"];
}
- (CGPoint)offsetForEmptyDataSet:(UIScrollView *)scrollView
{
        return CGPointMake(0, 0);

}

@end
