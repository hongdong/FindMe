//
//  FeedbackViewController.m
//  FindMe
//
//  Created by mac on 14-7-15.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "FeedbackViewController.h"

@interface FeedbackViewController ()

@end

@implementation FeedbackViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.textView becomeFirstResponder];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.textView resignFirstResponder];
}
- (IBAction)submit:(UIButton *)sender {
    __weak __typeof(&*self)weakSelf = self;
    sender.selected = !sender.selected;
    [self.view endEditing:YES];
    [HDTool showHUD:@"逗你玩"];
    if (sender.selected) {
        [self performBlock:^{
            [HDTool successHUD];
            weakSelf.text.hidden = NO;
        } afterDelay:1.0];
    }else{
        [self performBlock:^{
            [HDTool errorHUD];
            weakSelf.text.hidden = YES;
        } afterDelay:1.0];
    }

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
- (void)performBlock:(void(^)())block afterDelay:(NSTimeInterval)delay {
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), block);
}

@end
