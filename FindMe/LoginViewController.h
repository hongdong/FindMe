//
//  LoginViewController.h
//  FindMe
//
//  Created by mac on 14-7-27.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIScrollView *srollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

-(void)moveToUpSide;

@end
