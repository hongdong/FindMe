
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

- (void)dismissHDJGHUDWithHint:(NSString *)hint{
    if ([self HDJGHUD]==nil) {
        return;
    }
    [self HDJGHUD].position = JGProgressHUDPositionBottomCenter;
    [self HDJGHUD].square = NO;
    [self HDJGHUD].contentInsets = UIEdgeInsetsMake(8, 10, 8, 10);
    [self HDJGHUD].layoutChangeAnimationDuration = 0.3;
    [self HDJGHUD].indicatorView = nil;
    [self HDJGHUD].textLabel.text = hint;

    [[self HDJGHUD] dismissAfterDelay:1.0f];
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

- (void)showHint:(NSString *)hint{
    JGProgressHUD *hud = [[JGProgressHUD alloc] initWithStyle:JGProgressHUDStyleExtraLight];
    hud.indicatorView = nil;
    hud.contentInsets = UIEdgeInsetsMake(8, 10, 8, 10);
    hud.position = JGProgressHUDPositionBottomCenter;
    hud.textLabel.text = hint;
    hud.animation = [JGProgressHUDFadeZoomAnimation animation];
    hud.layoutChangeAnimationDuration = 0.0;
    hud.interactionType = JGProgressHUDInteractionTypeBlockAllTouches;
    hud.HUDView.layer.shadowColor = HDRED.CGColor;
    hud.HUDView.layer.shadowOffset = CGSizeZero;
    hud.HUDView.layer.shadowOpacity = 0.4f;
    hud.HUDView.layer.shadowRadius = 8.0f;
    [hud showInView:self];
    [hud dismissAfterDelay:1.0f];
}


@end
