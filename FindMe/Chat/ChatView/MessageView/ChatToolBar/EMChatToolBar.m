/************************************************************
  *  * EaseMob CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of EaseMob Technologies.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from EaseMob Technologies.
  */

#import "EMChatToolBar.h"

@interface EMChatToolBar () <UITextViewDelegate,HPGrowingTextViewDelegate>{
    UIView *_moreView;
    UIView *_recordView;
    UITableView *_showTableView;
    UIButton *_showTextViewButton;
    NSString *_saveMessage;
}

@property (weak, nonatomic) IBOutlet UIButton *switchButton;
@property (weak, nonatomic) IBOutlet UIButton *moreButton;
@property (weak, nonatomic) IBOutlet UIButton *recordButton;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;


- (IBAction)switchButtonPressed:(id)sender;
- (IBAction)moreButtonPressed:(UIButton *)sender;
- (IBAction)sendButtonPressed:(id)sender;

-(IBAction)recordButtonTouchDown:(UIButton *)sender;
-(IBAction)recordButtonTouchUpInside:(UIButton *)sender;
-(IBAction)recordButtonTouchUpOutside:(UIButton *)sender;
-(IBAction)recordButtonDragInside:(UIButton *)sender;
-(IBAction)recordButtonDragOutside:(UIButton *)sender;

-(void)registerNotifications;
-(void)unregisterNotifications;

@end

@implementation EMChatToolBar


