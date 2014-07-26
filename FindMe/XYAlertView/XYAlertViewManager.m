//
//  XYAlertViewManager.m
//  DDMates
//
//  Created by Samuel Liu on 7/25/12.
//  Copyright (c) 2012 TelenavSoftware, Inc. All rights reserved.
//

#import "XYAlertViewManager.h"
#import "XYLoadingView.h"
#import "XYAlertView.h"
#import "XYInputView.h"
#import "HDCodeView.h"
#import "GCPlaceholderTextView.h"
#import <AFNetworking.h>
#define AlertViewWidth 280.0f
#define AlertViewHeight 175.0f

CGRect XYScreenBounds()
{
    CGRect bounds = [UIScreen mainScreen].bounds;
    UIInterfaceOrientation orient = [UIApplication sharedApplication].statusBarOrientation;
    if (UIDeviceOrientationUnknown == orient)
        orient = UIInterfaceOrientationPortrait;

    if (UIInterfaceOrientationIsLandscape(orient))
    {
        CGFloat width = bounds.size.width;
        bounds.size.width = bounds.size.height;
        bounds.size.height = width;
    }
    return bounds;
}

@implementation XYAlertViewManager

static XYAlertViewManager *sharedAlertViewManager = nil;

+(XYAlertViewManager*)sharedAlertViewManager
{
    @synchronized(self)
    {
        if(!sharedAlertViewManager)
            sharedAlertViewManager = [[XYAlertViewManager alloc] init];
    }
    
    return sharedAlertViewManager;
}

-(id)init 
{
    self = [super init];
    if(self)
    {
        _alertViewQueue = [[NSMutableArray alloc] init];
        _isDismissing = NO;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didChangeOrientation:)
                                                     name:UIApplicationDidChangeStatusBarOrientationNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
    }
    
    return self;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    [_alertViewQueue removeAllObjects];
    [_loadingTimer invalidate];
}

#pragma mark - UIApplicationDidChangeStatusBarOrientationNotification

-(void)didChangeOrientation:(NSNotification*)notification
{
//    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    if(_alertViewQueue.count > 0)
    {
        CGRect screenBounds = XYScreenBounds();
        _blackBG.frame = CGRectMake(0, 0, screenBounds.size.width, screenBounds.size.height);
        _alertView.center = CGPointMake(screenBounds.size.width / 2, screenBounds.size.height / 2);
        _loadingLabel.frame = CGRectMake(0, _alertView.frame.origin.y + _alertView.frame.size.height + 10, screenBounds.size.width, 30);
    }
}

#pragma mark - private

-(UIImage*)buttonImageByStyle:(XYButtonStyle)style state:(UIControlState)state
{
    switch(style)
    {
        default:
        case XYButtonStyleGray:
            return [[UIImage imageNamed:(state == UIControlStateNormal ? @"alertView_button_gray.png" : @"alertView_button_gray_pressed.png")] stretchableImageWithLeftCapWidth:22 topCapHeight:22];
        case XYButtonStyleGreen:
            return [[UIImage imageNamed:(state == UIControlStateNormal ? @"alertView_button_green.png" : @"alertView_button_green_pressed.png")] stretchableImageWithLeftCapWidth:22 topCapHeight:22];
    }
}

-(void)prepareLoadingToDisplay:(XYLoadingView*)entity
{
    CGRect screenBounds = XYScreenBounds();
    if(!_blackBG)
    {
        _blackBG = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenBounds.size.width, screenBounds.size.height)];
        _blackBG.backgroundColor = [UIColor blackColor];
        _blackBG.opaque = YES;
        _blackBG.alpha = 0.5f;
        _blackBG.userInteractionEnabled = YES;
    }
    
    _blackBG.frame = CGRectMake(0, 0, screenBounds.size.width, screenBounds.size.height);
    
    _alertView = nil;
    _alertView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"alertView_loading.png"]];
    _alertView.center = CGPointMake(screenBounds.size.width / 2, screenBounds.size.height / 2);
    
    _loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, screenBounds.size.width, 30)];
    _loadingLabel.textAlignment = NSTextAlignmentCenter;
    _loadingLabel.backgroundColor = [UIColor clearColor];
    _loadingLabel.textColor = [UIColor whiteColor];
    _loadingLabel.font = [UIFont boldSystemFontOfSize:14];
    _loadingLabel.text = entity.message;
    _loadingLabel.numberOfLines = 2;
}

