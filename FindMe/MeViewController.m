//
//  MeViewController.m
//  FindMe
//
//  Created by mac on 14-7-4.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "MeViewController.h"
#import "User.h"
#import "UIImageView+WebCache.h"
#import "JMWhenTapped.h"
@interface MeViewController ()

@end

@implementation MeViewController

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
    User *user = [User getUserFromNSUserDefaults];
    self.photo.layer.cornerRadius = 25.0f;
    self.photo.layer.masksToBounds = YES;
    [self.photo setImageWithURL:[NSURL URLWithString:user.userPhoto]];
    self.nickname.text = user.userNickName;
    __weak __typeof(&*self)weakSelf = self;
    
    [self.detailView whenTouchedDown:^{
        weakSelf.detailView.backgroundColor = [UIColor lightGrayColor];
    }];
    [self.detailView whenTouchedUp:^{
        weakSelf.detailView.backgroundColor = [UIColor whiteColor];
        [self performSegueWithIdentifier:@"editInfo" sender:nil];
    }];
    
    [self.photoWallView whenTouchedDown:^{
        weakSelf.photoWallView.backgroundColor = [UIColor lightGrayColor];
    }];
    [self.photoWallView whenTouchedUp:^{
        weakSelf.photoWallView.backgroundColor = [UIColor whiteColor];
    }];
    
    [self.addVView whenTouchedDown:^{
        weakSelf.addVView.backgroundColor = [UIColor lightGrayColor];
    }];
    [self.addVView whenTouchedUp:^{
        weakSelf.addVView.backgroundColor = [UIColor whiteColor];
    }];
    
    [self.shareView whenTouchedDown:^{
        weakSelf.shareView.backgroundColor = [UIColor lightGrayColor];
    }];
    [self.shareView whenTouchedUp:^{
        weakSelf.shareView.backgroundColor = [UIColor whiteColor];
    }];
    
    [self.settingView whenTouchedDown:^{
        weakSelf.settingView.backgroundColor = [UIColor lightGrayColor];
    }];
    [self.settingView whenTouchedUp:^{
        weakSelf.settingView.backgroundColor = [UIColor whiteColor];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
