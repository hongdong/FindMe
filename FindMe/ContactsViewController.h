#import <UIKit/UIKit.h>
@interface ContactsViewController : UIViewController

@property (strong, nonatomic) NSMutableArray *applysArray;

//好友请求变化时，更新好友请求未处理的个数
- (void)reloadApplyView;
//好友个数变化时，重新获取数据
- (void)myReloadDataSource;
@end