-(void)prepareAlertToDisplay:(XYAlertView*)entity
{
    CGRect screenBounds = XYScreenBounds();
    if(!_blackBG)
    {
        _blackBG = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenBounds.size.width, screenBounds.size.height)];
        _blackBG.backgroundColor = [UIColor blackColor];
        _blackBG.opaque = YES;
        _blackBG.alpha = 0.5f;
        _blackBG.userInteractionEnabled = YES;
    }
    
    _blackBG.frame = CGRectMake(0, 0, screenBounds.size.width, screenBounds.size.height);

    _alertView = nil;
    _alertView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"alertView_bg.png"] stretchableImageWithLeftCapWidth:34 topCapHeight:44]];
    _alertView.userInteractionEnabled = YES;
    _alertView.frame = CGRectMake(0, 0, AlertViewWidth, AlertViewHeight);
    _alertView.center = CGPointMake(screenBounds.size.width / 2, screenBounds.size.height / 2);

    UILabel *_titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 15, 240, 30)];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.font = [UIFont boldSystemFontOfSize:20];
    _titleLabel.text = entity.title;
    [_alertView addSubview:_titleLabel];
    
    UILabel *_messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 35, 240, 60)];
    _messageLabel.textAlignment = NSTextAlignmentLeft;
    _messageLabel.backgroundColor = [UIColor clearColor];
    _messageLabel.textColor = [UIColor whiteColor];
    _messageLabel.font = [UIFont boldSystemFontOfSize:14];
    _messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _messageLabel.numberOfLines = 3;
    _messageLabel.text = entity.message;
    [_alertView addSubview:_messageLabel];

    float buttonWidth = (AlertViewWidth - 100.0f) / entity.buttons.count;
    float buttonPadding = 100.0f / (entity.buttons.count - 1 + 2 * 2);
    
    for(int i = 0; i < entity.buttons.count; i++)
    {
        NSString *buttonTitle = [entity.buttons objectAtIndex:i];
        XYButtonStyle style = [[entity.buttonsStyle objectAtIndex:i] intValue];

        UIButton *_button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button setTitle:buttonTitle forState:UIControlStateNormal];
        _button.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        _button.titleLabel.shadowOffset = CGSizeMake(1, 1);
        [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_button setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_button setBackgroundImage:[self buttonImageByStyle:style state:UIControlStateNormal]
                           forState:UIControlStateNormal];
        [_button setBackgroundImage:[self buttonImageByStyle:style state:UIControlStateHighlighted]
                           forState:UIControlStateHighlighted];

        _button.frame = CGRectMake(buttonPadding * 2 + buttonWidth * i + buttonPadding * i, 107,
                                   buttonWidth, 44);
        _button.tag = i;

        [_button addTarget:self action:@selector(onButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [_alertView addSubview:_button];
    }
}

