#import "UIViewController+HUD.h"
#import "MBProgressHUD.h"
#import <objc/runtime.h>

static const void *HttpRequestHUDKey = &HttpRequestHUDKey;

@implementation UIViewController (HUD)

- (MBProgressHUD *)HUD{
    return objc_getAssociatedObject(self, HttpRequestHUDKey);
}

- (void)setHUD:(MBProgressHUD *)HUD{
    objc_setAssociatedObject(self, HttpRequestHUDKey, HUD, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)showHudInView:(UIView *)view hint:(NSString *)hint{
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:view];
    HUD.labelText = hint;
    HUD.delegate = self;
    [view addSubview:HUD];
    [HUD show:YES];
    [self setHUD:HUD];
}
- (void)showHudInView:(UIView *)view{
    [self showHudInView:view hint:@"加载中..."];
}





- (void)showResultWithType:(ResultType)type{
    UIImageView *imageView;
    if (type==ResultSuccess) {

            UIImage *image = [UIImage imageNamed:@"HUD_YES"];
            imageView = [[UIImageView alloc] initWithImage:image];
        
        
        [self HUD].customView = imageView;
        [self HUD].mode = MBProgressHUDModeCustomView;
        [self HUD].labelText = @"加载完成";

    }else{

            UIImage *image = [UIImage imageNamed:@"HUD_NO"];
            imageView = [[UIImageView alloc] initWithImage:image];

        
        [self HUD].customView = imageView;
        [self HUD].mode = MBProgressHUDModeCustomView;
        [self HUD].labelText = @"加载失败";

    }
        [[self HUD] hide:YES afterDelay:1];
}

- (void)showHint:(NSString *)hint{
    //显示提示信息
    UIView *view = [[UIApplication sharedApplication].delegate window];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.userInteractionEnabled = NO;
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = hint;
    hud.margin = 10.f;
    hud.yOffset = IS_IPHONE_5?200.f:150.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1.5];
}

- (void)hideHud{
    [[self HUD] hide:YES];
}

#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
	// Remove HUD from screen when the HUD was hidded
	[[self HUD] removeFromSuperview];

}
@end