-(id)initWithViewController:(UIViewController <EMChatToolBarDelegate> *)viewController {
    
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"EMChatToolBar" owner:self options:nil];
    self = [nib objectAtIndex:0];
    if (self) {
        // 得到对应要显示的元素
        _dependController = viewController;
        _moreView = [_dependController chatBarMoreView];
        _showTableView = [_dependController chatBarTableView];
        _recordView = [_dependController chatBarRecordView];
        // 调整位置到最下
        CGRect frame = self.frame;
        self.frame = CGRectMake(self.frame.origin.x, _dependController.view.frame.size.height - self.frame.size.height, self.frame.size.width, self.frame.size.height);
        frame.origin.y = _dependController.view.frame.size.height - self.frame.size.height;
        self.frame = frame;
        [_dependController.view addSubview:self];
        
        _textView.isScrollable = NO;
        _textView.contentInset = UIEdgeInsetsMake(0, 3, 0, 3);
        _textView.minNumberOfLines = 1;
        _textView.maxNumberOfLines = 5;
        _textView.returnKeyType = UIReturnKeySend;
        _textView.font = [UIFont systemFontOfSize:15.0f];
        _textView.delegate = self;
        _textView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(3, 0, 3, 0);
        _textView.backgroundColor = [UIColor whiteColor];
        [_textView.layer setCornerRadius:3.0];
        [_textView.layer setMasksToBounds:YES];
        _showTextViewButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _showTextViewButton.frame = _textView.bounds;
        [_textView addSubview:_showTextViewButton];
        [_showTextViewButton setHidden:YES];
        [_showTextViewButton addTarget:self action:@selector(showKeyBoard)
                      forControlEvents:UIControlEventTouchDown];
        [_moreButton setImage:[UIImage imageNamed:@"chatBar_more"] forState:UIControlStateNormal];
        [_moreButton setImage:[UIImage imageNamed:@"chatBar_moreSelected"] forState:UIControlStateHighlighted];
        
        [_switchButton setImage:[UIImage imageNamed:@"chatBar_record"] forState:UIControlStateNormal];
        [_switchButton setImage:[UIImage imageNamed:@"chatBar_keyboard"] forState:UIControlStateSelected];
        [_switchButton setImage:[UIImage imageNamed:@"chatBar_recordSelected"] forState:UIControlStateSelected | UIControlStateHighlighted];
        [_switchButton setImage:[UIImage imageNamed:@"chatBar_keyboardSelected"] forState:UIControlStateSelected | UIControlStateHighlighted];
        
        [_recordButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _recordButton.layer.cornerRadius = 3.0;
        [_recordButton setBackgroundColor:[UIColor whiteColor]];
        
        [_sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sendButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        
        if (_recordView != nil) {
            _recordView.hidden = YES;
            [_dependController.view addSubview:_recordView];
        }
        
        [self registerNotifications];
    }
    return self;
}

-(void)dealloc
{
    [self unregisterNotifications];
}

#pragma mark - getter

#pragma mark - subviews

- (void)setupSubviewsForRecord:(BOOL)isRecord
{
    if (isRecord) {
        self.textView.text = @"";
        [self.textView resignFirstResponder];
    }
    self.sendButton.hidden = isRecord;
    self.textView.hidden = isRecord;
    self.recordButton.hidden = !isRecord;
}

- (void)showKeyBoard{
    [self decideInputView:nil];
    [_showTextViewButton setHidden:YES];
}

#pragma mark - action

- (IBAction)moreButtonPressed:(UIButton *)sender
{
    self.moreButton.selected = !self.moreButton.selected;
    
    if (_dependController && [_dependController
                              respondsToSelector:@selector(chatBarMoreButtonPressed)]) {
        [_dependController chatBarMoreButtonPressed];
    }
    
    [self decideInputView:_moreView];
}

- (IBAction)switchButtonPressed:(UIButton *)sender
{
    self.switchButton.selected = !self.switchButton.selected;
    [self setupSubviewsForRecord:self.switchButton.selected];
    if (_dependController && [_dependController
                              respondsToSelector:@selector(chatBarSwitchButtonPressed)]) {
        [_dependController chatBarSwitchButtonPressed];
    }
}

- (IBAction)sendButtonPressed:(id)sender
{
    if ([_dependController respondsToSelector:@selector(chatBarTextReturn:)]) {
        [_dependController chatBarTextReturn:self.textView.text];
    }
    self.textView.text = @"";
}

- (IBAction)recordButtonTouchDown:(UIButton *)sender
{
    [self recordButtonPressed];
    if (_dependController && [_dependController respondsToSelector:@selector(recordButtonTouchDown:)]) {
        [_dependController recordButtonTouchDown:_recordView];
    }
    if (_recordView) {
        [_recordView setHidden:NO];
    }
}

- (IBAction)recordButtonTouchUpInside:(UIButton *)sender
{
    [self recordButtonUp];
    if (_dependController && [_dependController respondsToSelector:@selector(recordButtonTouchUpInside:)]) {
        [_dependController recordButtonTouchUpInside:_recordView];
    }
    if (_recordView) {
        [_recordView setHidden:YES];
    }
}

- (IBAction)recordButtonTouchUpOutside:(UIButton *)sender
{
    [self recordButtonUp];
    if (_dependController && [_dependController respondsToSelector:@selector(recordButtonTouchUpOutside:)]) {
        [_dependController recordButtonTouchUpOutside:_recordView];
    }
    if (_recordView) {
        [_recordView setHidden:YES];
    }
}

- (IBAction)recordButtonDragInside:(UIButton *)sender
{
    [self recordButtonPressed];
    if (_dependController && [_dependController respondsToSelector:@selector(recordButtonDragInside:)]) {
        [_dependController recordButtonDragInside:_recordView];
    }
}

- (IBAction)recordButtonDragOutside:(UIButton *)sender
{
    [self recordButtonUp];
    if (_dependController && [_dependController respondsToSelector:@selector(recordButtonDragOutside:)]) {
        [_dependController recordButtonDragOutside:_recordView];
    }
}

#pragma mark - private

-(void)registerNotifications
{
    [self unregisterNotifications];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(keyboardWillShow:)
                                                name:UIKeyboardWillShowNotification
                                              object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

-(void)unregisterNotifications
{
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:UIKeyboardWillShowNotification
                                                 object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:UIKeyboardWillHideNotification
                                                 object:nil];
}

// textView变化引起的tableView的变化
-(void)setTableViewByTextViewChangeHeight:(CGFloat)height{
    if (height == 0) {
        return;
    }
    if (_showTableView) {
        // 动画之前，先判断 是否要移动该table
        CGFloat keyBoardHeight = CGRectGetHeight(_showTableView.frame) - self.frame.origin.y;
        if (keyBoardHeight + _showTableView.contentSize.height > CGRectGetHeight(_showTableView.frame)) {
            [UIView animateWithDuration:0 animations:^(){
                _showTableView.contentOffset = CGPointMake(0, _showTableView.contentOffset.y + height);
                UIEdgeInsets contentInset = UIEdgeInsetsMake(0.0, 0.0, _showTableView.contentInset.bottom + height, 0.0);;
                _showTableView.contentInset = contentInset;
                _showTableView.scrollIndicatorInsets = contentInset;
                
            } completion:^(BOOL finish){
                
            }];
            
        }
    }
}

-(void)showTableOffSetChangeByInputViewChange:(CGFloat)height{
    // 根据是否遮挡，以及遮挡多少来判断tableOffset移动多少
    if (_showTableView) {
        CGFloat keyBoardHegiht = CGRectGetHeight( _dependController.view.frame) - self.frame.origin.y;
        CGFloat tableHeight = CGRectGetHeight(_showTableView.frame);
        CGFloat tableContentHeight = _showTableView.contentSize.height;
        if (tableContentHeight > tableHeight) {
            _showTableView.contentOffset = CGPointMake(0, _showTableView.contentOffset.y - height);
        }else if (tableHeight > tableContentHeight && tableHeight - tableContentHeight < keyBoardHegiht){
            CGFloat mostHeight = keyBoardHegiht + tableContentHeight - tableHeight;
            if (mostHeight > height) {
                _showTableView.contentOffset = CGPointMake(0, _showTableView.contentOffset.y - height);
            }
        }
    }
}

-(void)recordButtonPressed
{
    [_recordButton setTitle:@"松开发送" forState:UIControlStateNormal];
}

-(void)recordButtonUp
{
    [_recordButton setTitle:@"按住说话" forState:UIControlStateNormal];
}

#pragma mark - HPGrowingTextViewDelegate

- (void)growingTextViewDidBeginEditing:(HPGrowingTextView *)growingTextView
{
    [self.textView.internalTextView reloadInputViews];
    [self.textView.internalTextView becomeFirstResponder];
}

- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    float diff = (growingTextView.frame.size.height - height);
	CGRect r = self.frame;
    r.size.height -= diff;
    r.origin.y += diff;
	self.frame = r;
    [self showTableOffSetChangeByInputViewChange:diff];
}