-(void)prepareInputToDisplay:(XYInputView*)entity
{
    CGRect screenBounds = XYScreenBounds();
    if(!_blackBG)
    {
        _blackBG = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenBounds.size.width, screenBounds.size.height)];
        _blackBG.backgroundColor = [UIColor blackColor];
        _blackBG.opaque = YES;
        _blackBG.alpha = 0.5f;
        _blackBG.userInteractionEnabled = YES;
    }
    
    _blackBG.frame = CGRectMake(0, 0, screenBounds.size.width, screenBounds.size.height);
    
    _alertView = nil;
    _alertView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"alertView_bg.png"] stretchableImageWithLeftCapWidth:34 topCapHeight:44]];
    _alertView.userInteractionEnabled = YES;
    _alertView.frame = CGRectMake(0, 0, AlertViewWidth, AlertViewHeight + 20);
    _alertView.center = CGPointMake(screenBounds.size.width / 2, screenBounds.size.height / 2);

    if(entity.title && entity.message)
    {
        UILabel *_titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 10, 240, 30)];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont boldSystemFontOfSize:20];
        _titleLabel.text = entity.title;
        [_alertView addSubview:_titleLabel];
        
        UILabel *_messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 40, 240, 20)];
        _messageLabel.textAlignment = NSTextAlignmentLeft;
        _messageLabel.backgroundColor = [UIColor clearColor];
        _messageLabel.textColor = [UIColor whiteColor];
        _messageLabel.font = [UIFont systemFontOfSize:14];
        _messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _messageLabel.numberOfLines = 1;
        _messageLabel.text = entity.message;
        [_alertView addSubview:_messageLabel];
        
        _textView = [[GCPlaceholderTextView alloc] initWithFrame:CGRectMake(30, 68, 220, 34)];
        _textView.backgroundColor = [UIColor clearColor];
        
        UIImageView *_inputBGView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"alertView_input_bg.png"] stretchableImageWithLeftCapWidth:50 topCapHeight:17]];
        _inputBGView.frame = CGRectMake(20, 68, 240, 34);
        [_alertView addSubview:_inputBGView];
    }
    else
    {
        _textView = [[GCPlaceholderTextView alloc] initWithFrame:CGRectMake(20, 15, 240, 95)];
        _textView.backgroundColor = [UIColor whiteColor];
    }

    _textView.returnKeyType = UIReturnKeyDone;
    _textView.delegate = self;
    _textView.placeholder = entity.placeholder;
    _textView.font = [UIFont systemFontOfSize:14];
    _textView.text = entity.initialText;

    [_alertView addSubview:_textView];
    
    float buttonWidth = (AlertViewWidth - 100.0f) / entity.buttons.count;
    float buttonPadding = 100.0f / (entity.buttons.count - 1 + 2 * 2);
    
    for(int i = 0; i < entity.buttons.count; i++)
    {
        NSString *buttonTitle = [entity.buttons objectAtIndex:i];
        XYButtonStyle style = [[entity.buttonsStyle objectAtIndex:i] intValue];
        
        UIButton *_button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button setTitle:buttonTitle forState:UIControlStateNormal];
        _button.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        _button.titleLabel.shadowOffset = CGSizeMake(1, 1);
        [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_button setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_button setBackgroundImage:[self buttonImageByStyle:style state:UIControlStateNormal]
                           forState:UIControlStateNormal];
        [_button setBackgroundImage:[self buttonImageByStyle:style state:UIControlStateHighlighted]
                           forState:UIControlStateHighlighted];
        
        _button.frame = CGRectMake(buttonPadding * 2 + buttonWidth * i + buttonPadding * i, 127,
                                   buttonWidth, 44);
        _button.tag = i;
        
        [_button addTarget:self action:@selector(onButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [_alertView addSubview:_button];
    }
}

