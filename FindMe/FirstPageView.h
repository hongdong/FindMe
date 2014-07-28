//
//  FirstPageView.h
//  FindMe
//
//  Created by mac on 14-7-5.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
@interface FirstPageView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *photo;
@property (strong, nonatomic) UILabel *realNameLbl;
@property (strong, nonatomic) UIImageView *sex;
@property (strong, nonatomic) UIImageView *vUserImg;

@property (strong,nonatomic) User *user;

@end
