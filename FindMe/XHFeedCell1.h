
#import <UIKit/UIKit.h>
#import "Post.h"
@interface XHFeedCell1 : UITableViewCell
@property(nonatomic,strong) Post *post;

@property (nonatomic, strong) UIImageView* profileImageView;

@property (nonatomic, strong) UIView* feedContainer;

@property (nonatomic, strong) UILabel* nameLabel;

@property (nonatomic, strong) UILabel* watchLabel;

@property (nonatomic, strong) UILabel* updateLabel;

@property (nonatomic, strong) UILabel* dateLabel;

@property (nonatomic, strong) UILabel* commentCountLabel;

@property (nonatomic, strong) UILabel* likeCountLabel;

@property (nonatomic, strong) UIView* socialContainer;
@end
