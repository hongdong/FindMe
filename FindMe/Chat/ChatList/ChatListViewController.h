#import <UIKit/UIKit.h>
#import "EaseMobHeaders.h"
@interface ChatListViewController : UIViewController

- (void)refreshDataSource;

- (void)networkChanged:(EMConnectionState)connectionState;

@end
