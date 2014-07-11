
#import "XHFeedCell1.h"
#import "UIImageView+MJWebCache.h"
#import "NSDate+Category.h"
#import "NSDateFormatter+Category.h"
#import "UIColor+FlatUI.h"
#define feedContainerX 20
#define feedContainerWidth 280
#define feedContainerHieght 304

#define profileImageViewX 4
#define profileImageViewSize 35

#define nameLabelX 51
#define nameLabelWidth 190
#define nameLabelHeight 21

#define dateLabelSpeatorY 20
#define dateLabelWidth 224

#define updateLabelX 9
#define updateLabelY 41
#define updateLabelWidth 263
#define updateLabelHeight 220


#define commentCountLabelX 17
#define commentCountLabelY 8
#define commentCountLabelWidth 130

#define likeCountLabelSpeator 20
#define likeCountLabelWidth 96

#define socialContainerSepatorY 6
#define socialContainerHeight 37
@implementation XHFeedCell1{
    NSDateFormatter *_dateFormatter;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _dateFormatter = [NSDateFormatter defaultDateFormatter];
        
        self.contentView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _feedContainer = [[UIView alloc] initWithFrame:CGRectZero];

        _feedContainer.layer.cornerRadius = 6.0f;
        _feedContainer.clipsToBounds = YES;
        _feedContainer.layer.shadowPath = [UIBezierPath bezierPathWithRect:_feedContainer.bounds].CGPath;
        [[_feedContainer layer] setBorderWidth:0.1];
        [[_feedContainer layer] setBorderColor:[UIColor lightGrayColor].CGColor];
        
        UIColor* mainColor = [UIColor colorWithRed:100.0/255 green:35.0/255 blue:87.0/255 alpha:1.0f];
        UIColor* countColor = [UIColor colorWithRed:116.0/255 green:99.0/255 blue:113.0/255 alpha:1.0f];
        UIColor* neutralColor = [UIColor colorWithWhite:0.5 alpha:1.0];
        
        NSString* fontName = @"Avenir-Book";
        NSString* boldFontName = @"Avenir-Black";
        
        _profileImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        
        UIFont *nameLabelFont = [UIFont fontWithName:boldFontName size:17.0f];
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _nameLabel.textColor =  [UIColor whiteColor];
        _nameLabel.font = nameLabelFont;
        
        
        UIFont *updateLabelFont = [UIFont fontWithName:fontName size:13.0f];
        _updateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _updateLabel.textAlignment = NSTextAlignmentCenter;
        _updateLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _updateLabel.backgroundColor = [UIColor clearColor];
        _updateLabel.textColor =  [UIColor whiteColor];
        _updateLabel.font = updateLabelFont;
        
        
        UIFont *dateLabelFont = [UIFont fontWithName:fontName size:12.0f];
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _dateLabel.textColor = [UIColor whiteColor];
        _dateLabel.font = dateLabelFont;
        
        UIFont *countLabelFont = [UIFont fontWithName:fontName size:14.0f];
        _commentCountLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _commentCountLabel.textColor = countColor;
        _commentCountLabel.backgroundColor = [UIColor clearColor];
        _commentCountLabel.font = countLabelFont;
        
        _likeCountLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _likeCountLabel.textAlignment = NSTextAlignmentRight;
        
        _likeCountLabel.textColor = countColor;
        _likeCountLabel.backgroundColor = [UIColor clearColor];
        _likeCountLabel.font = countLabelFont;
        
        
        _socialContainer = [[UIView alloc] initWithFrame:CGRectZero];
        _socialContainer.backgroundColor = [UIColor colorWithRed:220.0/255 green:214.0/255 blue:219.0/255 alpha:1.0f];
        
        
        
        _feedContainer.frame = CGRectMake(feedContainerX, feedContainerX, feedContainerWidth, feedContainerHieght);
        
        _profileImageView.frame = CGRectMake(profileImageViewX, profileImageViewX, profileImageViewSize, profileImageViewSize);
        
        _nameLabel.frame = CGRectMake(nameLabelX, _profileImageView.frame.origin.y, nameLabelWidth, nameLabelHeight);
        
        _dateLabel.frame = CGRectMake(_nameLabel.frame.origin.x+5, _nameLabel.frame.origin.y + dateLabelSpeatorY, dateLabelWidth, _nameLabel.frame.size.height);
        
        _updateLabel.frame = CGRectMake(updateLabelX, updateLabelY, updateLabelWidth, updateLabelHeight);
        
        _commentCountLabel.frame = CGRectMake(commentCountLabelX, commentCountLabelY, commentCountLabelWidth, _nameLabel.frame.size.height);
        _likeCountLabel.frame = CGRectMake(_commentCountLabel.frame.origin.x + _commentCountLabel.frame.size.width + likeCountLabelSpeator, _commentCountLabel.frame.origin.y, likeCountLabelWidth, _nameLabel.frame.size.height);
        
        _socialContainer.frame = CGRectMake(0, _updateLabel.frame.origin.y + _updateLabel.frame.size.height + socialContainerSepatorY, _feedContainer.frame.size.width, socialContainerHeight);
        
        [_feedContainer addSubview:self.profileImageView];
        [_feedContainer addSubview:self.nameLabel];
        [_feedContainer addSubview:self.dateLabel];
        [_feedContainer addSubview:self.updateLabel];
        
        [_socialContainer addSubview:self.likeCountLabel];
        [_socialContainer addSubview:self.commentCountLabel];
        
        [_feedContainer addSubview:self.socialContainer];
        
        [self.contentView addSubview:self.feedContainer];
        
        
        
        
        
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    _feedContainer.backgroundColor = [UIColor randomColor];
    NSDate *date = [_dateFormatter dateFromString:self.post.postReleaseTime];
    self.dateLabel.text = [date formattedDateDescription];
    self.updateLabel.text = self.post.postContent;
    
    self.likeCountLabel.text = [NSString stringWithFormat:@"赞 %@",self.post.postPraise];
    self.commentCountLabel.text = [NSString stringWithFormat:@"回复 %@",self.post.postMsgNumber];
    if ([self.post.postOfficial intValue]==2) {
        [self.profileImageView setImage:[UIImage imageNamed:@"findme1"]];
        self.nameLabel.text = @"匿名发布";
    }else{
        [self.profileImageView setImage:[UIImage imageNamed:@"findme1"]];
        self.nameLabel.text = @"官方发布";
    }
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
