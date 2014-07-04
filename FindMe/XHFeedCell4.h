#import <UIKit/UIKit.h>
#import "Post.h"
#import "RCLabel.h"
@interface XHFeedCell4 : UITableViewCell

@property(nonatomic,strong) Post *post;

@property (nonatomic, strong) UIImageView* picImageView;

@property (nonatomic, strong) UIImageView* profileImageView;

@property (nonatomic, strong) UIView* feedContainer;

@property (nonatomic, strong) UILabel* nameLabel;

@property (nonatomic, strong) RCLabel* updateLabel;

@property (nonatomic, strong) UILabel* dateLabel;

@property (nonatomic, strong) UILabel* commentCountLabel;

@property (nonatomic, strong) UILabel* likeCountLabel;

@property (nonatomic, strong) UIView* socialContainer;


+(CGFloat)getCellHightWithPost:(Post *)post;
@end
