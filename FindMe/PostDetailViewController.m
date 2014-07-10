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
#import "AFNetworking.h"
#import "Comment.h"

@interface PostDetailViewController (){
    
    NSArray *_dataArr;
    double animationDuration;
    CGRect keyboardRect;
    NSString *_flag;
    id _head;
}

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
    self.navigationItem.title = @"小秘密";
    _flag = @"p";
    [self initilzer];
    [self getCommentByType:@"nl"];
}

-(void)getCommentByType:(NSString *)type{
    NSString *urlStr = [NSString stringWithFormat:@"%@/data/post/post_msg_list.do",Host];
    
    NSDictionary *parameters = @{@"postId": self.post._id,
                                 @"type":type,
                                 @"index":@"0",
                                 @"isNews":@"0"};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    __weak __typeof(&*self)weakSelf = self;
    [manager GET:urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *postMsg = [responseObject objectForKey:@"postMsg"];
        if (postMsg!=nil) {
            if ([[postMsg objectForKey:@"isPraise"] boolValue]) {
                [weakSelf.priseButton setImage:[UIImage imageNamed:@"marks"] forState:UIControlStateNormal];

                _flag = @"c";
            }
            weakSelf.priseButton.enabled = YES;
            NSArray *arr = [postMsg objectForKey:@"postMsgList"];
            if (arr!=nil) {
                _dataArr = [Comment objectArrayWithKeyValuesArray:arr];
                [weakSelf.tableView reloadData];
            }else{
                NSLog(@"暂时没有回复");
            }
            
        }else{
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        

        
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
    [self.messageToolView.messageInputTextView becomeFirstResponder];
}
- (IBAction)prisePressed:(id)sender {
    self.priseButton.enabled = NO;
    NSString *urlStr = [NSString stringWithFormat:@"%@/data/post/post_praise.do",Host];
    
    NSDictionary *parameters = @{@"postId": self.post._id,
                                 @"type":_flag};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    __weak __typeof(&*self)weakSelf = self;
    [manager GET:urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *state = [responseObject objectForKey:@"state"];
        if ([state isEqualToString:@"20001"]) {
            NSLog(@"操作完成");
            _flag = [_flag isEqualToString:@"c"]?@"p":@"c";
            if ([_flag isEqualToString:@"c"]) {
                [weakSelf.priseButton setImage:[UIImage imageNamed:@"marks"] forState:UIControlStateNormal];
                weakSelf.post.postPraise = [NSNumber numberWithInt:[weakSelf.post.postPraise intValue]+1];

            }else{
                [weakSelf.priseButton setImage:[UIImage imageNamed:@"mark"] forState:UIControlStateNormal];
                weakSelf.post.postPraise = [NSNumber numberWithInt:[weakSelf.post.postPraise intValue]-1];

            }
            [weakSelf resetHead];
            weakSelf.priseButton.enabled = YES;
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
    keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    animationDuration= [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
}

- (void)keyboardChange:(NSNotification *)notification{
    if ([[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y<CGRectGetHeight(self.view.frame)) {
        [self messageViewAnimationWithMessageRect:[[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue]
                         withMessageInputViewRect:self.messageToolView.frame
                                      andDuration:0.25
                                         andState:ZBMessageViewStateShowNone];
    }
}

-(void)hideInputBar{
    [UIView animateWithDuration:animationDuration animations:^{
        self.messageToolView.frame = CGRectMake(0.0f,self.view.frame.size.height,CGRectGetWidth(self.view.frame),CGRectGetHeight(self.messageToolView.frame));
    } completion:^(BOOL finished) {
        
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
    [self showHudInView:self.view hint:@"发送中..."];
    NSString *urlStr = [NSString stringWithFormat:@"%@/data/post/post_msg.do",Host];

    NSDictionary *parameters = @{@"postId": self.post._id,
                                 @"postMsgContent":self.messageToolView.messageInputTextView.text};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    __weak __typeof(&*self)weakSelf = self;
    [manager POST:urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [weakSelf hideHud];
        NSString *state = [responseObject objectForKey:@"state"];
        if ([state isEqualToString:@"20001"]) {
            weakSelf.post.postMsgNumber = [NSNumber numberWithInt:[weakSelf.post.postMsgNumber intValue]+1];
            [weakSelf showResultWithType:ResultSuccess];
            [weakSelf resetHead];
            [weakSelf getCommentByType:@"nl"];
            weakSelf.messageToolView.messageInputTextView.text = @"";
            weakSelf.messageToolView.sendButton.enabled = NO;

        }else{
            [weakSelf showResultWithType:ResultError];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
            [weakSelf showResultWithType:ResultError];
        
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
    
    NSString *text = [messageInputTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if(text.length==0)
    {
        self.messageToolView.sendButton.enabled = NO;
    }else{
        self.messageToolView.sendButton.enabled = YES;
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
        if (chatText.length >= 2)
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


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (self.post.postPhoto==nil) {
        _head = [HDTool loadCustomViewByIndex:5];
        [(PostDetailHeadView1 *)_head setDataWithPost:self.post];
    }else{
        _head = [HDTool loadCustomViewByIndex:0];
        [(PostDetailHeadView *)_head setDataWithPost:self.post];

    }

    return _head;
}




- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 300;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{

    return [[UIView alloc] init];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self hideInputBar];
    [self.view endEditing:YES];
    [self hideFaceView];
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{//计算行高
    
    return [CommentCell getHeight:_dataArr[indexPath.row]];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseID = @"commentCell";
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[CommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
    
    cell.comment = _dataArr[indexPath.row];
    cell.row = indexPath.row;

    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
