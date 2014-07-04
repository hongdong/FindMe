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
        UIButton *tagButton1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 66, 36)];
        [tagButton1 setImage:[UIImage imageNamed:@"Expression_10@2x"] forState:UIControlStateNormal];

        UIButton *tagButton2 = [[UIButton alloc] initWithFrame:CGRectMake(66, 0, 66, 36)];
        [tagButton2 setImage:[UIImage imageNamed:@"Expression_10@2x"] forState:UIControlStateNormal];
        UIButton *sendButton = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width-55, 0, 55, 36)];
        [sendButton setImage:[UIImage imageNamed:@"Expression_10@2x"] forState:UIControlStateNormal];
        [self addSubview:tagButton1];
        [self addSubview:tagButton2];
        [self addSubview:sendButton];

    }
    return self;
}



@end
