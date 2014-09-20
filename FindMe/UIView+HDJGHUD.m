
#import "UIView+HDJGHUD.h"
#import "JGProgressHUD.h"
#import "JGProgressHUDSuccessIndicatorView.h"
#import "JGProgressHUDErrorIndicatorView.h"
#import "JGProgressHUDFadeZoomAnimation.h"
#import <objc/runtime.h>
static const void *HDJGHUDKey = &HDJGHUDKey;
@implementation UIView (HDJGHUD)


- (JGProgressHUD *)HDJGHUD{
    return objc_getAssociatedObject(self, HDJGHUDKey);
}

- (void)setHDJGHUD:(JGProgressHUD *)HUD{
    objc_setAssociatedObject(self, HDJGHUDKey, HUD, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(void)showHDJGHUDWithTitle:(NSString *)title{
    JGProgressHUD *HUD = [[JGProgressHUD alloc] initWithStyle:JGProgressHUDStyleExtraLight];
    HUD.textLabel.text = title;
    HUD.animation = [JGProgressHUDFadeZoomAnimation animation];
    HUD.square = YES;
    HUD.layoutChangeAnimationDuration = 0.0;
    HUD.interactionType = JGProgressHUDInteractionTypeBlockAllTouches;
    HUD.HUDView.layer.shadowColor = HDRED.CGColor;
    HUD.HUDView.layer.shadowOffset = CGSizeZero;
    HUD.HUDView.layer.shadowOpacity = 0.4f;
    HUD.HUDView.layer.shadowRadius = 8.0f;
    [self setHDJGHUD:HUD];
    
    [HUD showInView:self];
}
-(void)dismissHDJGHUD{
    if ([self HDJGHUD]==nil) {
        return;
    }
    
    [[self HDJGHUD] dismiss];
}
-(void)showHDJGHUDSuccess{
    if ([self HDJGHUD]==nil) {
        return;
    }
    
    [self HDJGHUD].textLabel.text = @"完成";
//    [self HDJGHUD].detailTextLabel.text = nil;
    [self HDJGHUD].layoutChangeAnimationDuration = 0.3;
    [self HDJGHUD].indicatorView = [[JGProgressHUDSuccessIndicatorView alloc] init];

    [[self HDJGHUD] dismissAfterDelay:0.4];
    
}
-(void)showHDJGHUDError{
    if ([self HDJGHUD]==nil) {
        return;
    }
    
    [self HDJGHUD].textLabel.text = @"失败";
//    [self HDJGHUD].detailTextLabel.text = nil;
    [self HDJGHUD].layoutChangeAnimationDuration = 0.3;
    [self HDJGHUD].indicatorView = [[JGProgressHUDErrorIndicatorView alloc] init];
    
    [[self HDJGHUD] dismissAfterDelay:0.4];
}

@end
