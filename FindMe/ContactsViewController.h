#import <UIKit/UIKit.h>
@interface ContactsViewController : UIViewController

@property (strong, nonatomic) NSMutableArray *applysArray;

//好友个数变化时，重新获取数据
- (void)myReloadDataSource;

-(void)cleanFriend;
@end
