//
//  CommentCell.m
//  FindMe
//
//  Created by mac on 14-7-2.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "CommentCell.h"
#import "HtmlString.h"
@implementation CommentCell

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
        self.content = [[RCLabel alloc] initWithFrame:CGRectMake(18, 8, 280, 0)];
        self.content.lineBreakMode = NSLineBreakByCharWrapping;
        self.content.textColor =  neutralColor;
        self.content.font = font;
        
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
    NSString *transformStr = [HtmlString transformString:self.comment.postMsgContent];
    RCLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle:transformStr];
    self.content.componentsAndPlainText = componentsDS;
    CGSize optimalSize = [self.content optimumSize:YES];
    self.content.frame = CGRectMake(18, 8, 280, optimalSize.height);
    
    self.imageView.frame = CGRectMake(18, 8+self.content.frame.size.height+5, 20, 20);
    
    self.floorLbl.frame = CGRectMake(18+20+4+10, 8+self.content.frame.size.height+5, 26, 20);
    
    self.timeLbl.frame = CGRectMake(18+20+4+26+4+10, 8+self.content.frame.size.height+5, 80, 20);
    
    self.hostLbl.frame = CGRectMake(18+20+4+80+4+26+4, 8+self.content.frame.size.height+5, 26, 20);
 
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}
+ (CGFloat)getHeight:(Comment *)comment{
    UIFont *updateLabelFont = [UIFont fontWithName:@"Avenir-Book" size:13.0f];
    NSString *transformStr = [HtmlString transformString:comment.postMsgContent];
    RCLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle:transformStr];
    RCLabel *tempLabel = [[RCLabel alloc] initWithFrame:CGRectZero];
    tempLabel.frame = CGRectMake(8, 8, 280, 0);
    [tempLabel setFont:updateLabelFont];
    tempLabel.componentsAndPlainText = componentsDS;
    tempLabel.lineBreakMode =NSLineBreakByCharWrapping;
    CGSize optimalSize = [tempLabel optimumSize:YES];
    return optimalSize.height + 40;
}

@end
