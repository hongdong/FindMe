//
//  LoginViewController.h
//  FindMe
//
//  Created by mac on 14-8-8.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@class User;
@protocol LoginViewControllerDelegate <NSObject>
- (void)shouldShowChooseSchool:(User *)user;
@end

@interface LoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (nonatomic, weak) id<LoginViewControllerDelegate> delegate;
@end
