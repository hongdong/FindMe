//
//  LoginViewController.h
//  FindMe
//
//  Created by mac on 14-6-21.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginView.h"

@interface FindMeViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *photo;
@property (weak, nonatomic) IBOutlet UILabel *grade;
@property (weak, nonatomic) IBOutlet UIImageView *sex;
@property (weak, nonatomic) IBOutlet UILabel *nickname;
@property (weak, nonatomic) IBOutlet UIImageView *xzimg;
@property (weak, nonatomic) IBOutlet UILabel *xzLbl;
@property (weak, nonatomic) IBOutlet UILabel *schoolLbl;
@property (weak, nonatomic) IBOutlet UILabel *departmentLbl;
@property (weak, nonatomic) IBOutlet UILabel *qianmingLbl;

@property (weak, nonatomic) IBOutlet UIButton *likeBt;
@property (weak, nonatomic) IBOutlet UIButton *passBt;

@end
