//
//  DXChatBarMoreView.h
//  Share
//
//  Created by xieyajie on 14-4-15.
//  Copyright (c) 2014年 Share. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DXChatBarMoreViewDelegate;
@interface DXChatBarMoreView : UIView

@property (nonatomic,assign) id<DXChatBarMoreViewDelegate> delegate;

@property (nonatomic, strong) UIButton *photoButton;
@property (nonatomic, strong) UIButton *takePicButton;
@property (nonatomic, strong) UIButton *locationButton;
@property (nonatomic, strong) UIButton *videoButton;
- (void)setupSubviews;

@end

@protocol DXChatBarMoreViewDelegate <NSObject>

@required
- (void)moreViewTakePicAction:(DXChatBarMoreView *)moreView;
- (void)moreViewPhotoAction:(DXChatBarMoreView *)moreView;
- (void)moreViewLocationAction:(DXChatBarMoreView *)moreView;
- (void)moreViewVideoAction:(DXChatBarMoreView *)moreView;
@end
