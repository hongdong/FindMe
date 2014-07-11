//
//  IdentifyViewController.m
//  FindMe
//
//  Created by mac on 14-7-8.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "IdentifyViewController.h"
#import "User.h"
@interface IdentifyViewController (){
    User *_user;
}

@end

@implementation IdentifyViewController

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
    _user = [User getUserFromNSUserDefaults];
    self.schoolLbl.text = [_user getSchoolName];
    [self setUpForDismissKeyboard];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
- (void)setUpForDismissKeyboard {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    UITapGestureRecognizer *singleTapGR =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(tapAnywhereToDismissKeyboard:)];
    singleTapGR.delegate = self;
    NSOperationQueue *mainQuene =[NSOperationQueue mainQueue];
    [nc addObserverForName:UIKeyboardWillShowNotification
                    object:nil
                     queue:mainQuene
                usingBlock:^(NSNotification *note){
                    [self.view addGestureRecognizer:singleTapGR];
                }];
    [nc addObserverForName:UIKeyboardWillHideNotification
                    object:nil
                     queue:mainQuene
                usingBlock:^(NSNotification *note){
                    [self.view removeGestureRecognizer:singleTapGR];
                }];
}

- (void)tapAnywhereToDismissKeyboard:(UIGestureRecognizer *)gestureRecognizer {
    //此method会将self.view里所有的subview的first responder都resign掉
    [self.view endEditing:YES];
}
- (IBAction)idenButtonPressed:(id)sender {
    NSLog(@"认证中");
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.schoolId becomeFirstResponder];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.schoolId resignFirstResponder];
    [self.schoolPwd resignFirstResponder];
    [self.view endEditing:YES];
}

@end
