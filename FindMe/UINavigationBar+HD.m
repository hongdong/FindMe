//
//  UINavigationBar+HD.m
//  FindMe
//
//  Created by mac on 14-7-27.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "UINavigationBar+HD.h"

@implementation UINavigationBar (HD)
-(void)hideDividingLine{
    UIImageView *lineView = [self findHairlineFromView:self];
    if (lineView!=nil) {
        [lineView setHidden:YES];
    }
}

- (UIImageView *)findHairlineFromView:(UIView *)view
{
    if ([view isKindOfClass:[UIImageView class]] && view.frame.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    
    for (UIView *subView in view.subviews) {
        UIImageView *imageView = [self findHairlineFromView:subView];
        if (imageView) {
            return imageView;
        }
    }
    
    return nil;
}
@end
