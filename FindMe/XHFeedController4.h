
#import <UIKit/UIKit.h>
#import "Post.h"

@interface XHFeedController4 : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView* feedTableView;

-(void)changeRowWithPost:(Post *)post;
@end
