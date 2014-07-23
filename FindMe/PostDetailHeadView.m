//
//  PostDetailHeadView.m
//  FindMe
//
//  Created by mac on 14-7-2.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "PostDetailHeadView.h"
#import "UIImageView+WebCache.h"
#import "NSDate+Category.h"
#import "NSDateFormatter+Category.h"
@implementation PostDetailHeadView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {


        
        UIFont *font = [UIFont fontWithName:@"Avenir-Book" size:13.0f];
        UIColor* neutralColor = [UIColor colorWithWhite:0.5 alpha:1.0];
        self.contentLbl.lineBreakMode = NSLineBreakByCharWrapping;
        self.contentLbl.textColor =  neutralColor;
        self.contentLbl.font = font;

    }
    return self;
}

-(void)awakeFromNib{
    [super awakeFromNib];

}

-(void)setDataWithPost:(Post *) post{
    [self.image sd_setImageWithURL:[HDTool getLImage:post.postPhoto[0]] placeholderImage:[UIImage imageNamed:@"defaultImage"]];
    
    self.contentLbl.text = post.postContent;
    NSDate *date = [[NSDateFormatter defaultDateFormatter] dateFromString:post.postReleaseTime];
    self.timeLbl.text = [date formattedDateDescription];
    self.replyLbl.text = [post.postMsgNumber stringValue];
    self.markLal.text = [post.postPraise stringValue];
}
@end
