//
//  ZBMessageInputView.m
//  MessageDisplay
//
//  Created by zhoubin@moshi on 14-5-10.
//  Copyright (c) 2014年 Crius_ZB. All rights reserved.
//

#import "ZBMessageInputView.h"
#import "NSString+Message.h"

@interface ZBMessageInputView()<UITextViewDelegate>

@property (nonatomic, weak, readwrite) ZBMessageTextView *messageInputTextView;

@property (nonatomic, strong, readwrite) UIButton *faceSendButton;

@property (nonatomic, strong, readwrite) UIButton *sendButton;

@property (nonatomic, copy) NSString *inputedText;

@end

@implementation ZBMessageInputView

- (void)dealloc{
    _messageInputTextView.delegate = nil;
    _messageInputTextView = nil;
    _faceSendButton = nil;
    _sendButton = nil;
}

#pragma mark - Action

- (void)messageStyleButtonClicked:(UIButton *)sender {

            
            sender.selected = !sender.selected;
            if (sender.selected) {
                [self.messageInputTextView resignFirstResponder];
            }else{
                [self.messageInputTextView becomeFirstResponder];
            }
            
            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.messageInputTextView.hidden = NO;
            } completion:^(BOOL finished) {
                
            }];
            
            if ([self.delegate respondsToSelector:@selector(didSendFaceAction:)]) {
                [self.delegate didSendFaceAction:sender.selected];
            }
    

}

#pragma mark - 添加控件
- (void)setupMessageInputViewBarWithStyle:(ZBMessageInputViewStyle )style{
    // 配置输入工具条的样式和布局
    
    // 水平间隔
    CGFloat horizontalPadding = 8;
    
    // 垂直间隔
    CGFloat verticalPadding = 5;
    
    // 按钮长,宽
    CGFloat buttonSize = [ZBMessageInputView textViewLineHeight];
    
    // 发送表情
    self.faceSendButton = [self createButtonWithImage:[UIImage imageNamed:@"emotion"]
                                              HLImage:nil];
    [self.faceSendButton setImage:[UIImage imageNamed:@"keyboard"]
                         forState:UIControlStateSelected];
    [self.faceSendButton addTarget:self
                            action:@selector(messageStyleButtonClicked:)
                  forControlEvents:UIControlEventTouchUpInside];
    self.faceSendButton.tag = 1;
    [self addSubview:self.faceSendButton];
    self.faceSendButton.frame = CGRectMake(horizontalPadding,verticalPadding,buttonSize,buttonSize);
    
    
    // 初始化输入框
    ZBMessageTextView *textView = [[ZBMessageTextView alloc] initWithFrame:CGRectZero];
    textView.returnKeyType = UIReturnKeySend;
    textView.enablesReturnKeyAutomatically = YES; // UITextView内部判断send按钮是否可以用
    textView.placeHolder = @"发送新评论";
    textView.delegate = self;
    [self addSubview:textView];
	self.messageInputTextView = textView;
    
    self.sendButton = [self createButtonWithImage:[UIImage imageNamed:@"sendButton"]
                                          HLImage:nil];
    [self.sendButton addTarget:self
                            action:@selector(sendButtonPressed:)
                  forControlEvents:UIControlEventTouchUpInside];
    self.sendButton.frame = CGRectMake(self.frame.size.width - 2*buttonSize- horizontalPadding,verticalPadding,70,buttonSize);

    [self addSubview:self.sendButton];
    self.sendButton.enabled = NO;
    // 配置不同iOS SDK版本的样式
    
    CGRect frame;
    switch (style)
    {
        case ZBMessageInputViewStyleQuasiphysical:
        {
            frame = CGRectMake(horizontalPadding + buttonSize +5.0f,
                                                     3.0f,
                                                     CGRectGetWidth(self.bounds)- 3*buttonSize -2*horizontalPadding- 15.0f,
                                                     buttonSize);
            _messageInputTextView.backgroundColor = [UIColor whiteColor];
            
            break;
        }
        case ZBMessageInputViewStyleDefault:
        {
            frame = CGRectMake(horizontalPadding + buttonSize +5.0f,4.5f,CGRectGetWidth(self.bounds)- 3*buttonSize -2*horizontalPadding- 15.0f,buttonSize);
            _messageInputTextView.backgroundColor = [UIColor clearColor];
            _messageInputTextView.layer.borderColor = [UIColor colorWithWhite:0.8f alpha:1.0f].CGColor;
            _messageInputTextView.layer.borderWidth = 0.65f;
            _messageInputTextView.layer.cornerRadius = 6.0f;
    
            break;
        }
        default:
            break;
    }
    
    self.messageInputTextView.frame = frame;

}

-(void)sendButtonPressed:(id)sender{
    if ([self.delegate respondsToSelector:@selector(didSendTextAction:)]) {
        [self.delegate didSendTextAction:self.messageInputTextView];
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

#pragma mark - layout subViews UI
- (UIButton *)createButtonWithImage:(UIImage *)image HLImage:(UIImage *)hlImage {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectZero];
    if (image)
        [button setBackgroundImage:image forState:UIControlStateNormal];
    if (hlImage)
        [button setBackgroundImage:hlImage forState:UIControlStateHighlighted];
    return button;
}

- (UIButton *)createSendButtonWithImage:(UIImage *)image HLImage:(UIImage *)hlImage {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectZero];
    if (image)
        [button setBackgroundImage:image forState:UIControlStateNormal];
    if (hlImage)
        [button setBackgroundImage:hlImage forState:UIControlStateHighlighted];
    return button;
}
#pragma end

