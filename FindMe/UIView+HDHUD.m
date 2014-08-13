//
//  UIView+HDHUD.m
//  FindMe
//
//  Created by mac on 14-7-31.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "UIView+HDHUD.h"
#import "MRProgressOverlayView.h"
#import "MRActivityIndicatorView.h"
#import <objc/runtime.h>
static const void *HDHUDKey = &HDHUDKey;
@implementation UIView (HDHUD)


- (MRProgressOverlayView *)HUD{
    return objc_getAssociatedObject(self, HDHUDKey);
}

- (void)setHUD:(MRProgressOverlayView *)HUD{
    objc_setAssociatedObject(self, HDHUDKey, HUD, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(void)showHDHUDWithTitle:(NSString *)title{
   MRProgressOverlayView *HUD = [MRProgressOverlayView showOverlayAddedTo:self title:title mode:MRProgressOverlayViewModeIndeterminate animated:YES];
    [HUD setTintColor:HDRED];
    ((MRActivityIndicatorView *)HUD.modeView).lineWidth = 1.0f;
    [self setHUD:HUD];
}
-(void)dismissHDHUD{
    if ([self HUD]==nil) {
        return;
    }
    __weak __typeof(&*self)weakSelf = self;
    [[self HUD] dismiss:YES completion:^{
        [[weakSelf HUD] removeFromSuperview];
    }];
}
-(void)showSuccess{
    if ([self HUD]==nil) {
        return;
    }
    __weak __typeof(&*self)weakSelf = self;
    [[self HUD] setMode:MRProgressOverlayViewModeCheckmark];
    [[self HUD] setTitleLabelText:@"完成"];
    [self performBlock:^{
        [weakSelf dismissHDHUD];
    } afterDelay:0.5];
    
}
-(void)showError{
    if ([self HUD]==nil) {
        return;
    }
    __weak __typeof(&*self)weakSelf = self;
    [[self HUD] setMode:MRProgressOverlayViewModeCross];
    [[self HUD] setTitleLabelText:@"失败"];
    [self performBlock:^{
        [weakSelf dismissHDHUD];
    } afterDelay:0.5];
}

- (void)performBlock:(void(^)())block afterDelay:(NSTimeInterval)delay {
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), block);
}
@end
