//
//  ClickImage.h
//  TableView
//
//  Created by LYZ on 14-1-13.
//  Copyright (c) 2014年 LYZ. All rights reserved.
//

#import <UIKit/UIKit.h>
//子类型
@interface ClickImage : UIImageView {
    BOOL isChanged;
    CGRect defaultRect;
    UIImageView *Im;
    UIWindow *window;
    UIImage *fakeImage;
    UIViewController *clickViewController;
    UIView *snapView;
}
// !@brief 为YES时，点击图片有放大到全屏的动画效果，再次点击缩小到原始坐标动画效果
@property (nonatomic ,assign, setter = canClickIt:) BOOL canClick;
@property (nonatomic ,assign) float duration;//动画时间

// !@brief 设定点击时要加载的ViewController,加载方式和消失方式是presentViewController和dismissViewController
- (void)setClickToViewController:(UIViewController*)cViewController;

// !@brief 调用此方法移除子视图
+ (void)dismissClickView;
@end

//代理型，只提供简单功能
@interface UIImageView (Click)

// !@brief 为YES时，点击图片有放大到全屏的动画效果，再次点击缩小到原始坐标动画效果
@property (nonatomic ,assign, setter = canClickIt:) BOOL canClick;

@end