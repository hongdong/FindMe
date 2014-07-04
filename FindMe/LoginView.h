//
//  LoginView.h
//  FindMe
//
//  Created by mac on 14-7-4.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LoginViewDelegate <NSObject>
- (void)login:(UIButton *)sender;
@end

@interface LoginView : UIView<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *pageScroll;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) NSArray *photoList;
@property (nonatomic, assign) id<LoginViewDelegate> delegate;
- (void)moveToUpSide;
@end