-(void)prepareCodeViewToDisplay:(HDCodeView*)entity
{
    CGRect screenBounds = XYScreenBounds();
    if(!_blackBG)
    {
        _blackBG = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenBounds.size.width, screenBounds.size.height)];
        _blackBG.backgroundColor = [UIColor blackColor];
        _blackBG.opaque = YES;
        _blackBG.alpha = 0.5f;
        _blackBG.userInteractionEnabled = YES;
    }
    
    _blackBG.frame = CGRectMake(0, 0, screenBounds.size.width, screenBounds.size.height);
    
    _alertView = nil;
    _alertView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"codeAlertBg"] stretchableImageWithLeftCapWidth:34 topCapHeight:44]];
    _alertView.userInteractionEnabled = YES;
    _alertView.frame = CGRectMake(0, 0, AlertViewWidth, AlertViewHeight + 20);
    _alertView.center = CGPointMake(screenBounds.size.width / 2, screenBounds.size.height / 2);

        UILabel *_titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 240, 30)];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = HDRED;
        _titleLabel.font = [UIFont boldSystemFontOfSize:20];
        _titleLabel.text = @"请输入验证码";
        [_alertView addSubview:_titleLabel];
        
        
        _codeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 68, 90, 34)];
        _codeImageView.image = [UIImage imageNamed:@"loadingCode"];
        [_alertView addSubview:_codeImageView];
    

        
        UIButton *fresh = [[UIButton alloc] initWithFrame:CGRectMake(100, 68, 34, 34)];
        [fresh setImage:[UIImage imageNamed:@"codefresh"] forState:UIControlStateNormal];
        fresh.enabled = NO;
        [fresh addTarget:self action:@selector(fresh:) forControlEvents:UIControlEventTouchUpInside];
        [_alertView addSubview:fresh];
    
        [self getCodeUrl:entity.codeUrl and:fresh];
        
        _codeTextView = [[UITextField alloc] initWithFrame:CGRectMake(142, 68, 128, 34)];
        _codeTextView.backgroundColor = [UIColor clearColor];
        _codeTextView.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        UIImageView *_inputBGView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"code_input_bg.png"] stretchableImageWithLeftCapWidth:50 topCapHeight:17]];
        _inputBGView.frame = CGRectMake(140, 68, 130, 34);
        [_alertView addSubview:_inputBGView];
    
    
    _codeTextView.returnKeyType = UIReturnKeyDone;
    _codeTextView.placeholder = @"验证码";
    _codeTextView.font = [UIFont systemFontOfSize:14];
    
    [_alertView addSubview:_codeTextView];
    
    
    
    UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 126, 140, 60)];
    [button1 setImage:[UIImage imageNamed:@"x"] forState:UIControlStateNormal];
    button1.tag = 0;
    [button1 addTarget:self action:@selector(onButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(140, 126, 140, 60)];
    [button2 setImage:[UIImage imageNamed:@"sure"] forState:UIControlStateNormal];
    button2.tag = 1;
    [button2 addTarget:self action:@selector(onButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [_alertView addSubview:button1];
    [_alertView addSubview:button2];
}

-(void)fresh:(UIButton *)sender{
    sender.enabled = NO;
    _codeImageView.image = [UIImage imageNamed:@"loadingCode"];
    NSString *urlStr = [NSString stringWithFormat:@"%@/data/user/auth_code.do",Host];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    __weak __typeof(&*self)weakSelf = self;
    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *codeInfo = [responseObject objectForKey:@"codeInfo"];
        if ([[codeInfo objectForKey:@"hashCode"] boolValue]) {
            NSString *codeName = [codeInfo objectForKey:@"codeName"];
            if (codeName!=nil) {
                NSString *codeUrl = [NSString stringWithFormat:@"%@/upload/code/%@",Host,codeName];
                [weakSelf getCodeUrl:codeUrl and:sender];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

-(void)getCodeUrl:(NSString *)codeUrl and:(UIButton *)freshButton{
    
    NSMutableURLRequest *myRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:codeUrl] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    [NSURLConnection sendAsynchronousRequest:myRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        [_codeImageView setImage:[UIImage imageWithData:data]];
        if (freshButton!=nil) {
            freshButton.enabled = YES;
        }
    }];

}


-(void)updateLoadingAnimation
{
    CGAffineTransform transform = _alertView.transform;
    transform = CGAffineTransformRotate(transform, M_PI / 20);
    _alertView.transform = transform;
}

-(void)checkoutInStackAlertView
{
    if(_alertViewQueue.count > 0)
    {
        id entity = [_alertViewQueue lastObject];

        [_loadingTimer invalidate];
        _loadingTimer = nil;
        [_alertView removeFromSuperview];
        [_blackBG removeFromSuperview];
        [_loadingLabel removeFromSuperview];
        
        if([entity isKindOfClass:[XYAlertView class]])
        {
            [self prepareAlertToDisplay:entity];
            [self showAlertViewWithAnimation:entity];
        }
        else if([entity isKindOfClass:[XYLoadingView class]])
        {
            [self prepareLoadingToDisplay:entity];
            [self showLoadingViewWithAnimation:entity];
        }
        else if([entity isKindOfClass:[XYInputView class]])
        {
            [self prepareInputToDisplay:entity];
            [self showInputViewWithAnimation:entity];
        }else if([entity isKindOfClass:[HDCodeView class]])
        {
            [self prepareCodeViewToDisplay:entity];
            [self showCodeViewWithAnimation:entity];
        }
    }
}

-(void)onButtonTapped:(id)sender
{
    [self dismiss:[_alertViewQueue lastObject] button:((UIButton*)sender).tag];
}

#pragma mark - animation

-(void)showAlertViewWithAnimation:(id)entity
{
    if([entity isKindOfClass:[XYAlertView class]])
    {
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        if(!keyWindow)
        {
            NSArray *windows = [UIApplication sharedApplication].windows;
            if(windows.count > 0)
//            keyWindow = [windows lastObject];
            keyWindow = [windows objectAtIndex:0];
        }
        UIView *containerView = [[keyWindow subviews] objectAtIndex:0];
        
        _blackBG.alpha = 0.0f;
        CGRect frame = _alertView.frame;
        frame.origin.y = -AlertViewHeight;
        _alertView.frame = frame;
        [containerView addSubview:_blackBG];
        [containerView addSubview:_alertView];
        
        [UIView animateWithDuration:0.2f animations:^{
            _blackBG.alpha = 0.5f;
            _alertView.center = CGPointMake(XYScreenBounds().size.width / 2, XYScreenBounds().size.height / 2);
        }
                         completion:^(BOOL finished) {
                             
                         }];
    }
}

-(void)dismissAlertViewWithAnimation:(id)entity button:(int)buttonIndex
{
    if([entity isKindOfClass:[XYAlertView class]])
    {
        [UIView animateWithDuration:0.2f
                         animations:
         ^{
             _blackBG.alpha = 0.0f;
             CGRect frame = _alertView.frame;
             frame.origin.y = -AlertViewHeight;
             _alertView.frame = frame;
         }
                         completion:^(BOOL finished)
         {
             [_alertView removeFromSuperview];
             [_blackBG removeFromSuperview];
             
             [_alertViewQueue removeLastObject];
             _isDismissing = NO;

             if(((XYAlertView*)entity).blockAfterDismiss)
                 ((XYAlertView*)entity).blockAfterDismiss(buttonIndex);

             [self checkoutInStackAlertView];
         }];
    }
}

-(void)showLoadingViewWithAnimation:(id)entity
{
    if([entity isKindOfClass:[XYLoadingView class]])
    {
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        if(!keyWindow)
        {
            NSArray *windows = [UIApplication sharedApplication].windows;
            if(windows.count > 0)
//            keyWindow = [windows lastObject];
            keyWindow = [windows objectAtIndex:0];
        }
        UIView *containerView = [[keyWindow subviews] objectAtIndex:0];
        
        _blackBG.alpha = 0.0f;
        CGRect frame = _alertView.frame;
        frame.origin.y = -AlertViewHeight;
        _alertView.frame = frame;
        frame = _loadingLabel.frame;
        frame.origin.y = XYScreenBounds().size.height;
        _loadingLabel.frame = frame;
        [containerView addSubview:_blackBG];
        [containerView addSubview:_alertView];
        [containerView addSubview:_loadingLabel];
        
        _loadingTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(updateLoadingAnimation) userInfo:nil repeats:YES];
        
        [UIView animateWithDuration:0.2f animations:^{
            _blackBG.alpha = 0.5f;
            _alertView.center = CGPointMake(XYScreenBounds().size.width / 2, XYScreenBounds().size.height / 2);
            CGRect frame = _loadingLabel.frame;
            frame.origin.y = _alertView.frame.origin.y + _alertView.frame.size.height + 10;
            _loadingLabel.frame = frame;
        }
                         completion:^(BOOL finished) {
                         }];
    }
}

-(void)dismissLoadingViewWithAnimation:(id)entity
{
    if([entity isKindOfClass:[XYLoadingView class]])
    {
        [UIView animateWithDuration:0.2f
                         animations:
         ^{
             _blackBG.alpha = 0.0f;
             CGRect frame = _alertView.frame;
             frame.origin.y = -AlertViewHeight;
             _alertView.frame = frame;
             frame = _loadingLabel.frame;
             frame.origin.y = XYScreenBounds().size.height;
             _loadingLabel.frame = frame;
         }
                         completion:^(BOOL finished)
         {
             [_loadingTimer invalidate];
             _loadingTimer = nil;
             [_alertView removeFromSuperview];
             [_blackBG removeFromSuperview];
             [_loadingLabel removeFromSuperview];

             [_alertViewQueue removeLastObject];

             _isDismissing = NO;

             [self checkoutInStackAlertView];
         }];
    }
}

-(void)showInputViewWithAnimation:(id)entity
{
    if([entity isKindOfClass:[XYInputView class]])
    {
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        if(!keyWindow)
        {
            NSArray *windows = [UIApplication sharedApplication].windows;
            if(windows.count > 0)
//            keyWindow = [windows lastObject];
            keyWindow = [windows objectAtIndex:0];
        }
        UIView *containerView = [[keyWindow subviews] objectAtIndex:0];
        
        _blackBG.alpha = 0.0f;
        CGRect frame = _alertView.frame;
        frame.origin.y = -AlertViewHeight;
        _alertView.frame = frame;
        [containerView addSubview:_blackBG];
        [containerView addSubview:_alertView];
        
        [UIView animateWithDuration:0.2f animations:^{
            _blackBG.alpha = 0.5f;
            _alertView.center = CGPointMake(XYScreenBounds().size.width / 2, XYScreenBounds().size.height / 2);
        }
                         completion:^(BOOL finished) {
                             
                         }];
    }
}
-(void)showCodeViewWithAnimation:(id)entity
{
    if([entity isKindOfClass:[HDCodeView class]])
    {
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        if(!keyWindow)
        {
            NSArray *windows = [UIApplication sharedApplication].windows;
            if(windows.count > 0)
                //            keyWindow = [windows lastObject];
                keyWindow = [windows objectAtIndex:0];
        }
        UIView *containerView = [[keyWindow subviews] objectAtIndex:0];
        
        _blackBG.alpha = 0.0f;
        CGRect frame = _alertView.frame;
        frame.origin.y = -AlertViewHeight;
        _alertView.frame = frame;
        [containerView addSubview:_blackBG];
        [containerView addSubview:_alertView];
        
        [UIView animateWithDuration:0.2f animations:^{
            _blackBG.alpha = 0.5f;
            _alertView.center = CGPointMake(XYScreenBounds().size.width / 2, XYScreenBounds().size.height / 2);
        }
                         completion:^(BOOL finished) {
                             
                         }];
    }
}
-(void)dismissInputViewWithAnimation:(id)entity button:(int)buttonIndex
{
    if([entity isKindOfClass:[XYInputView class]]||[entity isKindOfClass:[HDCodeView class]])
    {
        [UIView animateWithDuration:0.2f
                         animations:
         ^{
             _blackBG.alpha = 0.0f;
             CGRect frame = _alertView.frame;
             frame.origin.y = -AlertViewHeight;
             _alertView.frame = frame;
         }
                         completion:^(BOOL finished)
         {
             [_alertView removeFromSuperview];
             [_blackBG removeFromSuperview];
             
             [_alertViewQueue removeLastObject];
             _isDismissing = NO;
             if ([entity isKindOfClass:[XYInputView class]]) {
                 if(((XYInputView*)entity).blockAfterDismiss)
                     ((XYInputView*)entity).blockAfterDismiss(buttonIndex, _textView.text);
             }else if ([entity isKindOfClass:[HDCodeView class]]){
                 if(((HDCodeView*)entity).blockAfterDismiss)
                     ((HDCodeView*)entity).blockAfterDismiss(buttonIndex, _codeTextView.text);
             }

             
             [self checkoutInStackAlertView];
         }];
    }
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"])
    {
        id entity = [_alertViewQueue lastObject];
        if(entity && [entity isKindOfClass:[XYInputView class]])
        {
            _isDismissing = YES;
            [self dismissInputViewWithAnimation:entity button:1];
            
            return NO;
        }
        else
        {
            return YES;
        }
    }
    else
    {
        return YES;
    }
}

#pragma mark - keyboard

-(void)changeLayoutByKeyboardTop:(CGFloat)keyboardTop andAnimationDuration:(double)animationDuration
{
    if(_isDismissing)
        return;

    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:animationDuration];
	
    if(_alertViewQueue.count > 0)
    {
        CGRect screenBounds = XYScreenBounds();
        _blackBG.frame = CGRectMake(0, 0, screenBounds.size.width, screenBounds.size.height);
        _alertView.center = CGPointMake(screenBounds.size.width / 2, keyboardTop / 2);
        _loadingLabel.frame = CGRectMake(0, _alertView.frame.origin.y + _alertView.frame.size.height + 10, screenBounds.size.width, 30);
    }
    
	[UIView commitAnimations];
}

-(void)keyboardWillShow:(NSNotification *)notification
{
    CGRect endRect = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];

	double animationDuration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    if(animationDuration == 0) animationDuration = 0.25;
	
    float keyboardTop = 0;
    UIInterfaceOrientation orient = [UIApplication sharedApplication].statusBarOrientation;
    if (UIDeviceOrientationUnknown == orient)
        orient = UIInterfaceOrientationPortrait;
    
    if (UIInterfaceOrientationIsLandscape(orient))
        keyboardTop = endRect.origin.x;
    else
        keyboardTop = endRect.origin.y;

    if(keyboardTop > 0)
        [self changeLayoutByKeyboardTop:keyboardTop andAnimationDuration:animationDuration];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    CGRect endRect = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];

	double animationDuration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    if(animationDuration == 0) animationDuration = 0.25;
	
    float keyboardTop = 0;
    UIInterfaceOrientation orient = [UIApplication sharedApplication].statusBarOrientation;
    if (UIDeviceOrientationUnknown == orient)
        orient = UIInterfaceOrientationPortrait;
    
    if (UIInterfaceOrientationIsLandscape(orient))
        keyboardTop = endRect.origin.x;
    else
        keyboardTop = endRect.origin.y;
    
    if(keyboardTop > 0)
        [self changeLayoutByKeyboardTop:keyboardTop andAnimationDuration:animationDuration];
}