- (BOOL)growingTextViewShouldReturn:(HPGrowingTextView *)growingTextView
{
    if ([_dependController respondsToSelector:@selector(chatBarTextReturn:)]) {
        [_dependController chatBarTextReturn:self.textView.text];
    }
    self.textView.text = @"";
    
    return YES;
}

- (void)growingTextViewDidEndEditing:(HPGrowingTextView *)growingTextView
{
    [self.textView.internalTextView setInputView:nil];
}

#pragma mark - Notification

-(void)keyboardWillShow:(NSNotification *)aNotification
{
    NSValue *animationDurationValue = [aNotification.userInfo
                                       objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    //获取到键盘frame变化之后的frame
    NSValue *keyboardEndBounds = [[aNotification userInfo]objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect endRect = [keyboardEndBounds CGRectValue];
    
    CGFloat keyBoardHeight = CGRectGetHeight(endRect) + CGRectGetHeight(self.frame) - 44;
    
    // 得到变化时间
    CGFloat duration = [[[aNotification userInfo]
                         objectForKey:UIKeyboardAnimationDurationUserInfoKey]
                        floatValue];
    if (duration <= 0) {
        // 是否加额外动画时间补偿
    }
    
	[UIView animateWithDuration:duration animations:^(){
        // bar位置变换
        CGRect frame = self.frame;
        frame.origin.y = CGRectGetHeight(_dependController.view.frame) - CGRectGetHeight(endRect) - CGRectGetHeight(self.frame);
        self.frame = frame;
        
        if (_showTableView) {
            UIEdgeInsets contentInsets;
            CGFloat tableHeight = CGRectGetHeight(_showTableView.frame);
            CGFloat tableContentHeight = _showTableView.contentSize.height;
            
            // 1. 全部遮挡 contentSize.height > tableView的高度
            if (tableContentHeight > tableHeight) {
                _showTableView.contentOffset = CGPointMake(0, _showTableView.contentOffset.y + keyBoardHeight);
                // 2. 部分遮挡  0 < tableHeight - contentHeight < 键盘的高度
            }else if(tableHeight > tableContentHeight &&
                     tableHeight - tableContentHeight < keyBoardHeight){
                // 计算需要移动的距离
                CGFloat changeHeight = tableContentHeight + keyBoardHeight - tableHeight;
                _showTableView.contentOffset = CGPointMake(0,  _showTableView.contentOffset.y + changeHeight);
            }
            contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyBoardHeight, 0.0);
            _showTableView.contentInset = contentInsets;
            _showTableView.scrollIndicatorInsets = contentInsets;
        }
    } completion:^(BOOL finish){
        
    }];
}

-(void)keyboardWillHide:(NSNotification *)aNotification{
    
    CGFloat duration = [[[aNotification userInfo]
                         objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    //获取到键盘frame变化之后的frame
    NSValue *keyboardEndBounds = [[aNotification userInfo]objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect endRect = [keyboardEndBounds CGRectValue];
    
    CGFloat keyBoardHeight = CGRectGetHeight(self.frame) + CGRectGetHeight(endRect) - 44;
    
   	[UIView animateWithDuration:duration animations:^(){
        CGRect frame = self.frame;
        frame.origin.y = CGRectGetHeight( _dependController.view.frame) - frame.size.height;
        self.frame = frame;
        
        if (_showTableView) {
            CGFloat tableHeight = CGRectGetHeight(_showTableView.frame);
            CGFloat tableContentHeight = _showTableView.contentSize.height;
            
            // 1.完全遮挡 contentHeight > tableHeight
            if (tableContentHeight > tableHeight) {
                // 判断是否需要移动table
                if (_showTableView.contentOffset.y >= keyBoardHeight) {
                    _showTableView.contentOffset = CGPointMake(0, _showTableView.contentOffset.y - keyBoardHeight);
                }
                // 2.部分遮挡 tableHeight > contentHeight && tableHeight - contentHeight > keyBoardHeight
            }else if (tableHeight > tableContentHeight && tableHeight - tableContentHeight < keyBoardHeight){
                // 计算需要移动的距离
                CGFloat changeHeight = tableContentHeight + keyBoardHeight - tableHeight;
                _showTableView.contentOffset = CGPointMake(0, _showTableView.contentOffset.y - changeHeight);
            }
            _showTableView.contentInset = UIEdgeInsetsZero;
            _showTableView.scrollIndicatorInsets = UIEdgeInsetsZero;
        }
    } completion:^(BOOL finish){
        
    }];
}

#pragma mark - public

-(void)decideInputView:(UIView *)usedView
{
    [self.textView.internalTextView becomeFirstResponder];
    
    if (self.textView.internalTextView.inputView == usedView) {
        self.textView.internalTextView.inputView = nil;
        [_showTextViewButton setHidden:YES];
    }else {
        self.textView.internalTextView.inputView = usedView;
        [_showTextViewButton setHidden:NO];
    }
    
    [self.textView.internalTextView reloadInputViews];
}

- (void)switchToText
{
    if (!self.switchButton.selected) {
        return;
    }
    
    [self switchButtonPressed:self.switchButton];
}

- (void)switchToRecord
{
    if (self.switchButton.selected) {
        return;
    }
    
    [self switchButtonPressed:self.switchButton];
}

@end