#pragma mark - Message input view

- (void)adjustTextViewHeightBy:(CGFloat)changeInHeight {
    // 动态改变自身的高度和输入框的高度
    CGRect prevFrame = self.messageInputTextView.frame;
    
    NSUInteger numLines = MAX([self.messageInputTextView numberOfLinesOfText],
                              [self.messageInputTextView.text numberOfLines]);
    
    self.messageInputTextView.frame = CGRectMake(prevFrame.origin.x,
                                          prevFrame.origin.y,
                                          prevFrame.size.width,
                                          prevFrame.size.height + changeInHeight);
    
    
    self.messageInputTextView.contentInset = UIEdgeInsetsMake((numLines >= 6 ? 4.0f : 0.0f),
                                                       0.0f,
                                                       (numLines >= 6 ? 4.0f : 0.0f),
                                                       0.0f);
    
    // from iOS 7, the content size will be accurate only if the scrolling is enabled.
    self.messageInputTextView.scrollEnabled = YES;
    
    if (numLines >= 6) {
        CGPoint bottomOffset = CGPointMake(0.0f, self.messageInputTextView.contentSize.height - self.messageInputTextView.bounds.size.height);
        [self.messageInputTextView setContentOffset:bottomOffset animated:YES];
        [self.messageInputTextView scrollRangeToVisible:NSMakeRange(self.messageInputTextView.text.length - 2, 1)];
    }
}

+ (CGFloat)textViewLineHeight{
    return 36.0f ;// 字体大小为16
}

+ (CGFloat)maxHeight{
    return ([ZBMessageInputView maxLines] + 1.0f) * [ZBMessageInputView textViewLineHeight];
}

+ (CGFloat)maxLines{
    return ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) ? 3.0f : 8.0f;
}
#pragma end

- (void)setup {
    // 配置自适应
    self.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin);
    self.opaque = YES;
    // 由于继承UIImageView，所以需要这个属性设置
    self.userInteractionEnabled = YES;
    
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7 )
    {
        _messageInputViewStyle = ZBMessageInputViewStyleDefault;
        self.image = [[UIImage imageNamed:@"input-bar-flat"] resizableImageWithCapInsets:UIEdgeInsetsMake(2.0f, 0.0f, 0.0f, 0.0f)
                                                                            resizingMode:UIImageResizingModeStretch];
    }
    else
    {
        _messageInputViewStyle = ZBMessageInputViewStyleQuasiphysical;
        self.image = [[UIImage imageNamed:@"input-bar-background"] resizableImageWithCapInsets:UIEdgeInsetsMake(19.0f, 3.0f, 19.0f, 3.0f)
                                                                                  resizingMode:UIImageResizingModeStretch];
        
    }
    [self setupMessageInputViewBarWithStyle:_messageInputViewStyle];
}

#pragma mark - textViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
   
    if ([self.delegate respondsToSelector:@selector(inputTextViewWillBeginEditing:)])
    {
        [self.delegate inputTextViewWillBeginEditing:self.messageInputTextView];
    }
    self.faceSendButton.selected = NO;
   
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView{
    
    NSString *text = [textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if(text.length==0)
    {
        self.sendButton.enabled = NO;
    }else{
        self.sendButton.enabled = YES;
    }
    if ([self.delegate respondsToSelector:@selector(inputTextViewDidChange:)]) {
        [self.delegate inputTextViewDidChange:self.messageInputTextView];
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    [textView becomeFirstResponder];
    
    if ([self.delegate respondsToSelector:@selector(inputTextViewDidBeginEditing:)]) {
        [self.delegate inputTextViewDidBeginEditing:self.messageInputTextView];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    [textView resignFirstResponder];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        if ([self.delegate respondsToSelector:@selector(didSendTextAction:)]) {
            [self.delegate didSendTextAction:self.messageInputTextView];
        }
        return NO;
    }
//    else if ([text isEqualToString:@""]){
//
//        NSString *chatText = textView.text;
//        if (textView.text.length>=4) {
//            NSString *subStr = [chatText substringFromIndex:chatText.length-4];
//            NSString *plistStr = [[NSBundle mainBundle] pathForResource:@"expression" ofType:@"plist"];
//            NSDictionary *plistDic = [[NSDictionary  alloc]initWithContentsOfFile:plistStr];
//            
//            if ([[plistDic allKeys] containsObject:subStr]) {
//                textView.text = [chatText substringToIndex:chatText.length-4];
//            }else{
//                textView.text = [chatText substringToIndex:chatText.length-1];
//            }
//        }else if(textView.text.length>0){
//            textView.text = [chatText substringToIndex:chatText.length-1];
//        }
//
//        [self textViewDidChange:textView];
//        return NO;
//        
//    }
    return YES;
}
#pragma end



@end
