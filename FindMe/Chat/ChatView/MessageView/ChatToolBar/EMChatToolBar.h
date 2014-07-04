/************************************************************
  *  * EaseMob CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of EaseMob Technologies.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from EaseMob Technologies.
  */

#import <UIKit/UIKit.h>

#import "HPGrowingTextView.h"

@protocol EMChatToolBarDelegate <NSObject>
@optional

// 更多按钮按下后的回调
-(void)chatBarMoreButtonPressed;

// 切换按钮
-(void)chatBarSwitchButtonPressed;

//发送
-(void)chatBarTextReturn:(NSString *)string;

// 录音按钮按下
-(void)recordButtonTouchDown:(UIView *)recordView;

// 手指在按钮内部时离开
-(void)recordButtonTouchUpInside:(UIView *)recordView;

// 手指在按钮外部时离开
-(void)recordButtonTouchUpOutside:(UIView *)recordView;

// 手指移动到按钮内部
-(void)recordButtonDragInside:(UIView *)recordView;

// 手指移动到按钮外部
-(void)recordButtonDragOutside:(UIView *)recordView;

@required
// 传入需要显示的moreView（如果没有，传nil）
-(UIView *)chatBarMoreView;

// 传入用于显示语音时动画的View（如果没有，传nil）
-(UIView *)chatBarRecordView;

// 传入对应调整的tableView（如果没有，传nil）
-(UITableView *)chatBarTableView;

@end

@interface EMChatToolBar : UIView

@property (weak, nonatomic, readonly) UIViewController<EMChatToolBarDelegate> *dependController;

@property (weak, nonatomic) IBOutlet HPGrowingTextView *textView;

/**
 *  初始化ToolBar
 *
 *  @param viewController 要显示toolBar的controller（需要实现ChatToolBarDelegate, ChatShareMoreDelegate委托）
 *  @param view           用于显示Record的View（可以自定义view传入，显示对应效果或事件）
 *
 *  @return ChatToolBar
 */
-(id)initWithViewController:(UIViewController<EMChatToolBarDelegate> *)viewController;

-(void)decideInputView:(UIView *)usedView;

- (void)switchToText;
- (void)switchToRecord;

@end
