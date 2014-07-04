//
//  EMSearchBar.h
//  ChatDemo-UI2.0
//
//  Created by dujiepeng on 14-5-26.
//  Copyright (c) 2014年 dujiepeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EMSearchBar : UISearchBar

/**
 *  自定义控件自带的取消按钮的文字（默认为“取消”/“Cancle”）
 *
 *  @param title 自定义文字
 */
- (void)setCancleButtonTitle:(NSString *)title;

@end
