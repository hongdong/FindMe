//
//  ZBExpressionSectionBar.m
//  MessageDisplay
//
//  Created by zhoubin@moshi on 14-5-13.
//  Copyright (c) 2014年 Crius_ZB. All rights reserved.
//

#import "ZBExpressionSectionBar.h"

@implementation ZBExpressionSectionBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //self.backgroundColor = [UIColor colorWithRed:255.0f/255 green:250.0f/255 blue:240.0f/255 alpha:1];
        self.backgroundColor = [UIColor whiteColor];
        UIButton *sendBtn = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width-80, 0, 80, frame.size.height)];
        [sendBtn setBackgroundImage:[UIImage imageNamed:@"btBg"] forState:UIControlStateNormal];
        [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
        [sendBtn addTarget:self action:@selector(sendFace:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:sendBtn];

    }
    return self;
}

-(void)sendFace:(id)sender{
    if (_delegate) {
        [_delegate sendFace];
    }
}

@end
