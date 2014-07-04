#import <UIKit/UIKit.h>
#import <MBProgressHUD.h>


typedef enum
{
	ResultSuccess = 0,           /**返回成功*/
	ResultError = 1,          /**<返回错误*/
}
ResultType;

@interface UIViewController (HUD)<MBProgressHUDDelegate>

- (void)showHudInView:(UIView *)view;

- (void)showHudInView:(UIView *)view hint:(NSString *)hint;

- (void)showResultWithType:(ResultType)type;

- (void)hideHud;

- (void)showHint:(NSString *)hint;

@end
