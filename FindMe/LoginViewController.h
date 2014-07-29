//
//  LoginViewController.h
//  FindMe
//
//  Created by mac on 14-7-27.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ShareSDK/ShareSDK.h>
@interface LoginViewController : UIViewController<ISSViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *srollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

-(void)moveToUpSide;

@end
