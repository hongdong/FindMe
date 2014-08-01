//
//  UIView+HDHUD.h
//  FindMe
//
//  Created by mac on 14-7-31.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (HDHUD)
-(void)showHDHUDWithTitle:(NSString *)title;
-(void)dismissHDHUD;
-(void)showSuccess;
-(void)showError;
@end
