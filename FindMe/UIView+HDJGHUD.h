
#import <UIKit/UIKit.h>

@interface UIView (HDJGHUD)
- (void)showHDJGHUDWithTitle:(NSString *)title;
- (void)dismissHDJGHUD;
- (void)dismissHDJGHUDWithHint:(NSString *)hint;
- (void)showHDJGHUDSuccess;
- (void)showHDJGHUDError;
- (void)showHint:(NSString *)hint;
@end
