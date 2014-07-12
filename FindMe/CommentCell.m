//
//  CommentCell.m
//  FindMe
//
//  Created by mac on 14-7-2.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "CommentCell.h"
#import "NSDate+Category.h"
#import "NSDateFormatter+Category.h"
@implementation CommentCell{
    NSDateFormatter *_dateFormatter;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        UIFont *font = [UIFont fontWithName:@"Avenir-Book" size:13.0f];
        UIColor* neutralColor = [UIColor colorWithWhite:0.5 alpha:1.0];
        self.content = [[HBCoreLabel alloc] initWithFrame:CGRectMake(18, 8, 280, 0)];
        self.content.lineBreakMode = NSLineBreakByCharWrapping;
        self.content.textColor =  neutralColor;
        self.content.font = font;
        
        _dateFormatter = [NSDateFormatter defaultDateFormatter];
    }
    return self;
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    [self.contentView addSubview:self.content];
}


-(void)layoutSubviews{
    [super layoutSubviews];
    [self.comment setMatch];
    MatchParser * match= [self.comment getMatch];
    self.content.match = match;

    self.content.frame = CGRectMake(18, 8, 280, match.height);
    
    self.imageView.frame = CGRectMake(18, 8+self.content.frame.size.height+5, 20, 20);
    
    self.floorLbl.frame = CGRectMake(18+20+4+10, 8+self.content.frame.size.height+5, 26, 20);
    self.floorLbl.text = [NSString stringWithFormat:@"%ld楼",(long)self.row+1];
    
    self.timeLbl.frame = CGRectMake(18+20+4+26+4+10, 8+self.content.frame.size.height+5, 80, 20);
    NSDate *date = [_dateFormatter dateFromString:self.comment.postMsgTime];
    self.timeLbl.text = [date formattedDateDescription];
    
    self.hostLbl.frame = CGRectMake(18+20+4+80+4+26+4, 8+self.content.frame.size.height+5, 26, 20);
 
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}


@end