#pragma mark - public

-(XYAlertView*)showAlertView:(NSString*)message
{
    XYAlertView *alertView = [XYAlertView alertViewWithTitle:@"注意"
                                                     message:message
                                                     buttons:[NSArray arrayWithObjects:@"确定", nil]
                                                afterDismiss:nil];
    [self show:alertView];
    
    return alertView;
}

-(XYLoadingView*)showLoadingView:(NSString*)message
{
    XYLoadingView *loadingView = [XYLoadingView loadingViewWithMessage:message];
    [self show:loadingView];
    
    return loadingView;
}

-(void)show:(id)entity
{
    if([entity isKindOfClass:[XYAlertView class]] ||
       [entity isKindOfClass:[XYLoadingView class]] ||
       [entity isKindOfClass:[XYInputView class]]||
       [entity isKindOfClass:[HDCodeView class]])
    {
        if(_isDismissing == YES && _alertViewQueue.count > 0)
        {
            [_alertViewQueue insertObject:entity atIndex:_alertViewQueue.count - 1];
        }
        else
        {
            [_alertViewQueue addObject:entity];
            
            [_loadingTimer invalidate];
            _loadingTimer = nil;
            [_alertView removeFromSuperview];
            [_blackBG removeFromSuperview];
            [_loadingLabel removeFromSuperview];
            
            if([entity isKindOfClass:[XYAlertView class]])
            {
                [self prepareAlertToDisplay:entity];
                [self showAlertViewWithAnimation:entity];
            }
            else if([entity isKindOfClass:[XYLoadingView class]])
            {
                [self prepareLoadingToDisplay:entity];
                [self showLoadingViewWithAnimation:entity];
            }
            else if([entity isKindOfClass:[XYInputView class]])
            {
                [self prepareInputToDisplay:entity];
                [self showInputViewWithAnimation:entity];
            }else if ([entity isKindOfClass:[HDCodeView class]]){
                [self prepareCodeViewToDisplay:entity];
                [self showCodeViewWithAnimation:entity];
            }
        }
    }
}

