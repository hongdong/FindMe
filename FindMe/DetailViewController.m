//
//  DetailViewController.m
//  FindMe
//
//  Created by mac on 14-7-4.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "DetailViewController.h"
#import "JMWhenTapped.h"
#import "UIImageView+WebCache.h"
#import "XYAlertViewHeader.h"
@interface DetailViewController ()

@end

@implementation DetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    __weak __typeof(&*self)weakSelf = self;
    
    [self.nicknameView whenTouchedDown:^{
        weakSelf.nicknameView.backgroundColor = [UIColor lightGrayColor];
    }];
    [self.nicknameView whenTouchedUp:^{
        weakSelf.nicknameView.backgroundColor = [UIColor whiteColor];
        XYInputView *inputView = [XYInputView inputViewWithTitle:@"修改小名"
                                                         message:@"显示给别人看的昵称"
                                                     placeholder:@"说些什么吧"
                                                     initialText:nil
                                                         buttons:[NSArray arrayWithObjects:@"放弃", @"确定", nil]
                                                    afterDismiss:^(int buttonIndex, NSString *text) {
                                                        if(buttonIndex == 1)
                                                            NSLog(@"text: %@", text);
                                                    }];
        [inputView setButtonStyle:XYButtonStyleGreen atIndex:1];
        [inputView show];
    }];
    
    [self.qianmingView whenTouchedDown:^{
        weakSelf.qianmingView.backgroundColor = [UIColor lightGrayColor];
    }];
    [self.qianmingView whenTouchedUp:^{
        weakSelf.qianmingView.backgroundColor = [UIColor whiteColor];
        XYInputView *inputView = [XYInputView inputViewWithTitle:@"修改签名"
                                                         message:@"展示个性签名"
                                                     placeholder:@"说些什么吧"
                                                     initialText:nil
                                                         buttons:[NSArray arrayWithObjects:@"放弃", @"确定", nil]
                                                    afterDismiss:^(int buttonIndex, NSString *text) {
                                                        if(buttonIndex == 1)
                                                            NSLog(@"text: %@", text);
                                                    }];
        [inputView setButtonStyle:XYButtonStyleGreen atIndex:1];
        [inputView show];
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