-(void)dismiss:(id)entity
{
    [self dismiss:entity button:0];
}

-(void)dismiss:(id)entity button:(int)buttonIndex
{
    if(_alertViewQueue.count <= 0)
        return;

    if([entity isKindOfClass:[XYAlertView class]] ||
       [entity isKindOfClass:[XYLoadingView class]] ||
       [entity isKindOfClass:[XYInputView class]]||
       [entity isKindOfClass:[HDCodeView class]])
    {
        _isDismissing = YES;
        if ([entity isKindOfClass:[HDCodeView class]]) {
            [_codeTextView resignFirstResponder];
        }else{
            [_textView resignFirstResponder];
        }

        if([entity isEqual:[_alertViewQueue lastObject]])
        {
            if([entity isKindOfClass:[XYAlertView class]])
                [self dismissAlertViewWithAnimation:entity button:buttonIndex];
            else if([entity isKindOfClass:[XYLoadingView class]])
                [self dismissLoadingViewWithAnimation:entity];
            else if([entity isKindOfClass:[XYInputView class]])
                [self dismissInputViewWithAnimation:entity button:buttonIndex];
            else if ([entity isKindOfClass:[HDCodeView class]])
                [self dismissInputViewWithAnimation:entity button:buttonIndex];
        }
        else
        {
            [_alertViewQueue removeObject:entity];
            if([entity isKindOfClass:[XYAlertView class]])
                ((XYAlertView*)entity).blockAfterDismiss(buttonIndex);
        }
    }
}

-(void)dismissLoadingView:(id)entity withFailedMessage:(NSString*)message
{
    if(_alertViewQueue.count <= 0)
        return;
    
    if([entity isEqual:[_alertViewQueue lastObject]] && [entity isKindOfClass:[XYLoadingView class]])
    {
        _isDismissing = YES;

        XYAlertView *alertView = [XYAlertView alertViewWithTitle:@"注意"
                                                         message:message
                                                         buttons:[NSArray arrayWithObjects:@"确定", nil]
                                                    afterDismiss:nil];
        
        [_alertViewQueue insertObject:alertView atIndex:_alertViewQueue.count - 1];

        [self dismissLoadingViewWithAnimation:entity];
    }
}

-(void)cleanupAllViews
{
    [_loadingTimer invalidate];
    _loadingTimer = nil;
    [_alertView removeFromSuperview];
    _alertView = nil;
    [_blackBG removeFromSuperview];
    [_loadingLabel removeFromSuperview];
    [_textView resignFirstResponder];

    [_alertViewQueue removeAllObjects];
}

@end
